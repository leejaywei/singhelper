# 贡献指南

感谢你对练唱助手项目的关注！我们欢迎各种形式的贡献。

## 如何贡献

### 报告 Bug

如果你发现了 Bug，请：

1. 在 [GitHub Issues](https://github.com/leejaywei/singhelper/issues) 中搜索，确认问题尚未被报告
2. 创建新 Issue，包含：
   - 清晰的标题
   - 详细的问题描述
   - 复现步骤
   - 预期行为
   - 实际行为
   - 截图（如适用）
   - 设备信息（iOS 版本、iPhone 型号）

### 提出新功能

如果你有新功能想法：

1. 在 Issues 中创建 Feature Request
2. 描述功能的用途和价值
3. 提供使用场景示例
4. 等待社区讨论和反馈

### 提交代码

1. **Fork 项目**
   ```bash
   git clone https://github.com/YOUR_USERNAME/singhelper.git
   cd singhelper
   ```

2. **创建特性分支**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **进行开发**
   - 遵循项目代码风格
   - 添加必要的测试
   - 更新相关文档

4. **提交更改**
   ```bash
   git add .
   git commit -m 'Add some amazing feature'
   ```

5. **推送分支**
   ```bash
   git push origin feature/amazing-feature
   ```

6. **创建 Pull Request**
   - 在 GitHub 上创建 PR
   - 填写清晰的 PR 描述
   - 链接相关 Issues

## 代码规范

### Dart 代码风格

- 遵循 [Effective Dart](https://dart.dev/guides/language/effective-dart) 指南
- 使用 `flutter analyze` 检查代码
- 使用 `dart format` 格式化代码

### 命名规范

- 类名：`PascalCase` (例如: `AudioPlayerService`)
- 变量/方法：`camelCase` (例如: `detectPitch`)
- 常量：`camelCase` (例如: `maxPlaybackSpeed`)
- 私有成员：`_camelCase` (例如: `_initDatabase`)

### 注释规范

- 公共 API 需要文档注释
- 复杂逻辑需要行内注释
- 使用中文注释

示例：
```dart
/// 检测音频缓冲区的音高
///
/// 使用 YIN 算法进行音高检测。
///
/// 参数:
/// - [audioBuffer]: 音频样本数组
///
/// 返回值:
/// - 检测到的频率（Hz），如果未检测到则返回 null
double? detectPitch(List<double> audioBuffer) {
  // 实现代码
}
```

## 测试

### 运行测试

```bash
flutter test
```

### 添加测试

- 为新功能添加单元测试
- 测试文件放在 `test/` 目录
- 测试文件名以 `_test.dart` 结尾

示例：
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    test('should do something', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = functionUnderTest(input);
      
      // Assert
      expect(result, equals('expected'));
    });
  });
}
```

## 文档

### 更新文档

如果你的更改影响到用户使用或开发流程，请更新相关文档：

- `README.md` - 项目概述
- `docs/DESIGN.md` - 架构设计
- `docs/BUILD_AND_RUN.md` - 构建指南
- `docs/API_SETUP_GUIDE.md` - API 配置

### 文档风格

- 使用中文
- 清晰、简洁
- 包含代码示例
- 添加必要的截图

## 提交信息规范

使用清晰的提交信息，格式如下：

```
<type>: <subject>

<body>
```

类型：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建、工具等

示例：
```
feat: 添加变速播放功能

- 支持 0.5x 到 2.0x 倍速
- 在练唱页面添加速度滑块
- 更新音频服务以支持变速
```

## Pull Request 检查清单

提交 PR 前，请确认：

- [ ] 代码通过 `flutter analyze` 检查
- [ ] 代码通过 `flutter test` 测试
- [ ] 添加了必要的测试
- [ ] 更新了相关文档
- [ ] 提交信息清晰明确
- [ ] PR 描述详细

## 代码审查

- 所有 PR 需要至少一个维护者审查
- 积极回应审查意见
- 根据反馈进行修改
- 保持友好和专业的沟通

## 社区准则

- 尊重所有贡献者
- 保持建设性的讨论
- 欢迎新手提问
- 遵循 [行为准则](CODE_OF_CONDUCT.md)

## 获取帮助

如有问题：

1. 查看 [文档](docs/)
2. 搜索 [已有 Issues](https://github.com/leejaywei/singhelper/issues)
3. 创建新 Issue 提问
4. 加入讨论

## 许可证

贡献的代码将采用 [MIT License](LICENSE) 许可。

---

再次感谢你的贡献！🎉
