import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/judgment_bloc/judgment_bloc.dart';
import 'bloc/judgment_bloc/judgment_state.dart';
import 'bloc/judgment_bloc/judgment_event.dart';
import '../../models/judgment_model.dart';

class ViewJudgmentPage extends StatelessWidget {
  final String judgmentId;

  const ViewJudgmentPage({Key? key, required this.judgmentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // As soon as this screen is built, dispatch the event to load the judgment
    context.read<JudgmentBloc>().add(JudgmentViewEvent(id: judgmentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Judgment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<JudgmentBloc, JudgmentState>(
        builder: (context, state) {
          if (state is JudgmentLoading) {
            // 1. Loading state
            return const Center(child: CircularProgressIndicator());
          } else if (state is JudgmentError) {
            // 2. Error state
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is JudgmentViewLoaded) {
            // 3. Judgment data is loaded
            final Judgment judgment = state.judgment;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Case No: ${judgment.caseNo}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Judgment ID: ${judgment.judgmentID}'),
                  Text('Case Year: ${judgment.caseYear}'),
                  Text('Party 1: ${judgment.party1}'),
                  Text('Party 2: ${judgment.party2}'),
                  Text('Judge ID: ${judgment.judgeID}'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Display the full judgment text
                  Text(
                    judgment.JudgmentText,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // If indexes are present
                  Text(
                    'Indexes: ${judgment.indexes.isNotEmpty ? judgment.indexes.join(", ") : "No indexes"}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            );
          }
          // 4. Initial or any other unhandled state
          return const Center(child: Text('No judgment loaded yet.'));
        },
      ),
    );
  }
}
