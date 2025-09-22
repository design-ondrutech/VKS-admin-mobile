import 'package:admin/data/models/create_scheme.dart';
import 'package:equatable/equatable.dart';

class CreateSchemeState extends Equatable {
  final bool isLoading;
  final CreateSchemeModel? createdScheme;
  final bool isUpdated; //  New flag to detect update success
  final String? error;

  const CreateSchemeState({
    this.isLoading = false,
    this.createdScheme,
    this.isUpdated = false,
    this.error,
  });

  CreateSchemeState copyWith({
    bool? isLoading,
    CreateSchemeModel? createdScheme,
    bool? isUpdated,
    String? error,
  }) {
    return CreateSchemeState(
      isLoading: isLoading ?? this.isLoading,
      createdScheme: createdScheme ?? this.createdScheme,
      isUpdated: isUpdated ?? this.isUpdated,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, createdScheme, isUpdated, error];
}
