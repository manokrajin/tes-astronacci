import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tes_astronacci/model/user.dart';
import 'package:tes_astronacci/service/remote_service/user_service.dart';

part 'user_page_provider.g.dart';

@Riverpod(keepAlive: true)
UserService fetchUserService(Ref ref) {
  return UserService();
}

@riverpod
Future<User> fetchUsers(Ref ref, int page, int limit) async {
  final user = ref.read(fetchUserServiceProvider);
  return user.getUsers(page: page, limit: limit);
}

@riverpod
Future<UserElement> fetchUserById(Ref ref, int id) async {
  final user = ref.read(fetchUserServiceProvider);
  return user.getUserById(id: id);
}

@riverpod
Future<dynamic> createUser(Ref ref, String name, XFile? image) async {
  final user = ref.read(fetchUserServiceProvider);
  return user.createUser(name: name, imageFile: image);
}
