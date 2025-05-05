// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:muipzi/models/location.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _apiKey = "devU01TX0FVVEgyMDI1MDUwNTE2MTA1ODExNTcxOTY=";
  static const String _baseUrl =
      'https://business.juso.go.kr/addrlink/addrLinkApi.do';

  Future<List<Location>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      // 2글자 미만일 경우 Firestore에서만 검색
      if (query.length < 2) {
        print('2글자 미만 검색어: Firestore 검색');
        return await searchFromFirestore(query);
      }

      print('API 요청: $query');

      // URL을 직접 구성하여 이중 인코딩 방지
      final uri = Uri.parse(
        '$_baseUrl?confmKey=$_apiKey&currentPage=1&countPerPage=100&keyword=$query&resultType=json',
      );
      print('API 요청 URL: ${uri.toString()}');

      try {
        final response = await http
            .get(uri)
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                print('API 요청 시간 초과');
                throw TimeoutException('API 요청 시간이 초과되었습니다.');
              },
            );

        print('API 응답 상태 코드: ${response.statusCode}');

        if (response.statusCode != 200) {
          print('API 응답 실패: ${response.statusCode}');
          return await searchFromFirestore(query);
        }

        String responseBody;
        try {
          responseBody = utf8.decode(response.bodyBytes);
        } catch (e) {
          print('응답 디코딩 오류: $e');
          return await searchFromFirestore(query);
        }

        Map<String, dynamic> data;
        try {
          data = json.decode(responseBody) as Map<String, dynamic>;
        } catch (e) {
          print('JSON 파싱 오류: $e');
          return await searchFromFirestore(query);
        }

        if (data['results'] == null) {
          print('API 응답에 results 필드가 없음');
          return await searchFromFirestore(query);
        }

        final results = data['results'] as Map<String, dynamic>;
        if (results['common'] == null) {
          print('API 응답에 common 필드가 없음');
          return await searchFromFirestore(query);
        }

        final common = results['common'] as Map<String, dynamic>;
        final errorCode = common['errorCode']?.toString() ?? '';
        final errorMessage = common['errorMessage']?.toString() ?? '';

        if (errorCode != '0') {
          print('API 에러: [$errorCode] $errorMessage');
          return await searchFromFirestore(query);
        }

        final totalCount =
            int.tryParse(common['totalCount']?.toString() ?? '0') ?? 0;
        if (totalCount == 0) {
          print('검색 결과 없음 (totalCount: 0)');
          return [];
        }

        final jusoList = results['juso'] as List?;
        if (jusoList == null || jusoList.isEmpty) {
          print('검색 결과 없음 (jusoList empty)');
          return [];
        }

        print('API 검색 결과: ${jusoList.length}개');

        // 시도와 시군구 정보만 추출하여 중복 제거
        final uniqueLocations = <String, Location>{};

        for (final juso in jusoList) {
          final siNm = juso['siNm']?.toString() ?? '';
          final sggNm = juso['sggNm']?.toString() ?? '';

          // 시도나 시군구 정보가 없는 경우 건너뛰기
          if (siNm.isEmpty || sggNm.isEmpty) continue;

          final locationKey = '$siNm-$sggNm';

          // 이미 처리된 시군구는 건너뛰기
          if (uniqueLocations.containsKey(locationKey)) continue;

          uniqueLocations[locationKey] = Location(
            id: locationKey,
            sido: siNm,
            sigungu: sggNm,
            displayName: '$siNm $sggNm',
          );
        }

        final filteredResults =
            uniqueLocations.values.toList()
              ..sort((a, b) => a.displayName.compareTo(b.displayName));

        print('중복 제거 후 결과: ${filteredResults.length}개');
        return filteredResults;
      } catch (e) {
        print('API 요청 실패: $e');
        return await searchFromFirestore(query);
      }
    } catch (e, stackTrace) {
      print('검색 중 오류 발생: $e');
      print('스택 트레이스: $stackTrace');
      return await searchFromFirestore(query);
    }
  }

  // Firestore에서 검색하는 함수
  Future<List<Location>> searchFromFirestore(String query) async {
    try {
      final lowercaseQuery = query.toLowerCase();

      // 먼저 정확한 키워드 매칭 시도
      var snapshot =
          await _firestore
              .collection('locations')
              .where('searchKeywords', arrayContains: lowercaseQuery)
              .orderBy('displayName')
              .limit(20)
              .get();

      if (snapshot.docs.isEmpty) {
        // 정확한 매치가 없을 경우 부분 검색 시도
        snapshot =
            await _firestore
                .collection('locations')
                .orderBy('displayName')
                .get();

        return snapshot.docs
            .map((doc) => Location.fromJson(doc.data()))
            .where(
              (location) =>
                  location.displayName.toLowerCase().contains(lowercaseQuery) ||
                  location.sido.toLowerCase().contains(lowercaseQuery) ||
                  location.sigungu.toLowerCase().contains(lowercaseQuery),
            )
            .take(20)
            .toList();
      }

      return snapshot.docs.map((doc) => Location.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error searching from Firestore: $e');
      return [];
    }
  }

  // Firestore에 데이터 저장하는 함수
  Future<void> storeLocations(List<Location> locations) async {
    try {
      final batch = _firestore.batch();
      final locationsRef = _firestore.collection('locations');

      for (final location in locations) {
        final searchKeywords =
            {
              location.sido.toLowerCase(),
              location.sigungu.toLowerCase(),
              location.displayName.toLowerCase(),
              ...location.sido
                  .split('')
                  .where((char) => char.trim().isNotEmpty),
              ...location.sigungu
                  .split('')
                  .where((char) => char.trim().isNotEmpty),
            }.toList();

        final data = {
          'id': location.id,
          'sido': location.sido,
          'sigungu': location.sigungu,
          'displayName': location.displayName,
          'searchKeywords': searchKeywords,
        };

        final docRef = locationsRef.doc(location.id);
        batch.set(docRef, data, SetOptions(merge: true));
      }

      await batch.commit();
      print('Successfully stored locations in Firestore');
    } catch (e) {
      print('Error storing locations: $e');
      rethrow;
    }
  }

  Future<void> fetchAndStoreLocations() async {
    try {
      final batch = _firestore.batch();
      final locationsRef = _firestore.collection('locations');

      // 전체 주소 데이터 조회
      final response = await http.get(
        Uri.parse(
          '$_baseUrl?confmKey=$_apiKey&currentPage=1&countPerPage=1000&resultType=json&keyword=읍면동',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results']['juso'] as List;

        final Set<String> processedLocations = {};

        for (final item in results) {
          final sido = item['siNm'] as String;
          final sigungu = item['sggNm'] as String;

          // 중복 방지를 위한 키 생성
          final locationKey = '$sido-$sigungu';

          if (sigungu.isNotEmpty && !processedLocations.contains(locationKey)) {
            processedLocations.add(locationKey);

            final id =
                '${sido.replaceAll(RegExp(r'[^a-zA-Z0-9가-힣]'), '')}-${sigungu.replaceAll(RegExp(r'[^a-zA-Z0-9가-힣]'), '')}';
            final displayName = '$sido $sigungu';

            // 검색 키워드 생성 개선
            final searchKeywords =
                {
                  sido.toLowerCase(),
                  sigungu.toLowerCase(),
                  displayName.toLowerCase(),
                  ...sido.split('').where((char) => char.trim().isNotEmpty),
                  ...sigungu.split('').where((char) => char.trim().isNotEmpty),
                }.toList();

            final data = {
              'id': id,
              'sido': sido,
              'sigungu': sigungu,
              'displayName': displayName,
              'searchKeywords': searchKeywords,
            };

            final docRef = locationsRef.doc(id);
            batch.set(docRef, data);
          }
        }
      }

      await batch.commit();
      print('Successfully fetched and stored location data');
    } catch (e) {
      print('Error fetching and storing locations: $e');
      rethrow;
    }
  }

  // 임시 데이터 설정 (테스트용)
  Future<void> initializeLocationData() async {
    final batch = _firestore.batch();
    final locationsRef = _firestore.collection('locations');

    final locations = [
      {
        'id': 'seoul-jongno',
        'sido': '서울특별시',
        'sigungu': '종로구',
        'displayName': '서울특별시 종로구',
        'searchKeywords': ['서울특별시', '종로구', '서울특별시 종로구'],
      },
      {
        'id': 'seoul-jung',
        'sido': '서울특별시',
        'sigungu': '중구',
        'displayName': '서울특별시 중구',
        'searchKeywords': ['서울특별시', '중구', '서울특별시 중구'],
      },
    ];

    for (final location in locations) {
      final docRef = locationsRef.doc(location['id'] as String);
      batch.set(docRef, location);
    }

    await batch.commit();
  }
}
