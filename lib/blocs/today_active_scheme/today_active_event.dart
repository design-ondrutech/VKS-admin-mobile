abstract class TodayActiveSchemeEvent {}

class FetchTodayActiveSchemes extends TodayActiveSchemeEvent {
  final String? startDate;
  final String? savingId;

  FetchTodayActiveSchemes({this.startDate, this.savingId});
}
