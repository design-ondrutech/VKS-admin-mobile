abstract class TodayActiveSchemeEvent {}

class FetchTodayActiveSchemes extends TodayActiveSchemeEvent {
  final String startDate;
  FetchTodayActiveSchemes(this.startDate);
}
