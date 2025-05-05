import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muipzi/models/location.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Location>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    try {
      // 검색어를 소문자로 변환
      final lowercaseQuery = query.toLowerCase();

      // Firestore에서 데이터 가져오기
      final snapshot =
          await _firestore.collection('locations').orderBy('displayName').get();

      // 검색어와 일치하는 결과 필터링
      return snapshot.docs
          .map((doc) => Location.fromJson(doc.data()))
          .where(
            (location) =>
                location.displayName.toLowerCase().contains(lowercaseQuery),
          )
          .toList();
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  // 초기 데이터 설정 (관리자용)
  Future<void> initializeLocationData() async {
    final batch = _firestore.batch();
    final locationsRef = _firestore.collection('locations');

    final locations = [
      {
        'id': 'seoul-jongno',
        'sido': '서울특별시',
        'sigungu': '종로구',
        'displayName': '서울특별시 종로구',
      },
      {
        'id': 'seoul-jung',
        'sido': '서울특별시',
        'sigungu': '중구',
        'displayName': '서울특별시 중구',
      },
      // 여기에 더 많은 지역 데이터 추가
    ];

    for (final location in locations) {
      final docRef = locationsRef.doc(location['id'] as String);
      batch.set(docRef, location);
    }

    await batch.commit();
  }
}
