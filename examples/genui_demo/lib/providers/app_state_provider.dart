import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../models/page_type.dart';
import '../utils/app_constants.dart';
import '../utils/app_utils.dart';

/// 应用状态提供者
class AppStateProvider extends ChangeNotifier {
  AppState _state = AppState();
  
  /// 获取当前状态
  AppState get state => _state;
  
  /// 获取选中的页面类型
  String get selectedPageType => _state.selectedPageType;
  
  /// 获取是否正在生成
  bool get isGenerating => _state.isGenerating;
  
  /// 获取生成的内容
  String? get generatedContent => _state.generatedContent;
  
  /// 获取错误信息
  String? get errorMessage => _state.errorMessage;
  
  /// 获取复杂度级别
  ComplexityLevel get complexityLevel => _state.complexityLevel;
  
  /// 获取自定义提示
  String get customPrompt => _state.customPrompt;
  
  /// 获取是否有错误
  bool get hasError => _state.errorMessage != null;
  
  /// 获取是否有生成的内容
  bool get hasGeneratedContent => _state.generatedContent != null && _state.generatedContent!.isNotEmpty;
  
  /// 获取当前页面类型的显示名称
  String get currentPageDisplayName => PageType.getDisplayName(_state.selectedPageType);
  
  /// 获取当前页面类型的图标
  IconData get currentPageIcon => PageType.getIcon(_state.selectedPageType);
  
  /// 重置应用状态
  void reset() {
    _state = AppState();
    notifyListeners();
  }
  
  /// 设置选中的页面类型
  void setSelectedPageType(String pageType) {
    if (PageType.allTypes.contains(pageType)) {
      _state = _state.setSelectedPageType(pageType);
      // 清除之前的生成内容和错误信息
      _state = _state.copyWith(
        generatedContent: null,
        errorMessage: null,
      );
      notifyListeners();
    }
  }
  
  /// 开始生成
  void startGenerating() {
    _state = _state.setLoading(true).clearError();
    notifyListeners();
  }
  
  /// 完成生成
  void completeGenerating(String content) {
    _state = _state.copyWith(
      isGenerating: false,
      generatedContent: content,
      errorMessage: null,
    );
    notifyListeners();
  }
  
  /// 生成失败
  void failGenerating(String error) {
    _state = _state.copyWith(
      isGenerating: false,
      errorMessage: error,
    );
    notifyListeners();
  }
  
  /// 清除错误信息
  void clearError() {
    _state = _state.clearError();
    notifyListeners();
  }
  
  /// 清除生成的内容
  void clearGeneratedContent() {
    _state = _state.copyWith(generatedContent: null);
    notifyListeners();
  }
  
  /// 设置错误信息
  void setError(String error) {
    _state = _state.setError(error);
    notifyListeners();
  }
  
  /// 更新生成的内容
  void updateGeneratedContent(String content) {
    _state = _state.copyWith(generatedContent: content);
    notifyListeners();
  }
  
  /// 获取页面类型列表
  List<String> get availablePageTypes => PageType.allTypes;
  
  /// 获取下一个页面类型
  String? getNextPageType() {
    final currentIndex = PageType.allTypes.indexOf(_state.selectedPageType);
    if (currentIndex >= 0 && currentIndex < PageType.allTypes.length - 1) {
      return PageType.allTypes[currentIndex + 1];
    }
    return null;
  }
  
  /// 获取上一个页面类型
  String? getPreviousPageType() {
    final currentIndex = PageType.allTypes.indexOf(_state.selectedPageType);
    if (currentIndex > 0) {
      return PageType.allTypes[currentIndex - 1];
    }
    return null;
  }
  
  /// 切换到下一个页面类型
  void nextPageType() {
    final nextType = getNextPageType();
    if (nextType != null) {
      setSelectedPageType(nextType);
    }
  }
  
  /// 切换到上一个页面类型
  void previousPageType() {
    final previousType = getPreviousPageType();
    if (previousType != null) {
      setSelectedPageType(previousType);
    }
  }
  
  /// 验证页面类型是否有效
  bool isValidPageType(String pageType) {
    return PageType.allTypes.contains(pageType);
  }
  
  /// 设置复杂度级别
  void setComplexityLevel(ComplexityLevel level) {
    _state = _state.setComplexityLevel(level);
    notifyListeners();
  }
  
  /// 设置自定义提示
  void setCustomPrompt(String prompt) {
    _state = _state.setCustomPrompt(prompt);
    notifyListeners();
  }
  
  /// 获取状态摘要
  Map<String, dynamic> getStateSummary() {
    return {
      'selectedPageType': _state.selectedPageType,
      'isGenerating': _state.isGenerating,
      'hasContent': hasGeneratedContent,
      'hasError': hasError,
      'contentLength': _state.generatedContent?.length ?? 0,
      'complexityLevel': _state.complexityLevel.name,
      'customPrompt': _state.customPrompt,
    };
  }
  
  /// 从JSON恢复状态
  void restoreFromJson(Map<String, dynamic> json) {
    try {
      _state = AppState(
        selectedPageType: json['selectedPageType'] ?? PageType.landingPage,
        isGenerating: json['isGenerating'] ?? false,
        generatedContent: json['generatedContent'],
        errorMessage: json['errorMessage'],
        complexityLevel: ComplexityLevel.values.firstWhere(
          (level) => level.name == json['complexityLevel'],
          orElse: () => ComplexityLevel.simple,
        ),
        customPrompt: json['customPrompt'] ?? '',
      );
      notifyListeners();
    } catch (e) {
      debugPrint('恢复状态失败: $e');
      reset();
    }
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedPageType': _state.selectedPageType,
      'isGenerating': _state.isGenerating,
      'generatedContent': _state.generatedContent,
      'errorMessage': _state.errorMessage,
      'complexityLevel': _state.complexityLevel.name,
      'customPrompt': _state.customPrompt,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }
  
  /// 保存状态到本地存储
  Future<void> saveState() async {
    try {
      final json = toJson();
      await AppUtils.writeJsonFile(AppConstants.stateFilePath, json);
    } catch (e) {
      debugPrint('保存状态失败: $e');
    }
  }
  
  /// 从本地存储加载状态
  Future<void> loadState() async {
    try {
      final json = await AppUtils.readJsonFile(AppConstants.stateFilePath);
      if (json != null) {
        restoreFromJson(json);
      }
    } catch (e) {
      debugPrint('加载状态失败: $e');
    }
  }
  
  /// 自动保存状态（防抖）
  void _autoSave() {
    AppUtils.debounce(() => saveState(), const Duration(seconds: 2))();
  }
  
  @override
  void notifyListeners() {
    super.notifyListeners();
    _autoSave();
  }
}