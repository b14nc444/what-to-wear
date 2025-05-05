import 'dart:async';

import 'package:flutter/material.dart';
import 'package:muipzi/models/location.dart';
import 'package:muipzi/services/location_service.dart';
import 'package:muipzi/theme/app_colors.dart';
import 'package:muipzi/widgets/custom_search_bar.dart';
import 'package:muipzi/widgets/location_search_item.dart';

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

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('검색 오류 발생: $e'); // 디버깅용 로그
      print('스택 트레이스: $stackTrace'); // 디버깅용 로그

      setState(() {
        _error = '검색 중 오류가 발생했습니다: ${e.toString()}';
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  void _onLocationSelected(Location location) {
    Navigator.pop(context, location);
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
                          : ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final location = _searchResults[index];
                              return LocationSearchItem(
                                location: location.displayName,
                                onTap: () => _onLocationSelected(location),
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
