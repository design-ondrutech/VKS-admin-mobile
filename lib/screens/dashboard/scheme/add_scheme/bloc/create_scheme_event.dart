import 'package:equatable/equatable.dart';

abstract class CreateSchemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitCreateScheme extends CreateSchemeEvent {
  final Map<String, dynamic> data;
  SubmitCreateScheme(this.data);

  @override
  List<Object?> get props => [data];
}
