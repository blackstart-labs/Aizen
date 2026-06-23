import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/inline_nlp_input.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_row.dart';
import '../../../navigation_hub/presentation/widgets/navigation_hub_drawer.dart';
import '../../../../core/theme/aizen_theme.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(const LoadTodosEvent());
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
        title: Text(
          'Quick Tasks',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: edgePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const InlineNlpInput(),
              const SizedBox(height: 8),
              const FilterBar(),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    if (state.status == TodoStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AizenTheme.primaryPurple,
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state.status == TodoStatus.failure) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'Failed to load tasks.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AizenTheme.textTertiary,
                              ),
                        ),
                      );
                    } else if (state.tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.playlist_add_check,
                              color: AizenTheme.textPrimary.withValues(alpha: 0.1),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'All clear. Enjoy your day!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AizenTheme.textTertiary,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.tasks.length,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return TaskRow(task: task);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
