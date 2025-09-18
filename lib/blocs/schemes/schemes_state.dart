import 'package:admin/data/models/scheme.dart';

class SchemesState {
  final List<Scheme> schemes;
  final bool isLoading;
  final String? error;
  final bool isPopupOpen;
  final bool isSubmitting;
  final Scheme? editingScheme; // NEW: Used to prefill edit form
  final int totalCount;
  final int currentPage;
  final int totalPages;

  const SchemesState({
    this.schemes = const [],
    this.isLoading = false,
    this.error,
    this.isPopupOpen = false,
    this.isSubmitting = false,
    this.editingScheme,
    this.totalCount = 0,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  SchemesState copyWith({
    List<Scheme>? schemes,
    bool? isLoading,
    String? error,
    bool? isPopupOpen,
    bool? isSubmitting,
    Scheme? editingScheme,
    int? totalCount,
    int? currentPage,
    int? totalPages,
  }) {
    return SchemesState(
      schemes: schemes ?? this.schemes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isPopupOpen: isPopupOpen ?? this.isPopupOpen,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      editingScheme: editingScheme ?? this.editingScheme,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
