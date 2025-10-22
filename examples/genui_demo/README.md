# GenUI Demo

一个基于 Flutter 的生成式 UI 演示应用，展示如何使用 `Flutter GenUI` 与 `Firebase AI` 组合，通过自然语言提示生成并渲染页面组件。该示例支持 Web、Android、iOS、Windows、macOS 等多平台运行。

---

## 1. 项目概述与功能说明

- 通过选择页面类型（如登录页、展示页等）与复杂度级别，生成相应的 UI。
- 支持自定义提示词（Prompt），让生成结果更贴近业务需求。
- 使用 `GenUIService` 统一封装 AI 客户端与 UI 代理（UiAgent），接收生成事件并渲染 `GenUI Surface`。
- 使用 Provider 管理应用状态（页面类型、复杂度、错误提示等），并将状态持久化到本地 `lib/state.json`（防抖保存）。
- 提供基础的错误提示条、卡片选择、响应式适配等常用 UI 辅助组件。

---

## 2. 项目结构说明

```
lib/
├─ main.dart                     # 入口：初始化 Firebase、主题与 Provider
├─ firebase_options.dart         # 各平台 Firebase 配置（需按自身项目更新）
├─ models/
│  ├─ app_state.dart            # 应用状态（页面类型、复杂度、错误等）
│  ├─ app_update.dart           # 生成事件/更新的定义
│  └─ page_type.dart            # 页面类型与复杂度枚举
├─ providers/
│  └─ app_state_provider.dart   # 使用 Provider 管理与持久化 AppState
├─ services/
│  ├─ genui_service.dart        # GenUI 管理与事件监听核心逻辑
│  └─ prompt_service.dart       # 根据选择与模板组装提示词
├─ pages/
│  ├─ home_page.dart            # 首页：选择页面类型/复杂度，进入生成
│  └─ generated_page.dart       # 生成页：调用服务并渲染 GenUI Surface
├─ widgets/
│  ├─ custom_page_dialog.dart   # 自定义提示词输入对话框
│  ├─ error_banner.dart         # 错误提示组件
│  └─ page_type_card.dart       # 页面类型卡片
├─ utils/
│  ├─ app_constants.dart        # 常量、路径、超时等
│  ├─ app_theme.dart            # 主题定义（Material 3）
│  ├─ app_utils.dart            # 通用工具方法
│  └─ responsive_helper.dart    # 响应式尺寸/布局辅助
└─ response.json                 # Prompt 模板与 UI 指南（可按需调整）
```

---

## 3. 主要组件与功能模块

- `AppState` / `AppStateProvider`
  - 管理所选 `PageType`、`Complexity`、自定义 Prompt、错误消息等。
  - 自动将状态保存到 `lib/state.json`（防抖 500ms），并在启动时加载。

- `PageType` 与复杂度
  - `PageType` 定义页面类别；复杂度枚举（例如：简单/中等/复杂）影响生成规则与细节程度。
  
- `GenUIService`
  - 基于 `FirebaseAiClient` + `UiAgent` + `GenUiManager` 建立生成链路。
  - 将核心工具集 `CoreCatalogItems.asCatalog()` 提供给生成代理。
  - 监听生成事件（如 `SurfaceAdded`）并写入 `AppState.updates`，供 UI 层渲染。

- `PromptService`
  - 读取 `lib/response.json` 中的模板（系统提示、代码结构、UI 指南、示例等）。
  - 根据 `PageType` / 复杂度 / 自定义 Prompt 组装最终消息。

- 页面与组件
  - `HomePage`：卡片选择页面类型、复杂度，打开对话框输入自定义 Prompt。
  - `GeneratedPage`：触发生成、展示事件流，并在指定 `surfaceId` 上渲染 `GenUI Surface`。
  - `ErrorBanner` 等基础组件提升交互与可用性。

---

## 4. 安装与运行指南

- 环境准备
  - 安装 Flutter SDK（建议 3.x）。
  - 准备一个 Firebase 项目，并启用对应平台（Android/iOS/Web/桌面）。
  - 安装并配置 FlutterFire CLI：`dart pub global activate flutterfire_cli`。

- 获取依赖

```bash
flutter pub get
```

- 运行（任选其一或多平台）

```bash
# Web
flutter run -d chrome

# Android（需正确的 google-services.json）
flutter run -d android

# iOS（需正确的 GoogleService-Info.plist）
flutter run -d ios

# Windows/macOS
flutter run -d windows
flutter run -d macos
```

---

## 5. 配置说明（含 Firebase）

- `lib/firebase_options.dart`
  - 该文件包含各平台的 `FirebaseOptions`，示例中部分平台使用演示配置。
  - 请使用 FlutterFire CLI 生成并替换：
    ```bash
    flutterfire configure
    ```
    执行后会更新/生成 `firebase_options.dart`，确保与您的 Firebase 项目匹配。

- Android
  - 将 Firebase 控制台下载的 `google-services.json` 放置于 `android/app/`。

- iOS/macOS
  - 将 `GoogleService-Info.plist` 放置于 `ios/Runner/` 与 `macos/Runner/`（如需）。

- Web
  - `FirebaseOptions.web` 需与 Firebase 控制台 Web 应用配置一致，否则无法正常调用 AI 服务。

- Prompt 模板
  - 位于 `lib/response.json`，包含：
    - `system`：系统角色与约束
    - `ui_guidelines`：组件风格与可访问性建议
    - `code_structure`：生成代码结构要求
    - `examples`：示例片段
  - 可根据业务场景调整，以获得更符合预期的生成结果。

- 状态持久化
  - `lib/state.json`：保存最近选择的页面类型、复杂度、自定义 Prompt、事件等，便于下次使用。

---

## 6. 依赖项列表（参考）

- `flutter`
- `provider`
- `firebase_core`
- `flutter_genui`
- `flutter_genui_firebase_ai`

具体版本与完整依赖请参考项目 `pubspec.yaml`。

---

## 7. 贡献指南

- 提交 Issue 说明问题或需求，并附最小复现与期望结果。
- Fork 仓库并创建分支（例如：`feature/xxx`、`fix/yyy`）。
- 保持代码风格一致、合理拆分提交，编写清晰的提交信息（首行祈使句）。
- 发起 Pull Request，描述改动动机与影响范围，必要时附运行与配置说明。

---

## 8. 许可证

本示例项目以 MIT 许可证发布，您可以自由使用、修改与分发。若仓库根目录存在 `LICENSE` 文件，请以该文件为准。

---

## 参考与提示

- 如遇 Firebase 初始化或权限相关错误，请检查各平台的 `FirebaseOptions` 与控制台设置是否一致。
- 生成质量高度依赖 Prompt 模板与上下文，请结合业务诉求调整 `response.json` 与自定义 Prompt。
- `GenUI Surface` 渲染依赖事件流（如 `SurfaceAdded`），请在生成页等待并观察错误提示条以定位问题。
