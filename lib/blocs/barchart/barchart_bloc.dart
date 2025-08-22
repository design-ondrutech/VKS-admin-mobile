// import 'package:admin/blocs/barchart/barchart_event.dart';
// import 'package:admin/blocs/barchart/barchart_state.dart';
// import 'package:admin/data/repo/auth_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ChartBloc extends Bloc<ChartEvent, ChartState> {
//   final DashboardRepository repository;

//   ChartBloc(this.repository) : super(ChartState()) {
//     on<FetchGoldDashboard>((event, emit) async {
//       emit(state.copyWith(loading: true));

//       try {
//        // final data = await repository.fetchGoldDashboard();
//         final schemeSummary = data["scheme_monthly_summary"] as List;

//         // Separate by scheme_name
//         List<double> goldEleven = [];
//         List<double> digitalGold = [];
//         List<String> months = [];

//         for (var entry in schemeSummary) {
//           final month = entry["month"];
//           final scheme = entry["scheme_name"];
//           final total = (entry["total_gold_bought"] as num).toDouble();

//           if (!months.contains(month)) {
//             months.add(month);
//           }

//           if (scheme == "Gold Eleven") {
//             goldEleven.add(total);
//           } else if (scheme == "Digital Gold") {
//             digitalGold.add(total);
//           }
//         }

//         emit(state.copyWith(
//           goldEleven: goldEleven,
//           digitalGold: digitalGold,
//           months: months,
//           loading: false,
//         ));
//       } catch (e) {
//         emit(state.copyWith(error: e.toString(), loading: false));
//       }
//     });
//   }
// }
