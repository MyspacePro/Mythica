import 'package:mythica/features/reader/data/dummy_reader_data.dart';
import 'package:mythica/features/reader/widgets/reading_task_card.dart';
import 'package:flutter/material.dart';

class ReadingTaskSection extends StatelessWidget {
  final ValueChanged<ReadingTask> onTaskTap;

  const ReadingTaskSection({
    super.key,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    final tasks = DummyReaderData.readingTasks;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ReadingTaskCard(
          title: task.title,
          description: task.description,
          rewardCoins: task.rewardCoins,
          progress: task.isCompleted ? 1 : 0,
          isCompleted: task.isCompleted,
          onTap: () => onTaskTap(task),
        );
      },
    );
  }
}
