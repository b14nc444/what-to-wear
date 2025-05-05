import 'dart:async';

import 'package:flutter/material.dart';
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
  Timer? _debounce;
  List<String> _searchResults = [];
  bool _isLoading = false;

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

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: 실제 API 호출로 대체
    // 임시 검색 결과
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _searchResults =
            ['서울 중구', '서울 강남구', '서울 서초구', '서울 송파구']
                .where(
                  (location) =>
                      location.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
        _isLoading = false;
      });
    });
  }

  void _onLocationSelected(String location) {
    // TODO: 선택된 위치 처리
    print('Selected location: $location');
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
                          : ListView.separated(
                            itemCount: _searchResults.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final location = _searchResults[index];
                              return LocationSearchItem(
                                location: location,
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
