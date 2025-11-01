// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_page_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchUserService)
const fetchUserServiceProvider = FetchUserServiceProvider._();

final class FetchUserServiceProvider
    extends $FunctionalProvider<UserService, UserService, UserService>
    with $Provider<UserService> {
  const FetchUserServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fetchUserServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fetchUserServiceHash();

  @$internal
  @override
  $ProviderElement<UserService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserService create(Ref ref) {
    return fetchUserService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserService>(value),
    );
  }
}

String _$fetchUserServiceHash() => r'3c0bb88b03eea07fefc061f46bf27d490b695a05';

@ProviderFor(fetchUsers)
const fetchUsersProvider = FetchUsersFamily._();

final class FetchUsersProvider
    extends $FunctionalProvider<AsyncValue<User>, User, FutureOr<User>>
    with $FutureModifier<User>, $FutureProvider<User> {
  const FetchUsersProvider._({
    required FetchUsersFamily super.from,
    required (int, int) super.argument,
  }) : super(
         retry: null,
         name: r'fetchUsersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchUsersHash();

  @override
  String toString() {
    return r'fetchUsersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<User> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<User> create(Ref ref) {
    final argument = this.argument as (int, int);
    return fetchUsers(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchUsersHash() => r'e876a2f000e5e93db2e0326f241c61f2cd77032f';

final class FetchUsersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<User>, (int, int)> {
  const FetchUsersFamily._()
    : super(
        retry: null,
        name: r'fetchUsersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchUsersProvider call(int page, int limit) =>
      FetchUsersProvider._(argument: (page, limit), from: this);

  @override
  String toString() => r'fetchUsersProvider';
}

@ProviderFor(fetchUserById)
const fetchUserByIdProvider = FetchUserByIdFamily._();

final class FetchUserByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserElement>,
          UserElement,
          FutureOr<UserElement>
        >
    with $FutureModifier<UserElement>, $FutureProvider<UserElement> {
  const FetchUserByIdProvider._({
    required FetchUserByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'fetchUserByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchUserByIdHash();

  @override
  String toString() {
    return r'fetchUserByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserElement> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserElement> create(Ref ref) {
    final argument = this.argument as int;
    return fetchUserById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchUserByIdHash() => r'd9599fb09db54b37e89c71f004ec5e794c6f2fe6';

final class FetchUserByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserElement>, int> {
  const FetchUserByIdFamily._()
    : super(
        retry: null,
        name: r'fetchUserByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchUserByIdProvider call(int id) =>
      FetchUserByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'fetchUserByIdProvider';
}

@ProviderFor(createUser)
const createUserProvider = CreateUserFamily._();

final class CreateUserProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  const CreateUserProvider._({
    required CreateUserFamily super.from,
    required (String, XFile?) super.argument,
  }) : super(
         retry: null,
         name: r'createUserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createUserHash();

  @override
  String toString() {
    return r'createUserProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    final argument = this.argument as (String, XFile?);
    return createUser(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateUserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createUserHash() => r'50e53fcca8c5a9063938b76f6da83eded833ffb7';

final class CreateUserFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<dynamic>, (String, XFile?)> {
  const CreateUserFamily._()
    : super(
        retry: null,
        name: r'createUserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateUserProvider call(String name, XFile? image) =>
      CreateUserProvider._(argument: (name, image), from: this);

  @override
  String toString() => r'createUserProvider';
}
