abstract class SchemesEvent {}

class FetchSchemes extends SchemesEvent {}

class OpenAddSchemePopup extends SchemesEvent {}

class CloseAddSchemePopup extends SchemesEvent {}

class SubmitScheme extends SchemesEvent {
  final String schemeName;
  final String duration;
  final String minAmount;
  final String maxAmount;

  SubmitScheme({
    required this.schemeName,
    required this.duration,
    required this.minAmount,
    required this.maxAmount,
  });
}
