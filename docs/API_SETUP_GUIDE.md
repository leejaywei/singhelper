# API 配置指南

本指南详细说明如何获取和配置 AI 服务的 API Key。

## 概述

练唱助手 App 使用两个 AI 服务:
1. **Replicate API** - 用于人声分离 (Demucs 模型)
2. **Groq API** - 用于歌词识别 (Whisper large-v3 模型，免费)

**重要说明**:
- 所有 API Key 仅保存在你的设备本地
- App 直接调用云端 API，不经过任何中间服务器
- 你的数据不会被上传到任何第三方服务器

## 1. Groq API (推荐首先配置，免费)

Groq 提供免费的 Whisper 语音识别服务，用于生成带时间戳的歌词。

### 1.1 注册账号

1. 访问 [Groq Console](https://console.groq.com)
2. 点击 "Sign up" 注册账号
3. 可以使用 Google 账号快速注册
4. 验证邮箱

### 1.2 获取 API Key

1. 登录后，点击左侧导航栏的 "API Keys"
2. 点击 "Create API Key" 按钮
3. 输入 Key 名称（例如: "SingHelper"）
4. 点击 "Create"
5. **立即复制并保存** API Key（关闭弹窗后无法再次查看）

API Key 格式示例:
```
gsk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 1.3 免费额度

Groq 目前提供慷慨的免费额度:
- **每天**: 14,400 requests
- **每分钟**: 30 requests
- 完全免费，无需信用卡

对于个人使用，这个额度非常充足！

### 1.4 在 App 中配置

1. 打开练唱助手 App
2. 点击右上角设置图标
3. 找到 "Groq API" 部分
4. 粘贴你的 API Key
5. 点击 "测试连接" 验证
6. 点击 "保存配置"

## 2. Replicate API (按使用付费)

Replicate 提供各种 AI 模型服务，我们使用它运行 Demucs 模型进行人声分离。

### 2.1 注册账号

1. 访问 [Replicate](https://replicate.com)
2. 点击 "Sign up" 注册
3. 可以使用 GitHub 账号快速注册
4. 验证邮箱

### 2.2 添加支付方式

**注意**: Replicate 需要绑定信用卡才能使用 API。

1. 登录后，点击右上角头像
2. 选择 "Billing"
3. 点击 "Add payment method"
4. 输入信用卡信息

**不用担心**: Replicate 采用按需付费，只有在使用时才会扣费。

### 2.3 获取 API Token

1. 点击右上角头像
2. 选择 "API tokens"
3. 点击 "Create token"
4. 输入 Token 名称（例如: "SingHelper"）
5. 点击 "Create"
6. **立即复制并保存** Token（关闭弹窗后无法再次查看）

API Token 格式示例:
```
r8_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 2.4 费用说明

Demucs 人声分离模型费用:
- **每次运行**: 约 $0.05 - $0.20（根据音频长度）
- 一首 3-4 分钟的歌曲大约 $0.10

**预算参考**:
- 处理 10 首歌: ~$1
- 处理 100 首歌: ~$10

**重要提示**:
- 只有在你点击 "处理歌曲" 时才会产生费用
- 可以在 Replicate 控制台查看实时用量
- 可以设置消费限额防止超支

### 2.5 在 App 中配置

1. 打开练唱助手 App
2. 点击右上角设置图标
3. 找到 "Replicate API" 部分
4. 粘贴你的 API Token
5. 点击 "测试连接" 验证
6. 点击 "保存配置"

## 3. 使用 AI 功能

配置好 API Key 后，就可以使用 AI 功能了！

### 3.1 处理歌曲流程

1. 在首页点击 "导入歌曲"
2. 选择音频文件，填写歌曲信息
3. 导入成功后，歌曲显示为 "未处理" 状态
4. 点击歌曲卡片
5. 点击 "AI 处理" 按钮
6. App 会自动:
   - 使用 Replicate 分离人声和伴奏（约 1-3 分钟）
   - 使用 Groq 识别歌词（约 10-30 秒）
   - 分析并标记高音句
7. 处理完成后，歌曲状态变为 "已处理"
8. 现在可以开始练唱了！

### 3.2 处理时间参考

| 歌曲时长 | Replicate 人声分离 | Groq 歌词识别 | 总计 |
|---------|-------------------|--------------|------|
| 3 分钟  | ~1 分钟           | ~10 秒       | ~1.5 分钟 |
| 5 分钟  | ~2 分钟           | ~20 秒       | ~2.5 分钟 |
| 8 分钟  | ~3 分钟           | ~30 秒       | ~3.5 分钟 |

**注意**: 处理期间需要保持网络连接。

## 4. API 安全建议

### 4.1 保护你的 API Key

- ✅ 只在官方 App 中使用
- ✅ 不要分享给他人
- ✅ 不要截图包含 API Key 的界面
- ✅ 定期更换 API Key
- ❌ 不要上传到 GitHub 或其他公开平台
- ❌ 不要在聊天软件中发送

### 4.2 如果 API Key 泄露

**Groq**:
1. 访问 [Groq Console - API Keys](https://console.groq.com/keys)
2. 删除泄露的 Key
3. 创建新的 Key
4. 在 App 中更新

**Replicate**:
1. 访问 [Replicate - API Tokens](https://replicate.com/account/api-tokens)
2. 撤销泄露的 Token
3. 创建新的 Token
4. 在 App 中更新

### 4.3 监控使用情况

**Groq**:
- 访问 [Groq Console](https://console.groq.com) 查看用量统计

**Replicate**:
- 访问 [Replicate Billing](https://replicate.com/account/billing) 查看费用
- 可以设置每月消费限额

## 5. 常见问题

### Q1: 免费试用选项？
**A**: Groq 完全免费。Replicate 没有免费试用，但费用很低（每首歌约 $0.10）。

### Q2: 可以使用其他 API 提供商吗？
**A**: 目前仅支持 Replicate 和 Groq。未来版本可能支持自定义 API。

### Q3: API Key 保存在哪里？
**A**: API Key 使用 iOS 的安全存储（Keychain）保存在你的设备本地，不会上传到任何服务器。

### Q4: 可以离线使用吗？
**A**: 
- AI 处理（人声分离、歌词识别）需要网络
- 练唱功能完全离线运行
- 音高检测和评分在本地计算

### Q5: 处理失败怎么办？
**A**:
1. 检查网络连接
2. 验证 API Key 是否正确
3. 确认账户余额充足（Replicate）
4. 查看错误提示信息
5. 重试处理

### Q6: 音频文件有限制吗？
**A**:
- 支持格式: MP3, WAV, M4A, FLAC
- 文件大小: 建议 < 50MB
- 时长: 建议 < 10 分钟

### Q7: 歌词识别支持哪些语言？
**A**: Whisper large-v3 支持 99 种语言，包括:
- 中文（普通话、粤语）
- 英语
- 日语
- 韩语
- 等等

### Q8: 人声分离效果如何？
**A**: Demucs 是目前最先进的人声分离模型之一，对于大多数歌曲都能获得很好的分离效果。特殊情况（如 a cappella 或极重的混响）可能效果较差。

## 6. 技术支持

如遇到 API 相关问题:

**Groq**:
- [官方文档](https://console.groq.com/docs)
- [社区论坛](https://github.com/groq)

**Replicate**:
- [官方文档](https://replicate.com/docs)
- [Discord 社区](https://discord.gg/replicate)

**App 问题**:
- 项目 [GitHub Issues](https://github.com/leejaywei/singhelper/issues)

---

**准备好了吗？开始配置你的 API Key，享受 AI 驱动的练唱体验吧！🎤**
