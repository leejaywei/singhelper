import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/models/song.dart';
import '../../../data/local/song_dao.dart';

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  String? _selectedFilePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        // Auto-fill title from filename if empty
        if (_titleController.text.isEmpty) {
          final filename = result.files.single.name;
          _titleController.text = filename.replaceAll(RegExp(r'\.[^.]+$'), '');
        }
      });
    }
  }

  Future<void> _importSong() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入歌曲名称')),
      );
      return;
    }

    if (_artistController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入歌手名称')),
      );
      return;
    }

    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择音频文件')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Copy file to app storage
      final directory = await getApplicationDocumentsDirectory();
      final songsDir = Directory('${directory.path}/songs');
      if (!await songsDir.exists()) {
        await songsDir.create(recursive: true);
      }

      final songId = const Uuid().v4();
      final extension = _selectedFilePath!.split('.').last;
      final newPath = '${songsDir.path}/$songId.$extension';
      
      await File(_selectedFilePath!).copy(newPath);

      // Create song record
      final song = Song(
        id: songId,
        title: _titleController.text,
        artist: _artistController.text,
        originalFilePath: newPath,
        createdAt: DateTime.now(),
      );

      final songDao = SongDao();
      await songDao.insertSong(song);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('导入成功！')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导入失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入歌曲'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '歌曲名称',
                      hintText: '输入歌曲名称',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _artistController,
                    decoration: const InputDecoration(
                      labelText: '歌手',
                      hintText: '输入歌手名称',
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.folder_open),
                    label: Text(
                      _selectedFilePath == null
                          ? '选择音频文件'
                          : '已选择: ${_selectedFilePath!.split('/').last}',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _importSong,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('导入', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.blue.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue[300],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '提示',
                                style: TextStyle(
                                  color: Colors.blue[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '导入后，请在设置中配置 API Key，'
                            '然后使用 AI 处理功能分离人声、生成歌词。',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
