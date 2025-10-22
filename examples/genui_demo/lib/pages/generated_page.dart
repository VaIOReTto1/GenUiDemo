import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_genui/flutter_genui.dart';
import '../models/app_state.dart';
import '../services/genui_service.dart';
import '../services/prompt_service.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

/// 生成页面，显示AI生成的UI内容
class GeneratedPage extends StatefulWidget {
  final String pageType;

  const GeneratedPage({
    super.key,
    required this.pageType,
  });

  @override
  State<GeneratedPage> createState() => _GeneratedPageState();
}

class _GeneratedPageState extends State<GeneratedPage> 
    with TickerProviderStateMixin {
  late GenUIService _genUIService;
  late AppState _appState;
  Timer? _autoGenerateTimer;
  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;
  StreamSubscription<UserMessage>? _userMessageSubscription;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));
    _initializeGenUI();
  }

  @override
  void dispose() {
    _autoGenerateTimer?.cancel();
    _userMessageSubscription?.cancel();
    _loadingAnimationController.dispose();
    _genUIService.dispose();
    super.dispose();
  }

  /// 初始化GenUI服务
  void _initializeGenUI() {
    _genUIService = GenUIService(
      onSurfaceAdded: _onSurfaceAdded,
      onSurfaceDeleted: _onSurfaceDeleted,
      onTextResponse: _onTextResponse,
    );

    try {
      _genUIService.initialize();
      
      // 监听用户在GenUiSurface中的交互事件
      _userMessageSubscription = _genUIService.genUiManager.onSubmit.listen(
        _handleUserInteractionFromSurface,
      );
      
      _generatePage();
    } catch (e) {
      setState(() {
        _appState = _appState.setError('GenUI初始化失败: $e');
      });
    }
  }

  /// 处理来自GenUiSurface的用户交互事件
  void _handleUserInteractionFromSurface(UserMessage message) {
    debugPrint('用户在Surface中进行了交互: ${message.text}');
    
    // 显示加载状态并跳转到新页面
    _navigateToNewGeneratedPage(message.text);
  }

  /// 跳转到新的生成页面
  void _navigateToNewGeneratedPage(String interactionContext) {
    // 显示加载对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '正在生成新页面...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '基于您的选择创建相关内容',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // 延迟一小段时间以显示加载状态，然后跳转
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pop(); // 关闭加载对话框
        
        // 跳转到新的GeneratedPage，传递交互上下文作为页面类型
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                GeneratedPage(pageType: _generatePageTypeFromInteraction(interactionContext)),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  /// 根据交互内容生成页面类型
  String _generatePageTypeFromInteraction(String interactionContext) {
    // 根据交互内容智能判断页面类型
    final lowerContext = interactionContext.toLowerCase();
    
    if (lowerContext.contains('login') || lowerContext.contains('登录')) {
      return 'login';
    } else if (lowerContext.contains('register') || lowerContext.contains('注册')) {
      return 'register';
    } else if (lowerContext.contains('profile') || lowerContext.contains('个人') || lowerContext.contains('用户')) {
      return 'profile';
    } else if (lowerContext.contains('settings') || lowerContext.contains('设置')) {
      return 'settings';
    } else if (lowerContext.contains('product') || lowerContext.contains('商品') || lowerContext.contains('购物')) {
      return 'product_list';
    } else if (lowerContext.contains('cart') || lowerContext.contains('购物车')) {
      return 'shopping_cart';
    } else if (lowerContext.contains('chat') || lowerContext.contains('聊天') || lowerContext.contains('消息')) {
      return 'chat';
    } else if (lowerContext.contains('news') || lowerContext.contains('新闻') || lowerContext.contains('文章')) {
      return 'news_list';
    } else {
      // 默认返回当前页面类型的变体
      return '${widget.pageType}_detail';
    }
  }

  /// 处理Surface添加事件
  void _onSurfaceAdded(SurfaceAdded surface) {
    if (mounted) {
      setState(() {
        _appState = _appState.setLoading(false);
        _loadingAnimationController.stop();
      });
    }
  }

  /// 处理Surface删除事件
  void _onSurfaceDeleted(SurfaceRemoved event) {
    if (mounted) {
      setState(() {});
    }
  }

  /// 处理文本响应事件
  void _onTextResponse(String response) {
    if (mounted) {
      setState(() {
        _appState = _appState.setLoading(false);
        _loadingAnimationController.stop();
      });
    }
  }

  /// 自动生成内容
  void _autoGenerateContent() {
    _autoGenerateTimer?.cancel();
    _autoGenerateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && !_appState.isLoading) {
        _generateMorePages();
      }
    });
  }

  /// 生成页面内容
  Future<void> _generatePage() async {
    if (_appState.isLoading) return;

    setState(() {
      _appState = _appState.setLoading(true);
      _appState = _appState.clearError();
      _loadingAnimationController.repeat();
    });

    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      final prompt = PromptService.getPromptForPageType(
        widget.pageType,
        complexityLevel: provider.complexityLevel,
        customPrompt: provider.customPrompt,
      );
      await _genUIService.sendRequest(UserMessage.text(prompt));
      
      // 启动自动生成
      // _autoGenerateContent();
    } catch (e) {
      if (mounted) {
        setState(() {
          _appState = _appState.setError('生成页面失败: $e');
          _appState = _appState.setLoading(false);
        });
      }
    }
  }

  /// 生成更多页面
  Future<void> _generateMorePages() async {
    if (_appState.isLoading) return;

    setState(() {
      _appState = _appState.setLoading(true);
    });

    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      final prompt = PromptService.getExtensionPrompt(
        widget.pageType,
        complexityLevel: provider.complexityLevel,
        customPrompt: provider.customPrompt,
      );
      await _genUIService.sendRequest(UserMessage.text(prompt));
    } catch (e) {
      if (mounted) {
        setState(() {
          _appState = _appState.setError('生成更多页面失败: $e');
          _appState = _appState.setLoading(false);
        });
      }
    }
  }

  /// 重新开始生成
  void _restart() {
    _autoGenerateTimer?.cancel();
    _genUIService.clearUpdates();
    setState(() {
      _appState.reset();
    });
    _generatePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生成的${_getPageTypeDisplayName()}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restart,
            tooltip: '重新生成',
          ),
        ],
      ),
      body: Column(
        children: [
          // 错误信息显示
          if (_appState.errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.red.shade100,
              child: Text(
                _appState.errorMessage!,
                style: TextStyle(color: Colors.red.shade800),
              ),
            ),
          
          // 加载指示器
          if (_appState.isLoading)
            Container(
              height: 4,
              child: AnimatedBuilder(
                animation: _loadingAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: null, // 无限循环
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          
          // 生成的内容
          Expanded(
            child: _genUIService.updates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_appState.isLoading) ...[
                          AnimatedBuilder(
                            animation: _loadingAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _loadingAnimation.value * 2 * 3.14159,
                                child: Icon(
                                  Icons.auto_awesome,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '正在生成${_getPageTypeDisplayName()}...',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'AI正在为您创建精美的界面',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.touch_app,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '准备开始生成',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: _genUIService.updates
                          .where((u) => u.surfaceAdded != null)
                          .map((u) {
                            final update = u.surfaceAdded!;
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOutBack,
                                  child: Card(
                                    elevation: 8,
                                    shadowColor: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white,
                                            Colors.grey.shade50,
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.auto_awesome,
                                                    size: 20,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'AI生成的界面',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            GenUiSurface(
                                              host: _genUIService.uiAgent.host,
                                              surfaceId: update.surfaceId,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          .toList(),
                        ),
                      ),
          ),
          
          // 底部按钮
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _appState.isLoading ? null : _generateMorePages,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text(
                      '生成更多页面',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.grey.shade700,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.home, size: 20),
                  label: const Text(
                    '返回首页',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 获取页面类型的显示名称
  String _getPageTypeDisplayName() {
    switch (widget.pageType) {
      case 'login':
        return '登录页面';
      case 'register':
        return '注册页面';
      case 'profile':
        return '个人资料页面';
      case 'settings':
        return '设置页面';
      case 'product_list':
        return '商品列表页面';
      case 'shopping_cart':
        return '购物车页面';
      case 'chat':
        return '聊天界面';
      case 'news_list':
        return '新闻列表页面';
      default:
        return '页面';
    }
  }
}