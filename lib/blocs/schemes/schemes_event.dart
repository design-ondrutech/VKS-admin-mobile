import 'package:admin/data/models/scheme.dart';

abstract class SchemesEvent {}

class FetchSchemes extends SchemesEvent {}

class AddScheme extends SchemesEvent {
  final Scheme scheme;
  AddScheme(this.scheme);
}

class UpdateScheme extends SchemesEvent {
  final Scheme scheme;
  UpdateScheme(this.scheme);
}

class DeleteScheme extends SchemesEvent {
  final String schemeId;
  DeleteScheme(this.schemeId);
}
