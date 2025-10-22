import 'package:flutter_genui/flutter_genui.dart' as genui;

/// 应用更新事件类型枚举
enum AppUpdateType {
  surfaceAdded,
  surfaceDeleted,
  textResponse,
  warning,
}

/// 应用更新事件类
class AppUpdate {
  final AppUpdateType type;
  final DateTime timestamp;
  final dynamic data;

  AppUpdate._({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();

  /// 创建Surface添加更新
  factory AppUpdate.surfaceAdded(genui.SurfaceAdded event) {
    return AppUpdate._(
      type: AppUpdateType.surfaceAdded,
      data: event,
    );
  }

  /// 创建Surface删除更新
  factory AppUpdate.surfaceDeleted(String surfaceId) {
    return AppUpdate._(
      type: AppUpdateType.surfaceDeleted,
      data: surfaceId,
    );
  }

  /// 创建文本响应更新
  factory AppUpdate.textResponse(String response) {
    return AppUpdate._(
      type: AppUpdateType.textResponse,
      data: response,
    );
  }

  /// 创建警告更新
  factory AppUpdate.warning(String warning) {
    return AppUpdate._(
      type: AppUpdateType.warning,
      data: warning,
    );
  }

  /// 获取Surface添加事件
  genui.SurfaceAdded? get surfaceAdded {
    if (type == AppUpdateType.surfaceAdded) {
      return data as genui.SurfaceAdded;
    }
    return null;
  }

  /// 获取Surface ID（用于删除事件）
  String? get surfaceId {
    if (type == AppUpdateType.surfaceDeleted) {
      return data as String;
    } else if (type == AppUpdateType.surfaceAdded) {
      return (data as genui.SurfaceAdded).surfaceId;
    }
    return null;
  }

  /// 获取文本响应
  String? get textResponse {
    if (type == AppUpdateType.textResponse) {
      return data as String;
    }
    return null;
  }

  /// 获取警告信息
  String? get warning {
    if (type == AppUpdateType.warning) {
      return data as String;
    }
    return null;
  }

  @override
  String toString() {
    return 'AppUpdate(type: $type, timestamp: $timestamp, data: $data)';
  }
}