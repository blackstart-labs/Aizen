import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../navigation_hub/presentation/widgets/navigation_hub_drawer.dart';
import '../bloc/habit_bloc.dart';
import '../bloc/habit_event.dart';
import '../bloc/habit_state.dart';
import '../widgets/habit_card.dart';
import '../widgets/motivation_ticker.dart';
import '../widgets/add_habit_bottom_sheet.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: const NavigationHubDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 20),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Row(
          children: [
            Icon(
              Icons.track_changes,
              color: Color(0xFF7C4DFF),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'HABIT BUILDER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
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
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: MotivationTicker(),
            ),

            // Habits List
            Expanded(
              child: BlocBuilder<HabitBloc, HabitState>(
                builder: (context, state) {
                  if (state.status == HabitStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7C4DFF),
                      ),
                    );
                  }

                  if (state.status == HabitStatus.failure) {
                    return Center(
                      child: Text(
                        'ERROR LOADING LEDGER:\n${state.errorMessage}',
                        style: const TextStyle(color: Color(0xFFFF5252), fontSize: 11),
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
                            color: Colors.white.withValues(alpha: 0.1),
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'NO STREAK TRACKERS ACTIVE',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap the + button below to initiate a habit tracker.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
