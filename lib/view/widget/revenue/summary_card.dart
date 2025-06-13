import 'package:flutter/material.dart';
import 'package:z_organizer/view/widget/revenue/summary_item.dart';

class SummaryCard extends StatelessWidget {
  final double totalRevenue;
  final int totalTickets;
  final int eventCount;

  const SummaryCard({
    super.key,
    required this.totalRevenue,
    required this.totalTickets,
    required this.eventCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Total Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SummaryItem(
                  value: '₹${totalRevenue.toStringAsFixed(2)}',
                  label: 'Total Revenue',
                  icon: Icons.currency_rupee,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: SummaryItem(
                  value: totalTickets.toString(),
                  label: 'Tickets Sold',
                  icon: Icons.confirmation_number_outlined,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: SummaryItem(
                  value: eventCount.toString(),
                  label: 'Events',
                  icon: Icons.event_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
