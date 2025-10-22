import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:presales_app_store/src/services/api_service.dart';
import 'package:go_router/go_router.dart';

final uploadProvider = StateNotifierProvider.autoDispose<UploadNotifier, UploadState>((ref) {
  return UploadNotifier(ref.read(apiServiceProvider));
});

class UploadNotifier extends StateNotifier<UploadState> {
  final ApiService _apiService;

  UploadNotifier(this._apiService) : super(UploadInitial());

  Future<void> uploadApp({
    required String name,
    required String version,
    required String purpose,
    required String platform,
    required String filePath,
  }) async {
    try {
      state = UploadInProgress(0);
      await _apiService.uploadApp(
        name: name,
        version: version,
        purpose: purpose,
        platform: platform,
        filePath: filePath,
        onSendProgress: (sent, total) {
          if (total != 0) {
            state = UploadInProgress(sent / total);
          }
        },
      );
      state = UploadSuccess();
    } catch (e) {
      state = UploadFailure(e.toString());
    }
  }
}

abstract class UploadState {}

class UploadInitial extends UploadState {}

class UploadInProgress extends UploadState {
  final double progress;
  UploadInProgress(this.progress);
}

class UploadSuccess extends UploadState {}

class UploadFailure extends UploadState {
  final String error;
  UploadFailure(this.error);
}

class UploadForm extends ConsumerStatefulWidget {
  const UploadForm({super.key});

  @override
  ConsumerState<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends ConsumerState<UploadForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _versionController = TextEditingController();
  final _purposeController = TextEditingController();
  String _platform = 'android';
  String? _filePath;
  String? _fileName;

  @override
  void dispose() {
    _nameController.dispose();
    _versionController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['apk', 'ipa'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_filePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a file to upload.')),
        );
        return;
      }
      ref.read(uploadProvider.notifier).uploadApp(
            name: _nameController.text,
            version: _versionController.text,
            purpose: _purposeController.text,
            platform: _platform,
            filePath: _filePath!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UploadState>(uploadProvider, (previous, next) {
      if (next is UploadSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
        // Go back to the dashboard after successful upload
        context.pop();
      } else if (next is UploadFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${next.error}')),
        );
      }
    });

    final uploadState = ref.watch(uploadProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'App Name', border: OutlineInputBorder()),
            validator: (value) => value!.isEmpty ? 'Please enter an app name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _versionController,
            decoration: const InputDecoration(labelText: 'Version', border: OutlineInputBorder()),
            validator: (value) => value!.isEmpty ? 'Please enter a version' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _purposeController,
            decoration: const InputDecoration(labelText: 'Purpose', border: OutlineInputBorder()),
            validator: (value) => value!.isEmpty ? 'Please enter the purpose' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _platform,
            items: ['android', 'ios']
                .map((p) => DropdownMenuItem(value: p, child: Text(p.toUpperCase())))
                .toList(),
            onChanged: (value) => setState(() => _platform = value!),
            decoration: const InputDecoration(labelText: 'Platform', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('Select File'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _fileName ?? 'No file selected.',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (uploadState is UploadInProgress)
            LinearProgressIndicator(value: uploadState.progress),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: (uploadState is UploadInProgress) ? null : _submitForm,
            child: (uploadState is UploadInProgress)
                ? const Text('Uploading...')
                : const Text('Upload App', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}