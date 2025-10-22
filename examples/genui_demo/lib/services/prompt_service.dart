import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/page_type.dart';
import '../models/app_state.dart';
import '../utils/app_constants.dart';

/// 提示词服务类
class PromptService {
  static const String _defaultConfigPath = 'lib/response.json';
  
  /// 根据页面类型和复杂度级别获取对应的提示词
  static String getPromptForPageType(String pageType, {ComplexityLevel complexityLevel = ComplexityLevel.simple, String? customPrompt}) {
    String basePrompt = _getBasePromptForPageType(pageType);
    String complexityPrompt = _getComplexityPrompt(complexityLevel);
    String customPromptText = customPrompt?.isNotEmpty == true ? '\n\n自定义要求：\n$customPrompt' : '';
    
    return '$basePrompt\n\n$complexityPrompt$customPromptText';
  }

  /// 获取基础提示词
  static String _getBasePromptForPageType(String pageType) {
    switch (pageType) {
      case PageType.landingPage:
        return '''
请创建一个现代化的着陆页，遵循Material Design 3规范，包含以下元素：
1. 引人注目的标题和副标题（使用合适的Typography层次）
2. 产品或服务的主要特点介绍（使用Card组件展示）
3. 行动号召按钮（使用FilledButton，确保足够的对比度）
4. 客户评价或推荐（使用ListTile或Card布局）
5. 联系信息（使用适当的图标和间距）
6. 响应式设计，适配移动设备（使用LayoutBuilder和MediaQuery）

设计要求：
- 使用Material Design 3的颜色系统和组件
- 确保文本对比度符合WCAG 2.1 AA标准
- 添加适当的过渡动画和微交互
- 使用语义化的组件结构
''';

      case PageType.aboutPage:
        return '''
请创建一个关于页面，遵循Material Design 3规范，包含以下内容：
1. 公司或个人简介（使用Card和适当的文本样式）
2. 团队成员介绍（使用GridView或ListView展示）
3. 公司历史和里程碑（使用Timeline或Stepper组件）
4. 核心价值观和使命（使用IconButton和描述文本）
5. 联系方式（使用ListTile组件）
6. 社交媒体链接（使用IconButton数组）

设计要求：
- 使用专业且友好的语调
- 确保内容层次清晰
- 添加适当的间距和视觉分组
- 支持深色模式
''';

      case PageType.contactPage:
        return '''
请创建一个联系页面，遵循Material Design 3规范，包含以下功能：
1. 联系表单（使用TextFormField，包含姓名、邮箱、消息）
2. 公司地址和地图（使用Card容器）
3. 电话和邮箱信息（使用ListTile和可点击链接）
4. 营业时间（使用DataTable或简单的文本布局）
5. 社交媒体链接（使用IconButton）
6. 常见问题解答（使用ExpansionTile）

设计要求：
- 表单具有完整的验证功能
- 使用适当的输入类型和键盘类型
- 添加提交状态反馈
- 确保无障碍访问性
''';

      case PageType.portfolioPage:
        return '''
请创建一个作品集页面，遵循Material Design 3规范，包含以下元素：
1. 作品展示网格（使用GridView.builder）
2. 项目详情页面（使用Hero动画过渡）
3. 技能和专长展示（使用Chip或Badge组件）
4. 客户评价（使用Card和星级评分）
5. 下载简历按钮（使用FilledButton.tonal）
6. 联系方式（使用FloatingActionButton或底部按钮）

设计要求：
- 使用视觉吸引力强的网格布局
- 添加图片加载状态和错误处理
- 实现流畅的页面过渡动画
- 支持筛选和搜索功能
''';

      case PageType.blogPage:
        return '''
请创建一个博客页面，遵循Material Design 3规范，包含以下功能：
1. 文章列表和预览（使用ListView.builder和Card）
2. 分类和标签系统（使用FilterChip）
3. 搜索功能（使用SearchBar或SearchDelegate）
4. 文章详情页面（使用SingleChildScrollView）
5. 评论系统（使用ExpansionTile和ListTile）
6. 相关文章推荐（使用水平滚动列表）

设计要求：
- 确保内容易于阅读（合适的行高和字体大小）
- 添加阅读进度指示器
- 实现无限滚动加载
- 支持书签和分享功能
''';

      case PageType.ecommercePage:
        return '''
请创建一个电商页面，遵循Material Design 3规范，包含以下功能：
1. 产品展示网格（使用GridView和ProductCard）
2. 产品详情页面（使用PageView和图片轮播）
3. 购物车功能（使用Badge显示数量）
4. 用户账户管理（使用UserAccountsDrawerHeader）
5. 支付流程（使用Stepper组件）
6. 订单跟踪（使用Timeline或进度指示器）

设计要求：
- 使用现代的电商设计模式
- 添加产品筛选和排序功能
- 实现流畅的购物车动画
- 确保支付流程的安全性提示
''';

      case PageType.dashboardPage:
        return '''
请创建一个仪表板页面，遵循Material Design 3规范，包含以下元素：
1. 数据统计卡片（使用Card和适当的图标）
2. 图表和可视化（使用Container占位符，标注图表类型）
3. 快速操作按钮（使用FloatingActionButton.extended）
4. 最近活动列表（使用ListView和ListTile）
5. 通知中心（使用Badge和NotificationListener）
6. 用户配置文件（使用CircleAvatar和用户信息）

设计要求：
- 使用清晰的信息架构
- 添加数据加载状态
- 实现响应式网格布局
- 支持数据刷新功能
''';

      case PageType.loginPage:
        return '''
请创建一个登录页面，遵循Material Design 3规范，包含以下功能：
1. 用户名/邮箱和密码输入（使用TextFormField）
2. 记住我选项（使用Checkbox或Switch）
3. 忘记密码链接（使用TextButton）
4. 社交媒体登录选项（使用OutlinedButton和图标）
5. 注册页面链接（使用TextButton）
6. 表单验证和错误处理（使用Form和GlobalKey）

设计要求：
- 确保安全性和良好的用户体验
- 添加密码可见性切换
- 实现登录状态反馈
- 支持键盘导航和无障碍访问
''';

      case PageType.customPage:
        return '''
请根据用户的自定义需求创建页面，遵循Material Design 3规范。
用户需求将在customPrompt参数中提供，请仔细分析用户的描述，创建符合以下要求的页面：

基本要求：
1. 使用Material Design 3的组件和设计系统
2. 确保响应式设计，适配不同屏幕尺寸
3. 添加适当的动画和过渡效果
4. 使用语义化的组件结构
5. 支持深色模式
6. 确保无障碍访问性

技术要求：
- 使用Flutter的现代组件（如Card、ListTile、GridView等）
- 实现适当的状态管理
- 添加用户交互反馈
- 使用合适的颜色主题和文本样式
- 确保代码结构清晰，易于维护

请根据用户的具体需求，创建一个功能完整、设计精美的页面。
''';

      default:
        return '''
请创建一个通用的网页，遵循Material Design 3规范，包含以下基本元素：
1. 清晰的标题和导航（使用AppBar和NavigationBar）
2. 主要内容区域（使用适当的容器和间距）
3. 侧边栏或相关信息（使用NavigationDrawer或侧边Card）
4. 页脚信息（使用BottomAppBar或简单容器）
5. 响应式设计（使用LayoutBuilder适配不同屏幕）

设计要求：
- 使用现代的设计原则和最佳实践
- 确保良好的信息架构
- 添加适当的交互反馈
- 支持深色模式切换
''';
    }
  }

  /// 获取扩展提示词
  static String getExtensionPrompt(String pageType, {ComplexityLevel complexityLevel = ComplexityLevel.simple, String? customPrompt}) {
    String baseExtensionPrompt = '''
请为当前的${PageType.getDisplayName(pageType)}生成更多内容。
保持与现有内容的一致性，遵循Material Design 3规范：

扩展要求：
1. 添加新的功能模块或改进现有的设计
2. 确保新内容与页面主题相关且实用
3. 使用合适的Material Design 3组件
4. 保持视觉层次和间距的一致性
5. 添加适当的交互反馈和动画效果
6. 确保响应式设计和无障碍访问性

请生成具体的Flutter Widget代码，包含：
- 适当的组件选择和布局
- 合理的状态管理
- 错误处理和加载状态
- 用户体验优化
''';
    
    String complexityPrompt = _getComplexityPrompt(complexityLevel);
    String customPromptText = customPrompt?.isNotEmpty == true ? '\n\n自定义要求：\n$customPrompt' : '';
    
    return '$baseExtensionPrompt\n\n$complexityPrompt$customPromptText';
  }

  /// 获取自定义提示词
  static String getCustomPrompt(String pageType, Map<String, dynamic> customOptions) {
    final basePrompt = _getBasePromptForPageType(pageType);
    final customRequirements = customOptions['requirements'] as String? ?? '';
    final theme = customOptions['theme'] as String? ?? 'default';
    final features = customOptions['features'] as List<String>? ?? [];
    
    return '''
$basePrompt

自定义要求：
$customRequirements

主题风格：$theme

特殊功能：
${features.map((f) => '- $f').join('\n')}

请根据以上自定义要求调整设计和功能实现。
''';
  }

  /// 从默认配置文件加载提示词模板
  static Future<Map<String, String>> loadPromptTemplates() async {
    try {
      final file = File(_defaultConfigPath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content) as Map<String, dynamic>;
        
        if (data.containsKey('promptTemplates')) {
          final templates = data['promptTemplates'] as Map<String, dynamic>;
          return templates.map((key, value) => MapEntry(key, value.toString()));
        }
      }
    } catch (e) {
      debugPrint('加载提示词模板失败: $e');
    }
    
    return _getDefaultPromptTemplates();
  }

  /// 获取默认提示词模板
  static Map<String, String> _getDefaultPromptTemplates() {
    return {
      'system': '''
你是一个专业的Flutter UI设计师和开发助手。请根据用户的要求生成符合Material Design 3规范的Flutter代码。

要求：
1. 使用最新的Material Design 3组件和设计原则
2. 确保代码的可读性和可维护性
3. 添加适当的注释和文档
4. 实现响应式设计
5. 考虑无障碍访问性
6. 包含错误处理和加载状态
''',
      'ui_guidelines': '''
UI设计指南：
1. 颜色：使用Material Design 3的动态颜色系统
2. 字体：遵循Material Design 3的字体层次
3. 间距：使用8dp网格系统
4. 组件：优先使用Material 3组件
5. 动画：添加适当的过渡和微交互
6. 布局：确保响应式和自适应设计
''',
      'code_structure': '''
代码结构要求：
1. 使用StatefulWidget或StatelessWidget
2. 实现适当的状态管理
3. 添加错误边界处理
4. 使用const构造函数优化性能
5. 遵循Dart代码规范
6. 添加必要的导入语句
''',
    };
  }

  /// 验证提示词内容
  static bool validatePrompt(String prompt) {
    if (prompt.isEmpty) return false;
    if (prompt.length < AppConstants.minPromptLength) return false;
    if (prompt.length > AppConstants.maxPromptLength) return false;
    return true;
  }

  /// 格式化提示词
  static String formatPrompt(String prompt, Map<String, String> variables) {
    String formattedPrompt = prompt;
    
    variables.forEach((key, value) {
      formattedPrompt = formattedPrompt.replaceAll('{{$key}}', value);
    });
    
    return formattedPrompt.trim();
  }

  /// 获取提示词统计信息
  static Map<String, int> getPromptStats(String prompt) {
    return {
      'characterCount': prompt.length,
      'wordCount': prompt.split(RegExp(r'\s+')).length,
      'lineCount': prompt.split('\n').length,
    };
  }

  /// 根据复杂度级别获取对应的提示词
  static String _getComplexityPrompt(ComplexityLevel complexityLevel) {
    switch (complexityLevel) {
      case ComplexityLevel.simple:
        return '''
复杂度级别：简单
- 生成静态页面，专注于基础布局和内容展示
- 使用基本的Material Design组件
- 避免复杂的交互和动画
- 确保代码简洁易懂
''';
      case ComplexityLevel.medium:
        return '''
复杂度级别：中等
- 生成包含动态交互功能的页面
- 添加用户交互元素（如弹窗、计数器、表单验证等）
- 使用状态管理和事件处理
- 包含适当的动画和过渡效果
- 实现响应式设计
''';
      case ComplexityLevel.complex:
        return '''
复杂度级别：复杂
- 生成带页面切换效果的页面
- 在卡片内模拟页面跳转效果
- 实现复杂的导航和路由逻辑
- 添加高级动画和过渡效果
- 包含多层级的状态管理
- 实现复杂的用户交互流程
''';
    }
  }
}
