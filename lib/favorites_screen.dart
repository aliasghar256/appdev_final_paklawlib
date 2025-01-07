import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/judgment_bloc/judgment_bloc.dart';
import '../bloc/judgment_bloc/judgment_event.dart';
import '../bloc/judgment_bloc/judgment_state.dart';
import '../models/judgment_model.dart';
import 'view_judgment_page.dart';

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
                color: Colors.white,
  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
  elevation: 4, // Adds shadow to the card
  child: Padding(
    padding: const EdgeInsets.all(16.0), // Inner padding for a cleaner layout
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title (Party 1)
        Text(
          judgment.party1,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),

        // Case Details
        Text(
          'Case No: ${judgment.caseNo}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          'Year: ${judgment.caseYear}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),

        // Action Buttons (View Judgment and Delete)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewJudgmentPage(
                      judgmentId: judgment.judgmentID.toString(),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.visibility),
              label: Text("View Judgment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF002855),
                foregroundColor: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<JudgmentBloc>().add(
                  JudgmentDeleteFavoriteEvent(
                      JudgmentID: judgment.judgmentID.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deleting favorite...')),
                );
              },
            ),
          ],
        ),
      ],
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
