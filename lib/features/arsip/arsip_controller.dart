import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/surat_model.dart';
import '../../data/services/arsip_service.dart';
import 'dart:async';

class ArsipController extends GetxController {
  final ArsipService _arsipService = Get.put(ArsipService());
  
  final RxList<SuratModel> arsipList = <SuratModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString searchQuery = ''.obs;
  
  int _currentPage = 1;
  bool _hasMoreData = true;
  Timer? _debounce;
  
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchArsip();
    
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchMore();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query;
      fetchArsip();
    });
  }

  Future<void> fetchArsip() async {
    isLoading.value = true;
    _currentPage = 1;
    _hasMoreData = true;
    
    final data = await _arsipService.getArsipSurat(
      page: _currentPage,
      query: searchQuery.value,
    );
    
    arsipList.value = data;
    
    if (data.isEmpty || data.length < 15) {
      _hasMoreData = false;
    }
    
    isLoading.value = false;
  }

  Future<void> fetchMore() async {
    if (!_hasMoreData || isFetchingMore.value || isLoading.value) return;
    
    isFetchingMore.value = true;
    _currentPage++;
    
    final data = await _arsipService.getArsipSurat(
      page: _currentPage,
      query: searchQuery.value,
    );
    
    if (data.isEmpty) {
      _hasMoreData = false;
    } else {
      arsipList.addAll(data);
      if (data.length < 15) _hasMoreData = false;
    }
    
    isFetchingMore.value = false;
  }
}
