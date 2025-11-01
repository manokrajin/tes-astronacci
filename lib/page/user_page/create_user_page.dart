import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:tes_astronacci/page/user_page/user_page_provider/create_user_form_provider.dart';
import 'package:tes_astronacci/page/user_page/user_page_provider/user_page_provider.dart';

class CreateUserPage extends ConsumerStatefulWidget {
  const CreateUserPage({super.key});

  @override
  ConsumerState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends ConsumerState<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final name = ref.read(createUserFormProvider).name;
    _nameController.text = name;
    _nameController.addListener(() {
      ref.read(createUserFormProvider.notifier).setName(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndCropImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) return;

      try {
        final CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop avatar',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false,
            ),
            IOSUiSettings(title: 'Crop avatar'),
          ],
        );

        if (cropped == null) return;

        ref.read(createUserFormProvider.notifier).setImage(XFile(cropped.path));
      } on MissingPluginException catch (_) {
        try {
          final bytes = await picked.readAsBytes();

          final originalExt = path.extension(picked.path);
          final fileName =
              'cropped_${DateTime.now().millisecondsSinceEpoch}$originalExt';
          final tempDir = Directory.systemTemp;
          final tmpPath = path.join(tempDir.path, fileName);

          final tmpFile = await File(tmpPath).writeAsBytes(bytes);

          ref
              .read(createUserFormProvider.notifier)
              .setImage(XFile(tmpFile.path));
        } catch (e) {
          print('Fallback crop failed: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to crop image: $e')));
        }
      }
    } catch (e) {
      print('Error picking/cropping image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick/crop image: $e')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(createUserFormProvider.notifier).setSubmitting(true);

    final state = ref.read(createUserFormProvider);

    try {
      await ref.read(createUserProvider(state.name, state.image).future);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully')),
      );

      ref.read(createUserFormProvider.notifier).reset();

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create user: $e')));
    } finally {
      if (mounted) {
        ref.read(createUserFormProvider.notifier).setSubmitting(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createUserFormProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickAndCropImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: state.image != null
                        ? FileImage(File(state.image!.path))
                        : null,
                    child: state.image == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 36,
                            color: Colors.black54,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: state.isSubmitting ? null : _submit,
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
