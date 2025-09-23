// active_scheme_event.dart
import 'package:equatable/equatable.dart';

abstract class TotalActiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTotalActiveSchemes extends TotalActiveEvent {}
