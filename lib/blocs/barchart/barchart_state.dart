class ChartState {
  final List<double> goldEleven;
  final List<double> digitalGold;
  final List<String> months;
  final bool loading;
  final String? error;

  ChartState({
    this.goldEleven = const [],
    this.digitalGold = const [],
    this.months = const [],
    this.loading = false,
    this.error,
  });

  ChartState copyWith({
    List<double>? goldEleven,
    List<double>? digitalGold,
    List<String>? months,
    bool? loading,
    String? error,
  }) {
    return ChartState(
      goldEleven: goldEleven ?? this.goldEleven,
      digitalGold: digitalGold ?? this.digitalGold,
      months: months ?? this.months,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
