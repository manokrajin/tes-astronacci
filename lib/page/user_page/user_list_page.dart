import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tes_astronacci/model/user.dart';
import 'package:tes_astronacci/service/remote_service/user_service.dart';

import 'create_user_page.dart';
import 'user_detail_page.dart';

final usersProvider = FutureProvider.family<User, int>((ref, page) async {
  final service = UserService();
  return service.getUsers(page: page, limit: 10);
});

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<UserElement> _allUsers = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreUsers();
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_isLoadingMore || !_hasMorePages) return;

    setState(() {
      _isLoadingMore = true;
      _errorMessage = null;
    });

    try {
      final nextPage = _currentPage + 1;
      final userData = await ref.read(usersProvider(nextPage).future);

      setState(() {
        _allUsers.addAll(userData.users);
        _currentPage = nextPage;
        _hasMorePages = nextPage < userData.totalPages;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _errorMessage = 'Failed to load more users: $e';
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _allUsers.clear();
      _currentPage = 1;
      _hasMorePages = true;
      _errorMessage = null;
    });

    ref.invalidate(usersProvider(1));
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider(_currentPage));

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Create'),
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreateUserPage()),
          );

          if (created == true) {
            await _refresh();
            try {
              final firstPage = await ref.read(usersProvider(1).future);
              setState(() {
                _allUsers.addAll(firstPage.users);
                _hasMorePages = 1 < firstPage.totalPages;
              });
            } catch (_) {}
          }
        },
      ),
      body: usersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) {
          final svc = UserService();
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: $err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text('Base URL: ${svc.baseUrl}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      ref.invalidate(usersProvider(_currentPage));
                      try {
                        await ref.read(usersProvider(_currentPage).future);
                      } catch (_) {}
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (userData) {
          if (_allUsers.isEmpty && userData.users.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _allUsers.addAll(userData.users);
                _hasMorePages = _currentPage < userData.totalPages;
              });
            });
          }

          if (_allUsers.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(child: Text('No users found')),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _allUsers.length + (_hasMorePages ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _allUsers.length) {
                  if (_errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _loadMoreUsers,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final u = _allUsers[index];

                Widget avatar;
                try {
                  Uint8List imageBytes = base64Decode(u.imageBase64);

                  if (imageBytes.isNotEmpty) {
                    avatar = CircleAvatar(
                      radius: 28,
                      backgroundImage: MemoryImage(imageBytes),
                    );
                  } else {
                    avatar = CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error decoding image for user ${u.id}: $e');
                  avatar = CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueGrey,
                    child: Text(
                      u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                }

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    leading: avatar,
                    title: Text(
                      u.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('ID: ${u.id}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(userId: u.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
