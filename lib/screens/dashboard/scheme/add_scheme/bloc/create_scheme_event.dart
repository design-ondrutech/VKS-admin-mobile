import 'package:equatable/equatable.dart';

abstract class CreateSchemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// CREATE event
class SubmitCreateScheme extends CreateSchemeEvent {
  final Map<String, dynamic> data;
  SubmitCreateScheme(this.data);

  @override
  List<Object?> get props => [data];
}

/// UPDATE event
class SubmitUpdateScheme extends CreateSchemeEvent {
  final String schemeId;
  final Map<String, dynamic> data;
  SubmitUpdateScheme(this.schemeId, this.data);

  @override
  List<Object?> get props => [schemeId, data];
}
