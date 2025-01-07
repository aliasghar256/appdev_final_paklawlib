import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/judgment_bloc/judgment_bloc.dart';
import '../bloc/judgment_bloc/judgment_event.dart';
import '../bloc/judgment_bloc/judgment_state.dart';
import '../models/judgment_model.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger the event to load favorites when the screen is first built
    context.read<JudgmentBloc>().add(JudgmentFetchAllFavoritesEvent());

    return BlocBuilder<JudgmentBloc, JudgmentState>(
      builder: (context, state) {
        if (state is JudgmentFavoritesLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is JudgmentFavoritesLoaded) {
          final favorites = state.judgments;

          if (favorites.isEmpty) {
            return Center(child: Text('No favorites found.'));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final judgment = favorites[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(
                    judgment.party1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text('Case No: ${judgment.caseNo}'),
                      Text('Year: ${judgment.caseYear}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Handle removing the favorite
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Remove functionality not implemented yet!')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else if (state is JudgmentFavoritesError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text('No data to display.'));
        }
      },
    );
  }
}
