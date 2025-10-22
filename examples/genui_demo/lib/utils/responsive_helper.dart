import 'package:flutter/material.dart';

/// 响应式布局辅助类
class ResponsiveHelper {
  /// 屏幕断点
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// 获取设备类型
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// 是否为移动设备
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// 是否为平板设备
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// 是否为桌面设备
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// 根据设备类型返回不同的值
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// 获取网格列数
  static int getGridColumns(BuildContext context) {
    return responsive(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  /// 获取内容最大宽度
  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }

  /// 获取水平内边距
  static double getHorizontalPadding(BuildContext context) {
    return responsive(
      context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
  }

  /// 获取垂直内边距
  static double getVerticalPadding(BuildContext context) {
    return responsive(
      context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }

  /// 获取卡片间距
  static double getCardSpacing(BuildContext context) {
    return responsive(
      context,
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    );
  }

  /// 获取字体大小
  static double getFontSize(BuildContext context, FontSizeType type) {
    switch (type) {
      case FontSizeType.small:
        return responsive(
          context,
          mobile: 12.0,
          tablet: 13.0,
          desktop: 14.0,
        );
      case FontSizeType.medium:
        return responsive(
          context,
          mobile: 14.0,
          tablet: 15.0,
          desktop: 16.0,
        );
      case FontSizeType.large:
        return responsive(
          context,
          mobile: 16.0,
          tablet: 18.0,
          desktop: 20.0,
        );
      case FontSizeType.title:
        return responsive(
          context,
          mobile: 20.0,
          tablet: 22.0,
          desktop: 24.0,
        );
      case FontSizeType.headline:
        return responsive(
          context,
          mobile: 24.0,
          tablet: 28.0,
          desktop: 32.0,
        );
    }
  }

  /// 获取图标大小
  static double getIconSize(BuildContext context, IconSizeType type) {
    switch (type) {
      case IconSizeType.small:
        return responsive(
          context,
          mobile: 16.0,
          tablet: 18.0,
          desktop: 20.0,
        );
      case IconSizeType.medium:
        return responsive(
          context,
          mobile: 20.0,
          tablet: 22.0,
          desktop: 24.0,
        );
      case IconSizeType.large:
        return responsive(
          context,
          mobile: 24.0,
          tablet: 28.0,
          desktop: 32.0,
        );
    }
  }

  /// 获取按钮高度
  static double getButtonHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }

  /// 获取应用栏高度
  static double getAppBarHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
  }

  /// 获取侧边栏宽度
  static double getSidebarWidth(BuildContext context) {
    return responsive(
      context,
      mobile: 280.0,
      tablet: 320.0,
      desktop: 360.0,
    );
  }

  /// 获取对话框宽度
  static double getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return responsive(
      context,
      mobile: screenWidth * 0.9,
      tablet: 500.0,
      desktop: 600.0,
    );
  }

  /// 获取卡片宽度
  static double getCardWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 300.0,
      desktop: 350.0,
    );
  }

  /// 获取列表项高度
  static double getListItemHeight(BuildContext context) {
    return responsive(
      context,
      mobile: 56.0,
      tablet: 64.0,
      desktop: 72.0,
    );
  }

  /// 获取边框圆角
  static double getBorderRadius(BuildContext context, BorderRadiusType type) {
    switch (type) {
      case BorderRadiusType.small:
        return responsive(
          context,
          mobile: 4.0,
          tablet: 6.0,
          desktop: 8.0,
        );
      case BorderRadiusType.medium:
        return responsive(
          context,
          mobile: 8.0,
          tablet: 10.0,
          desktop: 12.0,
        );
      case BorderRadiusType.large:
        return responsive(
          context,
          mobile: 12.0,
          tablet: 16.0,
          desktop: 20.0,
        );
    }
  }

  /// 获取阴影高度
  static double getElevation(BuildContext context, ElevationType type) {
    switch (type) {
      case ElevationType.low:
        return responsive(
          context,
          mobile: 1.0,
          tablet: 2.0,
          desktop: 3.0,
        );
      case ElevationType.medium:
        return responsive(
          context,
          mobile: 2.0,
          tablet: 4.0,
          desktop: 6.0,
        );
      case ElevationType.high:
        return responsive(
          context,
          mobile: 4.0,
          tablet: 8.0,
          desktop: 12.0,
        );
    }
  }

  /// 获取响应式EdgeInsets
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final horizontal = getHorizontalPadding(context);
    final vertical = getVerticalPadding(context);
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  /// 获取响应式间距
  static SizedBox getResponsiveSpacing(BuildContext context, {bool isVertical = true}) {
    final spacing = responsive(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
    
    return isVertical 
        ? SizedBox(height: spacing)
        : SizedBox(width: spacing);
  }

  /// 获取网格视图配置
  static SliverGridDelegate getGridDelegate(BuildContext context) {
    final columns = getGridColumns(context);
    final spacing = getCardSpacing(context);
    
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: responsive(
        context,
        mobile: 0.8,
        tablet: 0.9,
        desktop: 1.0,
      ),
    );
  }
}

/// 设备类型枚举
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// 字体大小类型枚举
enum FontSizeType {
  small,
  medium,
  large,
  title,
  headline,
}

/// 图标大小类型枚举
enum IconSizeType {
  small,
  medium,
  large,
}

/// 边框圆角类型枚举
enum BorderRadiusType {
  small,
  medium,
  large,
}

/// 阴影高度类型枚举
enum ElevationType {
  low,
  medium,
  high,
}