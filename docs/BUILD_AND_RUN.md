# iPhone 编译运行指南

本指南详细说明如何在 iPhone 上编译运行练唱助手 App。

## 前置要求

### 1. 硬件要求
- **Mac 电脑** (macOS 12.0 或更高版本)
- **iPhone** (iOS 13.0 或更高版本)
- **USB 数据线** (用于连接 iPhone 和 Mac)

### 2. 软件要求

#### 安装 Xcode
1. 从 Mac App Store 下载并安装 Xcode (版本 14.0 或更高)
2. 打开 Xcode，接受许可协议
3. 安装命令行工具:
   ```bash
   xcode-select --install
   ```

#### 安装 CocoaPods
CocoaPods 是 iOS 的依赖管理工具，Flutter iOS 项目需要它。

```bash
sudo gem install cocoapods
```

验证安装:
```bash
pod --version
```

#### 安装 Flutter SDK
1. 下载 Flutter SDK:
   ```bash
   cd ~
   git clone https://github.com/flutter/flutter.git -b stable
   ```

2. 添加到 PATH (编辑 ~/.zshrc 或 ~/.bash_profile):
   ```bash
   export PATH="$HOME/flutter/bin:$PATH"
   ```

3. 重新加载配置:
   ```bash
   source ~/.zshrc  # 或 source ~/.bash_profile
   ```

4. 运行 Flutter doctor:
   ```bash
   flutter doctor
   ```
   
   确保以下项目都打勾:
   - ✓ Flutter SDK
   - ✓ Xcode
   - ✓ CocoaPods
   - ✓ Connected device (连接 iPhone 后)

## 克隆并配置项目

### 1. 克隆仓库
```bash
git clone https://github.com/leejaywei/singhelper.git
cd singhelper
```

### 2. 安装 Flutter 依赖
```bash
flutter pub get
```

### 3. 安装 iOS 依赖
```bash
cd ios
pod install
cd ..
```

如果遇到问题，尝试:
```bash
cd ios
pod repo update
pod install
cd ..
```

## iOS 签名配置

### 选项 A: 使用免费个人账号 (推荐新手)

1. **连接 iPhone**:
   - 用 USB 数据线连接 iPhone 到 Mac
   - 在 iPhone 上信任此电脑

2. **打开 Xcode 项目**:
   ```bash
   open ios/Runner.xcworkspace
   ```

3. **配置签名**:
   - 在 Xcode 左侧项目导航器中，选择 `Runner` 项目
   - 选择 `Runner` Target
   - 选择 "Signing & Capabilities" 标签
   - 勾选 "Automatically manage signing"
   - 在 "Team" 下拉菜单中选择 "Add an Account..."
   - 登录你的 Apple ID
   - 选择你的 Apple ID 作为 Team
   - 修改 Bundle Identifier 为唯一值（例如: `com.yourname.singhelper`）

4. **iPhone 设置**:
   - 在 iPhone 上打开 `设置 > 通用 > VPN 与设备管理`
   - 找到你的 Apple ID
   - 点击 "信任" 开发者证书

**注意**: 免费账号的限制:
- 每个设备最多 3 个 App
- 每 7 天需要重新签名
- 不能使用部分高级功能

### 选项 B: 使用付费开发者账号

1. 注册 [Apple Developer Program](https://developer.apple.com/programs/) ($99/年)

2. 在 Xcode 中:
   - 登录你的开发者账号
   - 选择开发者 Team
   - 配置 Bundle Identifier
   - Xcode 会自动处理证书和 Provisioning Profile

## 真机调试

### 1. 连接设备
```bash
# 查看连接的设备
flutter devices
```

应该能看到你的 iPhone，例如:
```
iPhone 14 (mobile) • 00008030-XXXX • ios • iOS 16.0
```

### 2. 运行 App
```bash
flutter run
```

或指定设备:
```bash
flutter run -d <device-id>
```

### 3. 热重载
应用运行后，修改代码并保存:
- 按 `r` 执行热重载 (Hot Reload)
- 按 `R` 执行热重启 (Hot Restart)
- 按 `q` 退出

## 打包 IPA (发布版本)

### 1. 构建 Release 版本
```bash
flutter build ios --release
```

### 2. 通过 Xcode 导出 IPA

1. 打开 Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. 选择真机设备 (不是模拟器)

3. 在菜单栏: `Product > Archive`

4. 等待 Archive 完成，Organizer 窗口会自动打开

5. 选择刚才创建的 Archive，点击 "Distribute App"

6. 选择分发方式:
   - **Ad Hoc**: 用于分发给测试设备
   - **App Store**: 用于提交到 App Store
   - **Development**: 用于开发测试

7. 按照向导完成导出，选择导出位置

8. 导出的文件夹中包含 `.ipa` 文件

### 3. 安装 IPA 到设备

使用 Apple Configurator 2:
1. 从 Mac App Store 下载 Apple Configurator 2
2. 连接 iPhone
3. 双击 `.ipa` 文件
4. 选择你的设备进行安装

或使用命令行 (需要开发者账号):
```bash
# 安装 ios-deploy
brew install ios-deploy

# 安装 IPA
ios-deploy --bundle path/to/app.ipa
```

## 常见问题排查

### 问题 1: "Unable to boot device" 或 "Device locked"

**解决方案**:
- 确保 iPhone 已解锁
- 在 iPhone 上点击 "信任此电脑"
- 重新连接 USB 数据线

### 问题 2: "Signing for 'Runner' requires a development team"

**解决方案**:
- 在 Xcode 中配置 Team (参见上面的签名配置章节)
- 修改 Bundle Identifier 为唯一值

### 问题 3: "CocoaPods not installed"

**解决方案**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### 问题 4: Pod install 失败

**解决方案**:
```bash
cd ios
# 清理旧的 Pods
rm -rf Pods
rm Podfile.lock

# 更新 CocoaPods 仓库
pod repo update

# 重新安装
pod install
cd ..
```

### 问题 5: "Module not found" 错误

**解决方案**:
```bash
# 清理构建缓存
flutter clean
flutter pub get
cd ios
pod install
cd ..

# 重新构建
flutter run
```

### 问题 6: 权限错误 (麦克风/文件访问)

**解决方案**:
- 确保 `ios/Runner/Info.plist` 包含必要的权限声明
- 检查 iPhone 设置中应用的权限设置

### 问题 7: App 在 iPhone 上无法启动

**解决方案**:
1. 查看 Xcode 控制台的错误信息
2. 确保设备 iOS 版本 >= 13.0
3. 检查是否信任了开发者证书 (设置 > 通用 > 设备管理)

### 问题 8: "The application could not be verified"

**解决方案**:
- 确保 iPhone 已连接互联网
- 在 iPhone 上: 设置 > 通用 > VPN 与设备管理 > 信任开发者

### 问题 9: Flutter doctor 显示问题

**解决方案**:
```bash
# 运行诊断
flutter doctor -v

# 根据输出的建议逐一修复
# 常见修复:
xcode-select --install  # 安装 Xcode 命令行工具
sudo gem install cocoapods  # 安装 CocoaPods
```

## 性能优化建议

### Debug vs Release 模式
- **Debug 模式**: 用于开发，包含调试符号，性能较慢
- **Release 模式**: 用于发布，经过优化，性能更好

构建 Release 模式:
```bash
flutter run --release
```

### 减小应用体积
```bash
# 使用混淆和压缩
flutter build ios --release --obfuscate --split-debug-info=./debug-info
```

## 发布到 App Store

### 1. 准备 App Store 资源
- App 名称
- App 图标 (1024x1024)
- 应用截图 (不同尺寸的 iPhone)
- 应用描述
- 隐私政策 URL

### 2. 在 App Store Connect 创建 App
1. 访问 [App Store Connect](https://appstoreconnect.apple.com)
2. 点击 "我的 App"
3. 点击 "+" 创建新 App
4. 填写 App 信息

### 3. 构建并上传
```bash
# 构建 Release 版本
flutter build ios --release

# 在 Xcode 中 Archive 并上传到 App Store Connect
```

### 4. 提交审核
在 App Store Connect 中:
1. 填写所有必需信息
2. 添加截图
3. 设置定价
4. 提交审核

### 5. 等待审核
- 审核通常需要 1-3 天
- 审核通过后即可发布

## 进阶配置

### 自定义 App 图标
1. 准备不同尺寸的图标 (使用 https://appicon.co/ 生成)
2. 替换 `ios/Runner/Assets.xcassets/AppIcon.appiconset/` 中的图标

### 自定义启动画面
编辑 `ios/Runner/Assets.xcassets/LaunchImage.imageset/` 中的图片

### 配置后台音频播放
已在 `Info.plist` 中配置，确保包含:
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

## 技术支持

如遇到其他问题，请参考:
- [Flutter 官方文档](https://docs.flutter.dev/deployment/ios)
- [Apple 开发者文档](https://developer.apple.com/documentation/)
- 项目 GitHub Issues 页面

---

**祝你编译顺利！🎉**
