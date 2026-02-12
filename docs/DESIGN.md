# 设计文档 - 练唱助手 App

## 1. 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐│
│  │  Home    │  │ Practice │  │  Score   │  │ Settings ││
│  │  Page    │  │   Page   │  │   Page   │  │   Page   ││
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘│
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  State Management (Riverpod)             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ Song Provider│  │Audio Provider│  │Settings Prov.│  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                      Services Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐│
│  │  Audio   │  │  Pitch   │  │ Scoring  │  │   AI    ││
│  │ Service  │  │ Detector │  │  Engine  │  │ Service ││
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘│
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                        Data Layer                        │
│  ┌──────────────┐             ┌─────────────────────┐  │
│  │   SQLite DB  │             │   API Clients       │  │
│  │  (DAOs)      │             │ (Replicate, Groq)   │  │
│  └──────────────┘             └─────────────────────┘  │
│  ┌──────────────────────────────────────────────────┐  │
│  │        Local File Storage (Audio Files)          │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## 2. 模块详细说明

### 2.1 Presentation Layer (UI 层)

#### HomePage
- **功能**: 展示已导入的歌曲列表
- **组件**: 
  - 歌曲列表卡片 (显示标题、歌手、处理状态)
  - 导入按钮
  - 设置入口
- **交互**: 点击已处理的歌曲进入练唱页面

#### ImportPage
- **功能**: 导入本地音频文件
- **组件**:
  - 文件选择器
  - 歌曲信息输入表单
  - 导入按钮
- **流程**: 选择文件 → 填写信息 → 复制到应用沙盒 → 保存到数据库

#### PracticePage (核心页面)
- **功能**: 实时练唱功能
- **组件**:
  - 歌词滚动显示器 (当前句高亮，高音标红)
  - 音高曲线可视化 (参考音高 vs 实唱音高)
  - 音频播放控制器
  - 录音控制按钮
  - 速度调节滑块 (0.5x - 2.0x)
  - 升降调滑块 (-6 ~ +6 半音)
- **实时处理**:
  - 音频播放同步
  - 歌词滚动同步
  - 实时音高检测
  - 实时音高曲线绘制

#### ScorePage
- **功能**: 展示练唱评分结果
- **组件**:
  - 总分显示 (0-100)
  - 四维度评分雷达图
  - 逐句评分详情列表
  - 文字反馈建议
  - 录音回放按钮

#### SettingsPage
- **功能**: API Key 配置管理
- **组件**:
  - Replicate API Key 输入框
  - Groq API Key 输入框
  - API 提供商选择器
  - 测试连接按钮
  - 帮助说明文本

### 2.2 Services Layer (服务层)

#### AudioPlayerService
- **职责**: 音频播放管理
- **功能**:
  - 加载音频文件
  - 播放/暂停/停止
  - 进度跳转
  - 变速播放
  - 升降调
- **依赖**: just_audio 包

#### RecordingService
- **职责**: 录音管理
- **功能**:
  - 开始/停止录音
  - 权限检查
  - 录音文件保存
- **依赖**: record 包

#### YinPitchDetector
- **职责**: 实时音高检测
- **算法**: YIN 算法 (最优音高检测算法)
- **输入**: 音频缓冲区 (PCM 数据)
- **输出**: 频率 (Hz) 或 null (无音高)
- **特点**: 
  - 100% 端侧运行
  - 低延迟
  - 高精度

#### ScoringEngine
- **职责**: 计算练唱评分
- **输入**: 
  - 参考歌词 + 音高数据
  - 录制音高数据
- **输出**: PracticeScore 对象
- **评分维度**:
  1. **音准 (40%)**: 逐帧比较用户与参考音高偏差（单位：音分 cents）
  2. **节奏 (25%)**: 检测发声时间与参考时间的匹配度
  3. **高音达成 (20%)**: 高音区域是否达到要求频率
  4. **稳定性 (15%)**: 长音的音高方差（标准差）

#### AiProcessingService
- **职责**: AI 功能适配层
- **功能**:
  - 调用 Replicate API 进行人声分离
  - 调用 Groq API 进行歌词识别
  - 本地音高分析（标记高音句）

### 2.3 Data Layer (数据层)

#### SQLite 数据库设计

##### songs 表
```sql
CREATE TABLE songs (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  original_file_path TEXT NOT NULL,
  vocal_file_path TEXT,
  instrumental_file_path TEXT,
  is_processed INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  processed_at TEXT
)
```

##### lyrics 表
```sql
CREATE TABLE lyrics (
  id TEXT PRIMARY KEY,
  song_id TEXT NOT NULL,
  line_number INTEGER NOT NULL,
  text TEXT NOT NULL,
  start_time REAL NOT NULL,
  end_time REAL NOT NULL,
  reference_pitch REAL,
  is_high_note INTEGER DEFAULT 0,
  FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
)
```

##### scores 表
```sql
CREATE TABLE scores (
  id TEXT PRIMARY KEY,
  song_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  total_score REAL NOT NULL,
  pitch_score REAL NOT NULL,
  rhythm_score REAL NOT NULL,
  high_note_score REAL NOT NULL,
  stability_score REAL NOT NULL,
  recording_file_path TEXT,
  FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
)
```

##### line_scores 表
```sql
CREATE TABLE line_scores (
  id TEXT PRIMARY KEY,
  score_id TEXT NOT NULL,
  line_number INTEGER NOT NULL,
  score REAL NOT NULL,
  pitch_accuracy REAL NOT NULL,
  rhythm_accuracy REAL NOT NULL,
  FOREIGN KEY (score_id) REFERENCES scores (id) ON DELETE CASCADE
)
```

#### 本地文件存储结构
```
App Documents/
├── songs/                    # 原始音频文件
│   ├── {song_id}.mp3
│   ├── {song_id}_vocal.mp3   # 分离后的人声
│   └── {song_id}_inst.mp3    # 分离后的伴奏
├── recordings/               # 录音文件
│   └── {recording_id}.m4a
└── singhelper.db             # SQLite 数据库
```

## 3. 数据流图

### 3.1 歌曲导入流程
```
用户选择文件 → FilePicker
    ↓
复制到应用沙盒 → File I/O
    ↓
创建 Song 记录 → SongDao.insert()
    ↓
更新 UI → Riverpod Provider 通知
```

### 3.2 AI 处理流程
```
用户点击处理 → SettingsPage 验证 API Key
    ↓
上传音频到云存储 (用户需自行实现)
    ↓
调用 Replicate API → 人声分离 (Demucs)
    ↓
下载分离结果 → 保存到本地
    ↓
调用 Groq API → 歌词识别 (Whisper)
    ↓
保存歌词到数据库 → LyricDao.insert()
    ↓
本地音高分析 → 标记高音句
    ↓
更新 Song.isProcessed = true
```

### 3.3 练唱流程
```
加载歌曲数据 → Song + Lyrics 从数据库
    ↓
播放伴奏 → AudioPlayerService
    ↓
实时录音 → RecordingService
    ↓
音频流处理 → YinPitchDetector
    ↓
音高数据收集 → List<PitchData>
    ↓
实时更新 UI → 歌词滚动 + 音高曲线
    ↓
录音结束 → 保存录音文件
    ↓
计算评分 → ScoringEngine
    ↓
保存评分 → ScoreDao.insert()
    ↓
跳转到评分页面
```

## 4. 技术选型理由

### 4.1 Flutter
- **跨平台**: 一套代码支持 iOS 和 Android
- **性能**: 接近原生性能
- **UI**: 丰富的 Material Design 组件
- **社区**: 活跃的生态系统

### 4.2 Riverpod
- **类型安全**: 编译时类型检查
- **性能**: 精确的重建控制
- **可测试**: 依赖注入友好

### 4.3 SQLite
- **嵌入式**: 无需服务器
- **轻量**: 适合移动设备
- **可靠**: 成熟的数据库引擎

### 4.4 just_audio
- **跨平台**: iOS/Android 一致 API
- **功能丰富**: 支持变速、变调
- **低延迟**: 适合实时应用

### 4.5 YIN 算法
- **精度高**: 业界公认的最佳音高检测算法
- **实时性**: 延迟低于 50ms
- **鲁棒性**: 对噪声有较好抵抗

## 5. AI 模块说明

### 5.1 使用 AI 的功能
1. **人声分离** (Replicate API - Demucs)
   - 云端处理
   - 需要 API Key
   - 处理时间: 约 1-3 分钟

2. **歌词生成** (Groq API - Whisper large-v3)
   - 云端处理
   - 需要 API Key
   - 免费额度充足
   - 处理时间: 约 10-30 秒

### 5.2 不使用 AI 的功能（端侧处理）
1. **音高检测** (YIN 算法)
   - 100% 本地运行
   - 实时处理
   - 无需网络

2. **评分系统** (自定义算法)
   - 100% 本地计算
   - 基于音高数据的数学分析
   - 无需网络

## 6. 安全性与隐私

### 6.1 数据存储
- 所有数据保存在 iOS 应用沙盒
- SQLite 数据库位于本地
- API Key 使用 SharedPreferences 加密存储

### 6.2 网络通信
- 仅在用户主动触发时调用 API
- 直接与 API 提供商通信，无中间服务器
- 不收集用户数据

### 6.3 权限使用
- 麦克风: 录音和实时音高检测
- 文件访问: 导入音频文件
- 音频后台播放: 练唱时可后台播放

## 7. 性能优化

### 7.1 音频处理
- YIN 算法使用固定缓冲区，避免内存分配
- 音频流处理使用异步队列
- 音高数据按时间窗口批量处理

### 7.2 UI 渲染
- 歌词滚动使用 ListView.builder 懒加载
- 音高曲线使用采样点减少绘制量
- 评分页面使用缓存避免重复计算

### 7.3 数据库查询
- 使用索引加速常用查询
- 批量插入使用事务
- 懒加载歌曲列表

## 8. 可扩展性

### 8.1 支持自定义 API
- 设置页面可配置自定义 API URL
- 适配器模式方便添加新的 AI 服务

### 8.2 支持其他音高检测算法
- 接口化设计，可替换 YIN 算法
- 可添加 CREPE、PYIN 等算法

### 8.3 支持其他评分维度
- ScoringEngine 模块化，易于添加新维度
- 权重可配置化
