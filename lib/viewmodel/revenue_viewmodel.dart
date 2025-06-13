// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final revenueViewModelProvider = StateNotifierProvider<RevenueViewModel, AsyncValue<List<RevenueData>>>(
//   // (ref) => RevenueViewModel(ref)
// );

// class RevenueViewModel extends StateNotifier<AsyncValue<List<RevenueData>>> {
//   final Ref ref;

//   RevenueViewModel(this.ref) : super(const AsyncValue.loading()) {
//     fetchRevenueData();
//   }

//   Future<void> fetchRevenueData() async {
//     try {
//       // Fetch tickets from the existing provider
//       final tickets = await ref.read(ticketsProvider.future);
//       final revenueData = calculateRevenue(tickets); // Move this logic here
//       state = AsyncValue.data(revenueData);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   List<RevenueData> calculateRevenue(List<Ticket> tickets) {
//     // Implement your revenue calculation logic here
//     // Return a list of RevenueData
//   }
// }
