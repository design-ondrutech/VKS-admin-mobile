import 'package:admin/data/models/create_scheme.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

class CreateSchemeState extends Equatable {
  final bool isLoading;
  final CreateSchemeModel? createdScheme;
  final String? error;

  const CreateSchemeState({
    this.isLoading = false,
    this.createdScheme,
    this.error,
  });

  CreateSchemeState copyWith({
    bool? isLoading,
    CreateSchemeModel? createdScheme,
    String? error,
  }) {
    return CreateSchemeState(
      isLoading: isLoading ?? this.isLoading,
      createdScheme: createdScheme ?? this.createdScheme,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, createdScheme, error];
}
