/// 复杂度级别枚举
enum ComplexityLevel {
  simple('简单'),
  medium('中等'),
  complex('复杂');

  const ComplexityLevel(this.displayName);
  final String displayName;
}

/// 应用状态管理类
class AppState {
  String selectedPageType;
  bool isGenerating;
  String? generatedContent;
  String? errorMessage;
  ComplexityLevel complexityLevel;
  String customPrompt;

  AppState({
    this.selectedPageType = 'landingPage',
    this.isGenerating = false,
    this.generatedContent,
    this.errorMessage,
    this.complexityLevel = ComplexityLevel.simple,
    this.customPrompt = '',
  });

  /// 重置应用状态
  void reset() {
    selectedPageType = 'landingPage';
    isGenerating = false;
    generatedContent = null;
    errorMessage = null;
    complexityLevel = ComplexityLevel.simple;
    customPrompt = '';
  }

  /// 复制当前状态并修改指定字段
  AppState copyWith({
    String? selectedPageType,
    bool? isGenerating,
    String? generatedContent,
    String? errorMessage,
    ComplexityLevel? complexityLevel,
    String? customPrompt,
  }) {
    return AppState(
      selectedPageType: selectedPageType ?? this.selectedPageType,
      isGenerating: isGenerating ?? this.isGenerating,
      generatedContent: generatedContent ?? this.generatedContent,
      errorMessage: errorMessage ?? this.errorMessage,
      complexityLevel: complexityLevel ?? this.complexityLevel,
      customPrompt: customPrompt ?? this.customPrompt,
    );
  }

  /// 清除错误信息
  AppState clearError() {
    return copyWith(errorMessage: null);
  }

  /// 设置加载状态
  AppState setLoading(bool loading) {
    return copyWith(isGenerating: loading);
  }

  /// 设置生成更多页面状态
  AppState setGeneratingMore(bool generating) {
    return copyWith(isGenerating: generating);
  }

  /// 设置错误信息
  AppState setError(String error) {
    return copyWith(errorMessage: error);
  }

  /// 设置选中的页面类型
  AppState setSelectedPageType(String pageType) {
    return copyWith(selectedPageType: pageType);
  }

  /// 设置复杂度级别
  AppState setComplexityLevel(ComplexityLevel level) {
    return copyWith(complexityLevel: level);
  }

  /// 设置自定义提示
  AppState setCustomPrompt(String prompt) {
    return copyWith(customPrompt: prompt);
  }

  /// 兼容性属性 - 映射到isGenerating
  bool get isLoading => isGenerating;
}