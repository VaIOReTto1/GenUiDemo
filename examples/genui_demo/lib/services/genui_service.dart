import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import 'package:flutter_genui_firebase_ai/flutter_genui_firebase_ai.dart';
import '../models/app_update.dart';
import '../utils/app_constants.dart';
import '../utils/app_utils.dart';

/// GenUI服务状态枚举
enum GenUIServiceState {
  uninitialized,
  initializing,
  ready,
  error,
  generating,
}

/// GenUI服务类，负责管理GenUI相关的初始化和操作
class GenUIService extends ChangeNotifier {
  late final GenUiManager _genUiManager;
  late final FirebaseAiClient _aiClient;
  late final UiAgent _uiAgent;
  final List<AppUpdate> _updates = [];
  
  GenUIServiceState _state = GenUIServiceState.uninitialized;
  String? _errorMessage;
  bool _isInitialized = false;

  // 回调函数
  final Function(SurfaceAdded)? onSurfaceAdded;
  final Function(SurfaceRemoved)? onSurfaceDeleted;
  final Function(String)? onTextResponse;
  final Function(String)? onWarning;
  final Function(String)? onError;

  GenUIService({
    this.onSurfaceAdded,
    this.onSurfaceDeleted,
    this.onTextResponse,
    this.onWarning,
    this.onError,
  });

  /// 获取当前服务状态
  GenUIServiceState get state => _state;
  
  /// 获取错误信息
  String? get errorMessage => _errorMessage;
  
  /// 是否已初始化
  bool get isInitialized => _isInitialized;
  
  /// 是否正在生成
  bool get isGenerating => _state == GenUIServiceState.generating;
  
  /// 是否准备就绪
  bool get isReady => _state == GenUIServiceState.ready;
  
  /// 是否有错误
  bool get hasError => _state == GenUIServiceState.error;
  
  /// 获取更新列表
  List<AppUpdate> get updates => List.unmodifiable(_updates);

  /// 设置服务状态
  void _setState(GenUIServiceState newState, {String? error}) {
    _state = newState;
    _errorMessage = error;
    notifyListeners();
  }

  /// 初始化GenUI服务
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _setState(GenUIServiceState.initializing);
    
    try {
      // 初始化GenUI管理器
      _genUiManager = GenUiManager(catalog: CoreCatalogItems.asCatalog());

      // 初始化Firebase AI客户端
      _aiClient = FirebaseAiClient(
        systemInstruction: _getSystemInstruction(),
        tools: _genUiManager.getTools(),
      );

      // 初始化UI代理
      _uiAgent = UiAgent(
        genUiManager: _genUiManager,
        aiClient: _aiClient,
        onSurfaceAdded: _handleSurfaceAdded,
        onSurfaceDeleted: _handleSurfaceDeleted,
        onTextResponse: _handleTextResponse,
        onWarning: _handleWarning,
      );
      
      _isInitialized = true;
      _setState(GenUIServiceState.ready);
      
      debugPrint('GenUI服务初始化成功');
    } catch (e) {
      final errorMsg = 'GenUI初始化失败: $e';
      debugPrint(errorMsg);
      _setState(GenUIServiceState.error, error: errorMsg);
      onError?.call(errorMsg);
      rethrow;
    }
  }

  /// 获取系统指令
  String _getSystemInstruction() {
    return '''
      你是一个专业的Flutter UI设计师和开发助手。你的任务是根据用户的需求生成符合Material Design 3规范的Flutter UI代码。

      请遵循以下原则：
      1. 使用Material Design 3组件和设计语言
      2. 确保代码结构清晰、可读性强
      3. 适当使用动画和交互效果
      4. 考虑响应式设计和不同屏幕尺寸
      5. 使用现代的Flutter最佳实践

      请确保生成的代码：
      - 可以直接运行，无需额外修改
      - 使用合适的Material Design 3组件
      - 包含必要的导入语句
      - 具有良好的代码结构和注释
    ''';
  }

  /// 处理Surface添加事件
  void _handleSurfaceAdded(SurfaceAdded event) {
    debugPrint('Surface添加: ${event.surfaceId}');
    _updates.add(AppUpdate.surfaceAdded(event));
    notifyListeners();
    onSurfaceAdded?.call(event);
  }

  /// 处理Surface删除事件
  void _handleSurfaceDeleted(SurfaceRemoved event) {
    debugPrint('Surface删除: ${event.surfaceId}');
    _updates.add(AppUpdate.surfaceDeleted(event.surfaceId));
    notifyListeners();
    onSurfaceDeleted?.call(event);
  }

  /// 处理文本响应事件
  void _handleTextResponse(String response) {
    debugPrint('文本响应: $response');
    _updates.add(AppUpdate.textResponse(response));
    notifyListeners();
    onTextResponse?.call(response);
  }

  /// 处理警告事件
  void _handleWarning(String warning) {
    debugPrint('警告: $warning');
    _updates.add(AppUpdate.warning(warning));
    notifyListeners();
    onWarning?.call(warning);
  }

  /// 发送请求
  Future<void> sendRequest(UserMessage message) async {
    if (!_isInitialized) {
      throw StateError('GenUI服务未初始化');
    }
    
    _setState(GenUIServiceState.generating);
    
    try {
      await _uiAgent.sendRequest(message);
      _setState(GenUIServiceState.ready);
    } catch (e) {
      final errorMsg = '生成请求失败: $e';
      debugPrint(errorMsg);
      _setState(GenUIServiceState.error, error: errorMsg);
      onError?.call(errorMsg);
      rethrow;
    }
  }

  /// 生成页面内容
  Future<void> generatePageContent(String pageType, {String? customPrompt}) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    final prompt = customPrompt ?? _getDefaultPrompt(pageType);
    final message = UserMessage([TextPart(prompt)]);
    
    await sendRequest(message);
  }

  /// 获取默认提示词
  String _getDefaultPrompt(String pageType) {
    switch (pageType) {
      case 'landing_page':
        return '请为我创建一个现代化的着陆页，包含欢迎标题、功能介绍卡片和行动按钮。使用Material Design 3风格。';
      case 'about_page':
        return '请创建一个关于页面，包含公司介绍、团队成员展示和联系信息。';
      case 'contact_page':
        return '请创建一个联系页面，包含联系表单、地址信息和社交媒体链接。';
      case 'portfolio_page':
        return '请创建一个作品集页面，展示项目作品、技能标签和成就。';
      case 'blog_page':
        return '请创建一个博客页面，包含文章列表、分类筛选和搜索功能。';
      case 'ecommerce_page':
        return '请创建一个电商页面，展示商品网格、筛选选项和购物车功能。';
      case 'dashboard_page':
        return '请创建一个仪表板页面，包含数据卡片、图表和统计信息。';
      case 'login_page':
        return '请创建一个登录页面，包含用户名和密码输入框、登录按钮和忘记密码链接。';
      default:
        return '请为我创建一个${pageType}页面，使用Material Design 3风格。';
    }
  }

  /// 重试初始化
  Future<void> retryInitialization() async {
    _isInitialized = false;
    await initialize();
  }

  /// 清除错误状态
  void clearError() {
    if (_state == GenUIServiceState.error) {
      _setState(GenUIServiceState.ready);
    }
  }

  /// 加载默认配置
  Future<void> loadDefaultConfig() async {
    try {
      final defaultConfig = await AppUtils.readAssetJsonFile(AppConstants.defaultDataPath);
      if (defaultConfig != null) {
        debugPrint('已加载默认配置');
        // 这里可以处理默认配置的逻辑
      }
    } catch (e) {
      debugPrint('加载默认配置失败: $e');
    }
  }

  /// 获取UiAgent实例
  UiAgent get uiAgent => _uiAgent;

  /// 获取GenUiManager实例
  GenUiManager get genUiManager => _genUiManager;

  /// 清空更新列表
  void clearUpdates() {
    _updates.clear();
    notifyListeners();
  }

  /// 获取服务统计信息
  Map<String, dynamic> getServiceStats() {
    return {
      'state': _state.toString(),
      'isInitialized': _isInitialized,
      'updatesCount': _updates.length,
      'hasError': hasError,
      'errorMessage': _errorMessage,
    };
  }

  /// 重置服务状态
  void reset() {
    _updates.clear();
    _errorMessage = null;
    if (_isInitialized) {
      _setState(GenUIServiceState.ready);
    } else {
      _setState(GenUIServiceState.uninitialized);
    }
  }

  /// 释放资源
  @override
  void dispose() {
    if (_isInitialized) {
      _uiAgent.dispose();
    }
    super.dispose();
  }
}