/// 应用常量配置
class AppConstants {
  // 应用信息
  static const String appName = 'GenUI Demo';
  static const String appVersion = '1.0.0';
  
  // 网络配置
  static const Duration networkTimeout = Duration(seconds: 2000);
  static const Duration retryDelay = Duration(seconds: 2400);
  static const int maxRetryAttempts = 1;
  
  // UI配置
  static const double defaultPadding = 16.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double loadingIndicatorSize = 32.0;
  
  // 动画配置
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // 页面配置
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 1.2;
  static const double gridSpacing = 16.0;
  
  // 自动生成配置
  static const Duration autoGenerateInterval = Duration(seconds: 30);
  static const int maxAutoGenerateAttempts = 5;
  
  // 缓存配置
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100;
  
  // 错误消息
  static const String networkErrorMessage = '网络连接失败，请检查网络设置';
  static const String unknownErrorMessage = '发生未知错误，请稍后重试';
  static const String initializationErrorMessage = 'GenUI初始化失败';
  static const String generationErrorMessage = '页面生成失败';
  
  // 成功消息
  static const String generationSuccessMessage = '页面生成成功';
  static const String saveSuccessMessage = '保存成功';
  
  // 加载消息
  static const String loadingMessage = '加载中...';
  static const String generatingMessage = '正在生成页面内容...';
  static const String initializingMessage = '正在初始化...';
  
  // 空状态消息
  static const String noContentMessage = '暂无内容';
  static const String noDataMessage = '暂无数据';
  static const String emptyStateMessage = '这里还没有任何内容';
  
  // 按钮文本
  static const String generateButtonText = '生成页面';
  static const String generateMoreButtonText = '生成更多页面';
  static const String retryButtonText = '重试';
  static const String refreshButtonText = '刷新';
  static const String backButtonText = '返回';
  static const String homeButtonText = '返回首页';
  static const String saveButtonText = '保存';
  static const String cancelButtonText = '取消';
  static const String confirmButtonText = '确认';
  
  // 提示文本
  static const String selectPageTypeHint = '选择要生成的页面类型：';
  static const String generatingHint = '正在为您生成精美的页面...';
  static const String completedHint = '页面生成完成！';
  
  // 文件路径
  static const String defaultDataPath = 'lib/response.json';
  static const String stateFilePath = 'lib/state.json';
  
  // 正则表达式
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  
  // 数值限制
  static const int maxTextLength = 1000;
  static const int minPasswordLength = 6;
  static const int maxRetryCount = 3;
  static const int minPromptLength = 10;
  static const int maxPromptLength = 2000;
  
  // 默认值
  static const String defaultPageType = 'landing_page';
  static const bool defaultIsLoading = false;
  static const bool defaultIsGenerating = false;
}