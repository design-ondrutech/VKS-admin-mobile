abstract class SchemesEvent {}

class FetchSchemes extends SchemesEvent {}

class OpenAddSchemePopup extends SchemesEvent {}

class CloseAddSchemePopup extends SchemesEvent {}

class SubmitScheme extends SchemesEvent {
  final String schemeName;
  final String schemeType;
  final String durationType;
  final String duration;
  final String minAmount;

  SubmitScheme({
    required this.schemeName,
    required this.schemeType,
    required this.durationType,
    required this.duration,
    required this.minAmount,
  });
}

