import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:presales_app_store/src/services/api_service.dart';

final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>((ref) {
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
          state = UploadInProgress(sent / total);
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

  @override
  Widget build(BuildContext context) {
    ref.listen<UploadState>(uploadProvider, (previous, next) {
      if (next is UploadSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
        _formKey.currentState?.reset();
        setState(() {
          _filePath = null;
        });
      } else if (next is UploadFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error)),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'App Name'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _versionController,
            decoration: const InputDecoration(labelText: 'Version'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _purposeController,
            decoration: const InputDecoration(labelText: 'Purpose'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          DropdownButtonFormField<String>(
            value: _platform,
            items: ['android', 'ios']
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (value) => setState(() => _platform = value!),
            decoration: const InputDecoration(labelText: 'Platform'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() => _filePath = result.files.single.path);
                  }
                },
                child: const Text('Select File'),
              ),
              const SizedBox(width: 10),
              if (_filePath != null) Text(_filePath!),
            ],
          ),
          const SizedBox(height: 20),
          Consumer(
            builder: (context, ref, child) {
              final uploadState = ref.watch(uploadProvider);
              if (uploadState is UploadInProgress) {
                return LinearProgressIndicator(value: uploadState.progress);
              }
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _filePath != null) {
                    ref.read(uploadProvider.notifier).uploadApp(
                          name: _nameController.text,
                          version: _versionController.text,
                          purpose: _purposeController.text,
                          platform: _platform,
                          filePath: _filePath!,
                        );
                  }
                },
                child: const Text('Upload'),
              );
            },
          ),
        ],
      ),
    );
  }
}