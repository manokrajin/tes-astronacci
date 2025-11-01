import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserFormState {
  final String name;
  final XFile? image;
  final bool isSubmitting;

  const CreateUserFormState({
    this.name = '',
    this.image,
    this.isSubmitting = false,
  });

  CreateUserFormState copyWith({
    String? name,
    XFile? image,
    bool? isSubmitting,
  }) {
    return CreateUserFormState(
      name: name ?? this.name,
      image: image ?? this.image,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CreateUserFormNotifier extends StateNotifier<CreateUserFormState> {
  CreateUserFormNotifier() : super(const CreateUserFormState());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setImage(XFile? image) {
    state = state.copyWith(image: image);
  }

  void setSubmitting(bool submitting) {
    state = state.copyWith(isSubmitting: submitting);
  }

  void reset() {
    state = const CreateUserFormState();
  }
}

final createUserFormProvider =
    StateNotifierProvider<CreateUserFormNotifier, CreateUserFormState>((ref) {
      return CreateUserFormNotifier();
    });
