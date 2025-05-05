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
      print('Firestore 검색 시작: $query');
      final lowercaseQuery = query.toLowerCase().trim();

      if (lowercaseQuery.isEmpty) {
        print('검색어가 비어있음');
        return [];
      }

      print('Firestore 쿼리 시작: searchKeywords contains "$lowercaseQuery"');

      // 전체 문서를 가져와서 클라이언트에서 필터링
      final snapshot =
          await _firestore.collection('locations').orderBy('displayName').get();

      print('Firestore 전체 문서 수: ${snapshot.docs.length}개');

      final List<Location> results = [];
      final Set<String> addedIds = {};

      // 검색어로 시작하는 결과 먼저 찾기
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final location = Location.fromJson(data);

        // searchKeywords 디버깅
        final searchKeywords =
            (data['searchKeywords'] as List<dynamic>?)?.cast<String>() ?? [];
        print('문서 ID: ${doc.id}, 키워드: $searchKeywords');

        if (location.displayName.toLowerCase().contains(lowercaseQuery) ||
            location.sido.toLowerCase().contains(lowercaseQuery) ||
            location.sigungu.toLowerCase().contains(lowercaseQuery)) {
          if (!addedIds.contains(location.id)) {
            results.add(location);
            addedIds.add(location.id);
          }
        }
      }

      // 정렬: 정확한 매칭 결과가 앞으로 오도록
      results.sort((a, b) {
        final aStartsWith = a.displayName.toLowerCase().startsWith(
          lowercaseQuery,
        );
        final bStartsWith = b.displayName.toLowerCase().startsWith(
          lowercaseQuery,
        );

        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;

        return a.displayName.compareTo(b.displayName);
      });

      // 결과 개수 제한
      final limitedResults = results.take(20).toList();

      print('검색 결과: ${limitedResults.length}개');
      print('검색된 지역: ${limitedResults.map((e) => e.displayName).join(', ')}');

      return limitedResults;
    } catch (e, stackTrace) {
      print('Firestore 검색 오류: $e');
      print('스택 트레이스: $stackTrace');
      return [];
    }
  }

  // Firestore에 데이터 저장하는 함수
  Future<void> storeLocations(List<Location> locations) async {
    try {
      final batch = _firestore.batch();
      final locationsRef = _firestore.collection('locations');

      for (final location in locations) {
        // 검색 키워드 생성 개선
        final searchKeywords =
            <String>{
              location.sido.toLowerCase(),
              location.sigungu.toLowerCase(),
              location.displayName.toLowerCase(),
              // 초성 추출
              ...location.sido.split(''),
              ...location.sigungu.split(''),
              // 부분 문자열 추가
              ...generatePartialStrings(location.sido),
              ...generatePartialStrings(location.sigungu),
            }.toList();

        final data = {
          'id': location.id,
          'sido': location.sido,
          'sigungu': location.sigungu,
          'displayName': location.displayName,
          'searchKeywords': searchKeywords,
        };

        print('저장할 데이터: $data');
        final docRef = locationsRef.doc(location.id);
        batch.set(docRef, data, SetOptions(merge: true));
      }

      await batch.commit();
      print('Firestore에 위치 데이터 저장 완료');
    } catch (e, stackTrace) {
      print('위치 데이터 저장 오류: $e');
      print('스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  // 부분 문자열 생성 함수
  List<String> generatePartialStrings(String text) {
    final Set<String> partials = {};
    final normalized = text.toLowerCase();

    for (int i = 0; i < normalized.length; i++) {
      for (int j = i + 1; j <= normalized.length; j++) {
        partials.add(normalized.substring(i, j));
      }
    }

    return partials.toList();
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

  // 데이터 초기화
  Future<void> initializeLocationData() async {
    try {
      print('기존 데이터 삭제 시작');
      // 기존 데이터 삭제
      final snapshot = await _firestore.collection('locations').get();
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      print('기존 데이터 삭제 완료');

      // API에서 실제 데이터 가져오기
      print('API에서 데이터 가져오기 시작');
      await fetchAndStoreLocations();
      print('데이터 초기화 완료');
    } catch (e, stackTrace) {
      print('데이터 초기화 오류: $e');
      print('스택 트레이스: $stackTrace');
      rethrow;
    }
  }
}
