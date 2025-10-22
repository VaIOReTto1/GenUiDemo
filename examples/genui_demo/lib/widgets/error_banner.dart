import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';
import '../utils/app_utils.dart';

/// 错误信息横幅组件
class ErrorBanner extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showRetryButton;
  final bool showDismissButton;
  final bool showCopyButton;
  final Duration? autoHideDuration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final ErrorBannerType type;

  const ErrorBanner({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.onDismiss,
    this.showRetryButton = true,
    this.showDismissButton = true,
    this.showCopyButton = false,
    this.autoHideDuration,
    this.margin,
    this.padding,
    this.type = ErrorBannerType.error,
  });

  @override
  State<ErrorBanner> createState() => _ErrorBannerState();
}

class _ErrorBannerState extends State<ErrorBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoHideTimer();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  void _startAutoHideTimer() {
    if (widget.autoHideDuration != null) {
      Future.delayed(widget.autoHideDuration!, () {
        if (mounted && _isVisible) {
          _dismiss();
        }
      });
    }
  }

  void _dismiss() {
    if (!_isVisible) return;
    
    setState(() {
      _isVisible = false;
    });

    _animationController.reverse().then((_) {
      if (mounted) {
        widget.onDismiss?.call();
      }
    });
  }

  void _retry() {
    AppUtils.hapticFeedback();
    widget.onRetry?.call();
  }

  void _copyError() {
    AppUtils.copyToClipboard(widget.errorMessage);
    AppUtils.showSuccessMessage(context, '错误信息已复制到剪贴板');
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ErrorBannerType.error:
        return colorScheme.errorContainer;
      case ErrorBannerType.warning:
        return colorScheme.tertiaryContainer;
      case ErrorBannerType.info:
        return colorScheme.primaryContainer;
      case ErrorBannerType.success:
        return colorScheme.secondaryContainer;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ErrorBannerType.error:
        return colorScheme.onErrorContainer;
      case ErrorBannerType.warning:
        return colorScheme.onTertiaryContainer;
      case ErrorBannerType.info:
        return colorScheme.onPrimaryContainer;
      case ErrorBannerType.success:
        return colorScheme.onSecondaryContainer;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ErrorBannerType.error:
        return Icons.error_outline;
      case ErrorBannerType.warning:
        return Icons.warning_amber_outlined;
      case ErrorBannerType.info:
        return Icons.info_outline;
      case ErrorBannerType.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              margin: widget.margin ?? AppTheme.defaultMarginGeometry,
              padding: widget.padding ?? AppTheme.defaultPaddingGeometry,
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: AppTheme.defaultBorderRadiusGeometry,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getIcon(),
                        color: _getTextColor(context),
                        size: 24,
                      ),
                      SizedBox(width: AppTheme.spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getTypeTitle(),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: _getTextColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.errorMessage,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _getTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.showDismissButton)
                        IconButton(
                          onPressed: _dismiss,
                          icon: Icon(
                            Icons.close,
                            color: _getTextColor(context),
                            size: 20,
                          ),
                          tooltip: '关闭',
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  if (_shouldShowActionButtons()) ...[
                    SizedBox(height: AppTheme.spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.showCopyButton)
                          TextButton.icon(
                            onPressed: _copyError,
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('复制'),
                            style: TextButton.styleFrom(
                              foregroundColor: _getTextColor(context),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        if (widget.showCopyButton && widget.showRetryButton)
                          SizedBox(width: AppTheme.spacing),
                        if (widget.showRetryButton && widget.onRetry != null)
                          FilledButton.icon(
                            onPressed: _retry,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('重试'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _getTextColor(context),
                              foregroundColor: _getBackgroundColor(context),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTypeTitle() {
    switch (widget.type) {
      case ErrorBannerType.error:
        return '错误';
      case ErrorBannerType.warning:
        return '警告';
      case ErrorBannerType.info:
        return '信息';
      case ErrorBannerType.success:
        return '成功';
    }
  }

  bool _shouldShowActionButtons() {
    return (widget.showRetryButton && widget.onRetry != null) ||
           widget.showCopyButton;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// 错误横幅类型
enum ErrorBannerType {
  error,
  warning,
  info,
  success,
}

/// 错误横幅工厂类
class ErrorBannerFactory {
  /// 创建错误横幅
  static Widget createError({
    required String message,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    bool showRetryButton = true,
    bool showCopyButton = false,
    Duration? autoHideDuration,
  }) {
    return ErrorBanner(
      errorMessage: message,
      type: ErrorBannerType.error,
      onRetry: onRetry,
      onDismiss: onDismiss,
      showRetryButton: showRetryButton,
      showCopyButton: showCopyButton,
      autoHideDuration: autoHideDuration,
    );
  }

  /// 创建警告横幅
  static Widget createWarning({
    required String message,
    VoidCallback? onDismiss,
    Duration? autoHideDuration,
  }) {
    return ErrorBanner(
      errorMessage: message,
      type: ErrorBannerType.warning,
      onDismiss: onDismiss,
      showRetryButton: false,
      autoHideDuration: autoHideDuration,
    );
  }

  /// 创建信息横幅
  static Widget createInfo({
    required String message,
    VoidCallback? onDismiss,
    Duration? autoHideDuration,
  }) {
    return ErrorBanner(
      errorMessage: message,
      type: ErrorBannerType.info,
      onDismiss: onDismiss,
      showRetryButton: false,
      autoHideDuration: autoHideDuration,
    );
  }

  /// 创建成功横幅
  static Widget createSuccess({
    required String message,
    VoidCallback? onDismiss,
    Duration autoHideDuration = const Duration(seconds: 3),
  }) {
    return ErrorBanner(
      errorMessage: message,
      type: ErrorBannerType.success,
      onDismiss: onDismiss,
      showRetryButton: false,
      showDismissButton: false,
      autoHideDuration: autoHideDuration,
    );
  }
}