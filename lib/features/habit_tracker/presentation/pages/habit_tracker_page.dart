import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navigation_hub/presentation/widgets/navigation_hub_drawer.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/habit_card.dart';
import '../widgets/motivation_ticker.dart';
import '../widgets/add_habit_bottom_sheet.dart';
import '../../../../core/theme/aizen_theme.dart';

class HabitTrackerPage extends StatefulWidget {
  const HabitTrackerPage({super.key});

  @override
  State<HabitTrackerPage> createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  @override
  void initState() {
    super.initState();
    context.read<HabitBloc>().add(const LoadHabitsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final edgePadding = AizenBreakpoints.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AizenTheme.amoledBlack,
      drawer: const NavigationHubDrawer(),
      appBar: AppBar(
        backgroundColor: AizenTheme.amoledBlack,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AizenTheme.textPrimary, size: 20),
              onPressed: () {
                AizenHaptics.selection();
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            const Icon(
              Icons.track_changes,
              color: AizenTheme.primaryPurple,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'HABIT BUILDER',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AizenTheme.primaryPurple,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AizenTheme.shapeMd),
        ),
        onPressed: () {
          AizenHaptics.light();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (sheetContext) => BlocProvider.value(
              value: context.read<HabitBloc>(),
              child: AddHabitBottomSheet(
                onAdd: (title, isAutomatic) {
                  context.read<HabitBloc>().add(
                        AddHabitEvent(title: title, isAutomatic: isAutomatic),
                      );
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add, size: 24),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Motivation Quote Ticker
            Padding(
              padding: EdgeInsets.fromLTRB(edgePadding, 8, edgePadding, 8),
              child: const MotivationTicker(),
            ),

            // Habits List
            Expanded(
              child: BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state.status == HabitStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AizenTheme.primaryPurple,
                      ),
                    );
                  }

                  if (state.status == HabitStatus.failure) {
                    return Center(
                      child: Text(
                        'ERROR LOADING LEDGER:\n${state.errorMessage}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AizenTheme.accentRed,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final habits = state.habits;
                  if (habits.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.track_changes,
                            color: AizenTheme.textPrimary.withValues(alpha: 0.1),
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'NO STREAK TRACKERS ACTIVE',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AizenTheme.textSecondary,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the + button below to initiate a habit tracker.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AizenTheme.textTertiary,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: edgePadding, vertical: 8),
                    itemCount: habits.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return HabitCard(habit: habits[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
