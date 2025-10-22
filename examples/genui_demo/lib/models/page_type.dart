import 'package:flutter/material.dart';

/// 页面类型配置
class PageType {
  static const String landingPage = 'landing_page';
  static const String aboutPage = 'about_page';
  static const String contactPage = 'contact_page';
  static const String portfolioPage = 'portfolio_page';
  static const String blogPage = 'blog_page';
  static const String ecommercePage = 'ecommerce_page';
  static const String dashboardPage = 'dashboard_page';
  static const String loginPage = 'login_page';
  static const String customPage = 'custom_page';

  static const List<String> allTypes = [
    landingPage,
    aboutPage,
    contactPage,
    portfolioPage,
    blogPage,
    ecommercePage,
    dashboardPage,
    loginPage,
    customPage,
  ];

  /// 获取页面类型的显示名称
  static String getDisplayName(String pageType) {
    switch (pageType) {
      case landingPage:
        return '着陆页';
      case aboutPage:
        return '关于页面';
      case contactPage:
        return '联系页面';
      case portfolioPage:
        return '作品集页面';
      case blogPage:
        return '博客页面';
      case ecommercePage:
        return '电商页面';
      case dashboardPage:
        return '仪表板页面';
      case loginPage:
        return '登录页面';
      case customPage:
        return '自定义页面';
      default:
        return pageType;
    }
  }

  /// 获取页面类型的图标
  static IconData getIcon(String pageType) {
    switch (pageType) {
      case landingPage:
        return Icons.home;
      case aboutPage:
        return Icons.info;
      case contactPage:
        return Icons.contact_phone;
      case portfolioPage:
        return Icons.palette;
      case blogPage:
        return Icons.article;
      case ecommercePage:
        return Icons.shopping_cart;
      case dashboardPage:
        return Icons.dashboard;
      case loginPage:
        return Icons.login;
      case customPage:
        return Icons.edit;
      default:
        return Icons.description;
    }
  }
}