import 'package:admin/data/models/scheme.dart'; // Scheme model

class SchemesState {
  final bool isLoading;
  final bool isPopupOpen;
  final bool isSubmitting;
  final List<Scheme> schemes;
  final int currentPage;   // <-- New field
  final String? error;

  const SchemesState({
    this.isLoading = false,
    this.isPopupOpen = false,
    this.isSubmitting = false,
    this.schemes = const [],
    this.currentPage = 1,   // <-- default 1
    this.error,
  });

  SchemesState copyWith({
    bool? isLoading,
    bool? isPopupOpen,
    bool? isSubmitting,
    List<Scheme>? schemes,
    int? currentPage,
    String? error,
  }) {
    return SchemesState(
      isLoading: isLoading ?? this.isLoading,
      isPopupOpen: isPopupOpen ?? this.isPopupOpen,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      schemes: schemes ?? this.schemes,
      currentPage: currentPage ?? this.currentPage, // <-- added
      error: error ?? this.error,
    );
  }
}
