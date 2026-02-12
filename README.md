# 练唱助手 (SingHelper)

一个基于 Flutter 的 iPhone 练唱 App，集成 AI 功能，帮助你提升唱功！

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![iOS](https://img.shields.io/badge/iOS-13.0%2B-green.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)

## ✨ 功能特性

### 🎵 音乐导入
- 从 iPhone 本地文件导入音频（MP3/WAV/M4A）
- 自动提取歌曲信息
- 本地沙盒存储，数据完全私密

### 🤖 AI 处理（可配置 API Key）
- **人声分离**: 使用 Replicate Demucs 模型，将歌曲分离为人声 + 伴奏
- **歌词生成**: 使用 Groq Whisper large-v3，自动识别生成带时间戳的歌词
- **音高分析**: 本地 YIN 算法分析参考音高

### 🎤 实时练唱
- 播放纯伴奏音频
- 实时歌词滚动（当前句高亮，高音句标红）
- 实时音高检测（端侧 YIN 算法）
- 音高曲线可视化（参考 vs 实唱对比）
- 录制练唱音频
- 变速播放（0.5x - 2.0x）
- 升降调（-6 ~ +6 半音）

### 📊 智能评分（100% 端侧计算）
- **音准评分** (40%): 逐帧比较音高偏差
- **节奏评分** (25%): 发声时间匹配度
- **高音达成** (20%): 高音区域达标率
- **稳定性评分** (15%): 长音稳定性
- 逐句详细评分
- 个性化改进建议

### 🔒 隐私安全
- 纯单机 App，无需服务器
- API Key 仅保存在本地
- 所有数据存储在设备沙盒
- 不收集任何用户数据

## 📱 截图

> 截图占位 - 后续添加实际应用截图

## 🚀 快速开始

### 环境要求
- macOS 12.0+
- Xcode 14.0+
- Flutter 3.0+
- CocoaPods
- iPhone (iOS 13.0+)

### 克隆项目
```bash
git clone https://github.com/leejaywei/singhelper.git
cd singhelper
```

### 安装依赖
```bash
# Flutter 依赖
flutter pub get

# iOS 依赖
cd ios
pod install
cd ..
```

### 运行 App
```bash
# 连接 iPhone
flutter devices

# 运行
flutter run
```

### 详细指南
- [编译打包运行指南](docs/BUILD_AND_RUN.md) - 详细的 iPhone 编译步骤
- [API 配置指南](docs/API_SETUP_GUIDE.md) - 如何获取和配置 API Key
- [设计文档](docs/DESIGN.md) - 架构设计和技术方案

## 🛠️ 技术栈

### 核心框架
- **Flutter 3.x** - 跨平台 UI 框架
- **Dart** - 编程语言

### 状态管理
- **flutter_riverpod** - 响应式状态管理

### 本地存储
- **sqflite** - SQLite 数据库
- **shared_preferences** - 简单键值存储
- **path_provider** - 文件路径管理

### 音频处理
- **just_audio** - 音频播放
- **record** - 录音
- **audio_session** - 音频会话管理

### AI & 网络
- **dio** - HTTP 客户端
- Replicate API - 人声分离（Demucs）
- Groq API - 歌词识别（Whisper）

### 可视化
- **fl_chart** - 音高曲线图表

### 路由
- **go_router** - 声明式路由

### 工具库
- **uuid** - 唯一 ID 生成
- **permission_handler** - 权限管理
- **file_picker** - 文件选择

### 算法
- **YIN** - 音高检测算法（自实现）
- **评分引擎** - 自定义评分算法

## 📖 使用说明

### 1. 配置 API Key
1. 打开 App，点击右上角设置图标
2. 获取 [Groq API Key](https://console.groq.com)（免费）
3. 获取 [Replicate API Token](https://replicate.com)（按需付费）
4. 在设置页面配置并测试连接

### 2. 导入歌曲
1. 点击主页 "导入歌曲" 按钮
2. 选择音频文件（MP3/WAV/M4A）
3. 填写歌曲名称和歌手
4. 确认导入

### 3. AI 处理
1. 点击导入的歌曲
2. 点击 "AI 处理" 按钮
3. 等待人声分离和歌词识别完成（约 2-3 分钟）

### 4. 开始练唱
1. 点击已处理的歌曲进入练唱模式
2. 调整播放速度和音调（可选）
3. 点击播放，跟随歌词演唱
4. 点击录音按钮记录你的演唱
5. 停止后查看详细评分

## 🏗️ 项目结构

```
singhelper/
├── docs/                      # 文档
│   ├── DESIGN.md              # 设计文档
│   ├── BUILD_AND_RUN.md       # 编译运行指南
│   └── API_SETUP_GUIDE.md     # API 配置指南
├── lib/
│   ├── main.dart              # 应用入口
│   ├── app.dart               # App 配置
│   ├── core/                  # 核心工具
│   │   ├── constants/         # 常量
│   │   ├── theme/             # 主题
│   │   └── router/            # 路由
│   ├── data/                  # 数据层
│   │   ├── local/             # 本地存储
│   │   └── api/               # API 客户端
│   ├── domain/                # 领域模型
│   │   └── models/            # 数据模型
│   ├── services/              # 核心服务
│   │   ├── audio/             # 音频服务
│   │   ├── pitch/             # 音高检测
│   │   ├── scoring/           # 评分引擎
│   │   └── ai/                # AI 服务
│   ├── providers/             # 状态管理
│   └── presentation/          # UI 层
│       ├── pages/             # 页面
│       └── widgets/           # 组件
├── ios/                       # iOS 配置
├── pubspec.yaml               # 依赖配置
└── README.md                  # 本文件
```

## 🎯 核心算法

### YIN 音高检测
- 基于自相关的时域算法
- 高精度、低延迟
- 完全在设备本地运行

### 智能评分系统
- **音准**: 音分偏差分析
- **节奏**: 时间对齐检测
- **高音**: 频率阈值判断
- **稳定性**: 音高方差统计

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [Flutter](https://flutter.dev) - 优秀的跨平台框架
- [Replicate](https://replicate.com) - AI 模型服务
- [Groq](https://groq.com) - 免费 Whisper API
- YIN 算法论文作者

## 📞 联系方式

- 项目主页: [https://github.com/leejaywei/singhelper](https://github.com/leejaywei/singhelper)
- 问题反馈: [GitHub Issues](https://github.com/leejaywei/singhelper/issues)

---

**享受练唱，提升唱功！🎤✨**