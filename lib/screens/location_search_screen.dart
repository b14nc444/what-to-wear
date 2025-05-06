// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muipzi/models/location.dart';
import 'package:muipzi/screens/home/home_screen.dart';
import 'package:muipzi/services/location_service.dart';
import 'package:muipzi/theme/app_colors.dart';
import 'package:muipzi/widgets/custom_search_bar.dart';
import 'package:muipzi/widgets/location_search_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final LocationService _locationService = LocationService();
  Timer? _debounce;
  List<Location> _searchResults = [];
  bool _isLoading = false;
  String? _error;
  Location? _selectedLocation;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('검색 시작: $query'); // 디버깅용 로그
      final results = await _locationService.searchLocations(query);
      print('검색 결과: ${results.length}개'); // 디버깅용 로그

      // 컴포넌트가 마운트된 상태인지 확인
      if (!mounted) return;

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
      // 유지된 선택이 새 결과에 없으면 초기화
      if (_selectedLocation != null &&
          !_searchResults.contains(_selectedLocation)) {
        setState(() {
          _selectedLocation = null;
        });
      }
    } catch (e, stackTrace) {
      print('검색 오류 발생: $e'); // 디버깅용 로그
      print('스택 트레이스: $stackTrace'); // 디버깅용 로그

      // 컴포넌트가 마운트된 상태인지 확인
      if (!mounted) return;

      setState(() {
        _error = '검색 중 오류가 발생했습니다. 다시 시도해주세요.';
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _onLocationSelected(Location location, int index) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                //검색
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.gray700,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomSearchBar(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                //검색결과
                Expanded(
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.gray900,
                            ),
                          )
                          : _error != null
                          ? Center(
                            child: Text(
                              _error!,
                              style: const TextStyle(
                                color: AppColors.gray700,
                                fontSize: 14,
                              ),
                            ),
                          )
                          : _searchResults.isEmpty &&
                              _searchController.text.isNotEmpty
                          ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '검색 결과가 없습니다.',
                                  style: TextStyle(
                                    color: AppColors.gray700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '다른 검색어로 다시 시도해주세요.',
                                  style: TextStyle(
                                    color: AppColors.gray500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final location = _searchResults[index];
                              return LocationSearchItem(
                                location: location.displayName,
                                selected: _selectedLocation?.id == location.id,
                                onTap:
                                    () => _onLocationSelected(location, index),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedLocation != null
                      ? AppColors.mint700
                      : AppColors.gray100,
              foregroundColor:
                  _selectedLocation != null ? Colors.white : AppColors.gray300,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed:
                _selectedLocation != null
                    ? () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'selected_location_id',
                        _selectedLocation!.id,
                      );
                      await prefs.setString(
                        'selected_location_name',
                        _selectedLocation!.displayName,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                    : null,
            child: const Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
