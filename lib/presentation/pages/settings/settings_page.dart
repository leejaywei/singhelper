import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/ai/ai_processing_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _replicateKeyController = TextEditingController();
  final _groqKeyController = TextEditingController();
  bool _obscureReplicate = true;
  bool _obscureGroq = true;
  bool _isTesting = false;

  @override
  void dispose() {
    _replicateKeyController.dispose();
    _groqKeyController.dispose();
    super.dispose();
  }

  Future<void> _testConnection(String service) async {
    setState(() => _isTesting = true);

    try {
      final settings = await ref.read(settingsServiceProvider).getSettings();
      late AiProcessingService aiService;

      if (service == 'replicate') {
        aiService = AiProcessingService(
          replicateApiKey: _replicateKeyController.text.isNotEmpty
              ? _replicateKeyController.text
              : settings.replicateApiKey,
        );
        final success = await aiService.testReplicateConnection();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? 'Replicate 连接成功！' : 'Replicate 连接失败'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      } else if (service == 'groq') {
        aiService = AiProcessingService(
          groqApiKey: _groqKeyController.text.isNotEmpty
              ? _groqKeyController.text
              : settings.groqApiKey,
        );
        final success = await aiService.testGroqConnection();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? 'Groq 连接成功！' : 'Groq 连接失败'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('测试失败: $e')),
        );
      }
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _saveKeys() async {
    if (_replicateKeyController.text.isNotEmpty) {
      await ref
          .read(settingsNotifierProvider.notifier)
          .saveReplicateApiKey(_replicateKeyController.text);
    }

    if (_groqKeyController.text.isNotEmpty) {
      await ref
          .read(settingsNotifierProvider.notifier)
          .saveGroqApiKey(_groqKeyController.text);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API Key 已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: settingsAsync.when(
        data: (settings) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'AI 服务配置',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '所有 API Key 仅保存在本地，不会上传到任何服务器',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                
                // Replicate API Key
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.api,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Replicate API',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '用于人声分离 (Demucs 模型)',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _replicateKeyController,
                          obscureText: _obscureReplicate,
                          decoration: InputDecoration(
                            labelText: 'API Key',
                            hintText: settings.hasReplicateKey
                                ? '已配置'
                                : '粘贴 Replicate API Key',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureReplicate
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureReplicate = !_obscureReplicate;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isTesting
                              ? null
                              : () => _testConnection('replicate'),
                          icon: const Icon(Icons.cable),
                          label: const Text('测试连接'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Groq API Key
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mic,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Groq API',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '用于歌词识别 (Whisper large-v3)',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _groqKeyController,
                          obscureText: _obscureGroq,
                          decoration: InputDecoration(
                            labelText: 'API Key',
                            hintText: settings.hasGroqKey
                                ? '已配置'
                                : '粘贴 Groq API Key',
                            suffixIcon: IconButton(
                              icon: Icon(_obscureGroq
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _obscureGroq = !_obscureGroq;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _isTesting
                              ? null
                              : () => _testConnection('groq'),
                          icon: const Icon(Icons.cable),
                          label: const Text('测试连接'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _saveKeys,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('保存配置', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Help Section
                Card(
                  color: Colors.orange.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.help_outline,
                              color: Colors.orange[300],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '如何获取 API Key？',
                              style: TextStyle(
                                color: Colors.orange[300],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Replicate: 访问 replicate.com 注册并获取 API token\n'
                          '• Groq: 访问 console.groq.com 注册并创建 API key (免费)',
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '详细说明请查看项目文档 docs/API_SETUP_GUIDE.md',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载失败: $error')),
      ),
    );
  }
}
