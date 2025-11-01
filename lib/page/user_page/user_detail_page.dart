import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_astronacci/page/user_page/user_page_provider/user_page_provider.dart';

class UserDetailPage extends ConsumerWidget {
  final int userId;
  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(fetchUserByIdProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: asyncUser.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load user: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (user) {
          Uint8List? imageBytes;
          try {
            if (user.imageBase64 != null &&
                user.imageBase64 is String &&
                (user.imageBase64 as String).isNotEmpty) {
              imageBytes = base64Decode(user.imageBase64 as String);
            } else if (user.imageBase64 is List<int>) {
              imageBytes = Uint8List.fromList(
                List<int>.from(user.imageBase64 as List),
              );
            }
          } catch (e) {
            imageBytes = null;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes)
                          : null,
                      child: imageBytes == null
                          ? Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    initialValue: user.name,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ID: ${user.id}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
