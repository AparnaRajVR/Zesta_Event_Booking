
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:z_organizer/constant/color.dart';
import 'package:z_organizer/providers/revenue_provider.dart';
import 'package:z_organizer/providers/ticket_provider.dart';
import 'package:z_organizer/view/widget/revenue/empty_state.dart';
import 'package:z_organizer/view/widget/revenue/error_state.dart';
import 'package:z_organizer/view/widget/revenue/loading_state.dart';
import 'package:z_organizer/view/widget/revenue/revenue_appbar.dart';
import 'package:z_organizer/view/widget/revenue/revenue_card.dart';
import 'package:z_organizer/view/widget/revenue/summary_card.dart';

class RevenuePage extends ConsumerWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(ticketsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Revenue',style: TextStyle(color: AppColors.textlight,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: ticketsAsync.when(
        data: (tickets) {
          final revenueData = calculateRevenue(tickets);

          if (revenueData.isEmpty) {
            return const EmptyStateWidget();
          }

          // Calculate total revenue for summary card
          final totalRevenue = revenueData.fold<double>(
            0, (sum, data) => sum + data.totalRevenue);
          final totalTickets = revenueData.fold<int>(
            0, (sum, data) => sum + data.totalTicketsSold);

          return CustomScrollView(
            slivers: [
              // Summary Header
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: SummaryCard(
                    totalRevenue: totalRevenue,
                    totalTickets: totalTickets,
                    eventCount: revenueData.length,
                  ),
                ),
              ),
              
              // Revenue List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final data = revenueData[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutBack,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: RevenueCard(data: data, index: index),
                      );
                    },
                    childCount: revenueData.length,
                  ),
                ),
              ),
              
              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          );
        },
        loading: () => const LoadingStateWidget(),
        error: (e, st) => ErrorStateWidget(error: e.toString()),
      ),
    );
  }
}