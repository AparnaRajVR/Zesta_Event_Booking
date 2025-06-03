

import 'package:z_organizer/model/ticket_model.dart';

class RevenueData {
  final String eventId;
  final String eventName;
  final int totalTicketsSold;
  final double totalRevenue;

  RevenueData({
    required this.eventId,
    required this.eventName,
    required this.totalTicketsSold,
    required this.totalRevenue,
  });
}

List<RevenueData> calculateRevenue(List<Ticket> tickets) {
  final Map<String, RevenueData> grouped = {};

  for (var ticket in tickets) {
    if (!grouped.containsKey(ticket.eventId)) {
      grouped[ticket.eventId] = RevenueData(
        eventId: ticket.eventId,
        eventName: ticket.eventName,
        totalTicketsSold: 0,
        totalRevenue: 0.0,
      );
    }
    grouped[ticket.eventId] = RevenueData(
      eventId: ticket.eventId,
      eventName: ticket.eventName,
      totalTicketsSold: grouped[ticket.eventId]!.totalTicketsSold + ticket.ticketCount,
      totalRevenue: grouped[ticket.eventId]!.totalRevenue + ticket.amountPaid,
    );
  }

  return grouped.values.toList();
}
