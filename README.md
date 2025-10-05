# Enhanced OpenIM Flutter SDK

一个现代化、开发者友好的 OpenIM Flutter SDK 重新实现，提供更好的 API 设计和开发体验。

## 特性

✅ **现代化 API 设计**: 使用 Future/Stream 替代回调  
✅ **类型安全**: 完整的类型定义和泛型支持  
✅ **简化的初始化**: 一次调用完成所有设置  
✅ **统一的错误处理**: 强类型异常和错误码  
✅ **直观的事件系统**: 强类型事件和统一的事件流  
✅ **更好的文档**: 完整的示例和最佳实践  

## 安装

### 从 Git 仓库安装

在你的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  enhanced_openim_sdk:
    git:
      url: https://github.com/your-username/enhanced_openim_sdk.git
      ref: main  # 或者指定特定的标签/分支
```

然后运行：

```bash
flutter pub get
```

## 快速开始

### 1. 初始化 SDK

```dart
import 'package:enhanced_openim_sdk/enhanced_openim_sdk.dart';

// 初始化 SDK
await OpenIMClient.instance.initialize(
  config: OpenIMConfig(
    apiUrl: 'https://your-openim-server.com',
    wsUrl: 'wss://your-openim-server.com',
  ),
);
```

### 2. 监听事件

```dart
// 监听所有事件
OpenIMClient.instance.events.listen((event) {
  if (event is NewMessageEvent) {
    print('新消息: ${event.message.content}');
  } else if (event is ConnectionStateChangedEvent) {
    print('连接状态: ${event.state.isConnected ? "已连接" : "已断开"}');
  }
});
```

### 3. 用户登录

```dart
try {
  final userInfo = await OpenIMClient.instance.login(
    userID: 'your_user_id',
    token: 'your_auth_token',
  );
  print('登录成功: ${userInfo.nickname}');
} on OpenIMException catch (e) {
  print('登录失败: ${e.message}');
}
```

### 4. 发送消息

```dart
// 创建文本消息
final message = await MessageBuilder.createTextMessage(text: 'Hello!');

// 发送消息
await OpenIMClient.instance.message.sendMessage(
  message: message,
  userID: 'friend_user_id',
);
```

### 5. 获取会话列表

```dart
final conversations = await OpenIMClient.instance.conversation.getAllConversations();
for (final conv in conversations) {
  print('会话: ${conv.showName}, 未读: ${conv.unreadCount}');
}
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:enhanced_openim_sdk/enhanced_openim_sdk.dart';

class ChatApp extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  void initState() {
    super.initState();
    _initializeSDK();
  }

  Future<void> _initializeSDK() async {
    try {
      // 初始化 SDK
      await OpenIMClient.instance.initialize(
        config: OpenIMConfig(
          apiUrl: 'https://your-server.com',
          wsUrl: 'wss://your-server.com',
        ),
      );
      
      // 监听事件
      OpenIMClient.instance.events.listen(_handleEvent);
      
      print('SDK 初始化成功');
    } catch (e) {
      print('SDK 初始化失败: $e');
    }
  }

  void _handleEvent(OpenIMEvent event) {
    if (event is NewMessageEvent) {
      // 处理新消息
      _handleNewMessage(event.message);
    } else if (event is ConnectionStateChangedEvent) {
      // 处理连接状态变化
      _handleConnectionChange(event.state);
    }
  }

  void _handleNewMessage(Message message) {
    setState(() {
      // 更新 UI
    });
  }

  void _handleConnectionChange(ConnectionState state) {
    print('连接状态: ${state.isConnected}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Enhanced OpenIM Demo')),
        body: Center(
          child: Text('OpenIM SDK 已就绪'),
        ),
      ),
    );
  }
}
```

## API 文档

### 核心类

- **`OpenIMClient`**: 主客户端，提供所有 SDK 功能的入口
- **`OpenIMConfig`**: SDK 配置类
- **`MessageBuilder`**: 消息创建工具类

### 管理器

- **`ConnectionManager`**: 连接和认证管理
- **`MessageManager`**: 消息操作管理
- **`ConversationManager`**: 会话管理
- **`UserManager`**: 用户操作管理

### 事件类型

- **`NewMessageEvent`**: 新消息事件
- **`ConnectionStateChangedEvent`**: 连接状态变化事件
- **`UserLoginEvent`**: 用户登录事件
- **`ConversationsChangedEvent`**: 会话变化事件

### 错误处理

```dart
try {
  // SDK 操作
} on OpenIMException catch (e) {
  if (e.code == OpenIMErrorCode.tokenExpired) {
    // 处理 token 过期
  } else if (e.code == OpenIMErrorCode.networkError) {
    // 处理网络错误
  }
}
```

## 相比原始 SDK 的改进

| 方面 | 原始 SDK | Enhanced SDK |
|------|----------|--------------|
| 初始化 | 复杂的多步骤设置 | 一次调用完成 |
| API 风格 | 回调为主 | async/await |
| 类型安全 | 大量 dynamic | 完整类型定义 |
| 错误处理 | 分散不一致 | 统一异常系统 |
| 事件系统 | 多个独立监听器 | 单一强类型事件流 |

## 许可证

本项目基于原始 OpenIM SDK，遵循相同的许可证条款。

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个 SDK。

## 支持

如果您在使用过程中遇到问题，请：

1. 查看文档和示例
2. 在 GitHub 上提交 Issue
3. 参考原始 OpenIM 文档：https://docs.openim.io/