import 'package:flutter/material.dart';
import 'bloc/judgment_bloc/judgment_bloc.dart';
import './bloc/judgment_bloc/judgment_event.dart';
import 'bloc/judgment_bloc/judgment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_screen.dart';

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
          }, icon: const Icon(Icons.notifications))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Home"),
          onTap: () {
          },
        ),
        ListTile(
          leading: Icon(Icons.chat),
          title: Text("ChatGPT"),
          onTap: () {
          },
        ),
          ],
        )
      ),
      body: Column(
        children: [
          JudgmentSearchBar(),
          Expanded(
            child: BlocBuilder<JudgmentBloc, JudgmentState>(
              builder: (context, state) {
                if (state is JudgmentInitial) {
                  return Center(child: Text('Please enter search criteria'));
                } 
                else if (state is JudgmentLoading) {
                  return Center(child: CircularProgressIndicator());
                } 
                else if (state is JudgmentsLoaded) {
                  final judgments = state.judgments; 
                  // or if your state returns a List<Map>, adjust accordingly

                  return ListView.builder(
                    itemCount: judgments.length,
                    itemBuilder: (context, index) {
                      final item = judgments[index];
                      return ListTile(
                        title: Text(item.snippet ?? 'No snippet'),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
                            children: [
                              Text('CaseNo: ${item.caseNo}'), // Case number at the top
                              SizedBox(height: 8), // Add some spacing between the text and the button
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    context.read<JudgmentBloc>().add(
                                      JudgmentAddFavoriteEvent(JudgmentID: item.judgmentID.toString()),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Judgment added to favorites!')),
                                  );
                                  } catch (e) {
                                    print('Error: $e');
                                  }
                                  
                                },
                                child: Text("Favorite"), // Button below the case number
                              ),
                            ],
                          ),
                      );
                    },
                  );
                } 
                else if (state is JudgmentError) {
                  return Center(child: Text('Error: ${state.error}'));
                } 
                else {
                  // Fallback if we get an unrecognized state
                  return Center(child: Text('Something else happened.'));
                }
              },
            ),
          ),
        ],
      ),
        );
      }
    }


class JudgmentSearchBar extends StatefulWidget {
  @override
  _JudgmentSearchBarState createState() => _JudgmentSearchBarState();
}

class _JudgmentSearchBarState extends State<JudgmentSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding for compact design
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search For Judgements',
              style: TextStyle(
                fontSize: 20, // Reduced font size for the title
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16), // Reduced spacing
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8, // Slightly smaller shadow
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Search Query Input
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search, size: 20), // Reduced icon size
                                hintText: 'Enter Your Query',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10), // Compact input
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          // Search Button
                          SizedBox(
                            width: constraints.maxWidth * 0.18, // Reduced button width
                            child: ElevatedButton(
                              onPressed: () {
                              final keyword = _searchController.text.trim();
                              if (keyword.isNotEmpty) {
                                // Trigger the bloc event
                                context.read<JudgmentBloc>().add(
                                  JudgmentKeywordSearchEvent(
                                    keyword: keyword,
                                    page: 1,   // or read from your filters
                                    limit: 10, // or read from your filters
                                  ),
                                );
                              }
                            },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 10), // Compact button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search, size: 16), // Smaller icon
                                  SizedBox(width: 4),
                                  Text(
                                    'Search',
                                    style: TextStyle(fontSize: 14), // Smaller text
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12), // Reduced spacing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dropdown Filters
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Compact dropdown
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Context', style: TextStyle(fontSize: 14)), // Smaller font
                              items: ['Option 1', 'Option 2', 'Option 3']
                                  .map((option) => DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option, style: TextStyle(fontSize: 14)), // Smaller font
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle context selection
                              },
                            ),
                          ),
                          SizedBox(width: 6), // Reduced spacing
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Compact dropdown
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Category', style: TextStyle(fontSize: 14)), // Smaller font
                              items: ['Category 1', 'Category 2', 'Category 3']
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category, style: TextStyle(fontSize: 14)), // Smaller font
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle category selection
                              },
                            ),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Compact dropdown
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Year', style: TextStyle(fontSize: 14)), // Smaller font
                              items: ['2020', '2021', '2022']
                                  .map((year) => DropdownMenuItem<String>(
                                        value: year,
                                        child: Text(year, style: TextStyle(fontSize: 14)), // Smaller font
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle year selection
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}