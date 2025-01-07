import 'package:finalproject/favorites_screen.dart';
import 'package:finalproject/templates_screen.dart';
import 'package:flutter/material.dart';
import 'bloc/judgment_bloc/judgment_bloc.dart';
import './bloc/judgment_bloc/judgment_event.dart';
import 'bloc/judgment_bloc/judgment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_screen.dart';
import 'view_judgment_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Tracks the selected tab

  // Pages for each tab
  final List<Widget> _pages = [
    HomeContent(), // Main home content
    FavoritesScreen(), // Favorites screen
    TemplatesScreen(), // Templates screen
  ];

  // Handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        context.read<JudgmentBloc>().add(ReturnToHomePageEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            icon: const Icon(Icons.notifications),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text("ChatGPT"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Templates',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped, // Handle tab changes
      ),
    );
  }
}

// Placeholder for Home content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        JudgmentSearchBar(),
        Expanded(
          child: BlocBuilder<JudgmentBloc, JudgmentState>(
            builder: (context, state) {
              if (state is JudgmentInitial) {
                return Center(child: Text('Please enter search criteria'));
              } else if (state is JudgmentLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is JudgmentsLoaded) {
                final judgments = state.judgments;

                return ListView.builder(
                  itemCount: judgments.length,
                  itemBuilder: (context, index) {
                    final item = judgments[index];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judgment Title
                            Text(
                              '${item.party1} vs ${item.party2}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item.snippet ?? 'No snippet available',
                              style: TextStyle(
                                fontSize: 16, // Smaller font size
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              maxLines: 4, // Limit to 2 lines
                              overflow: TextOverflow.ellipsis, // Add ellipses (...) for overflow
                            ),
                            // Case Details (Party1 vs Party2, CaseNo, and Year)
                            
                            SizedBox(height: 4),
                            Text(
                              'Case No: ${item.caseNo}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            Text(
                              'Year: ${item.caseYear}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 12),

                            // Action Buttons (Favorite and View Judgment)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      context.read<JudgmentBloc>().add(
                                            JudgmentAddFavoriteEvent(
                                              JudgmentID: item.judgmentID.toString(),
                                            ),
                                          );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Judgment added to favorites!'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    } catch (e) {
                                      print('Error: $e');
                                    }
                                  },
                                  icon: Icon(Icons.favorite),
                                  label: Text("Favorite"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400],
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewJudgmentPage(judgmentId: item.judgmentID.toString()),
                                        settings: RouteSettings(arguments: 'home'), // Passing 'home' as the previous page
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                );
              } else if (state is JudgmentError) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return Center(child: Text('Something else happened.'));
              }
            },
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search For Judgements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Search Bar Row
                    Row(
                      children: [
                        // Search Query Input
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, size: 20),
                              hintText: 'Enter Your Query',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // Search Button
                        ElevatedButton(
                          onPressed: () {
                            final keyword = _searchController.text.trim();
                            if (keyword.isNotEmpty) {
                              context.read<JudgmentBloc>().add(
                                JudgmentKeywordSearchEvent(
                                  keyword: keyword,
                                  page: 1,
                                  limit: 10,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Filters Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Context Dropdown
                          Container(
                            width: constraints.maxWidth / 3 - 12, // Ensures dropdowns fit within width
                            margin: EdgeInsets.only(right: 6),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Context', style: TextStyle(fontSize: 13)),
                              items: ['Option 1', 'Option 2', 'Option 3']
                                  .map((option) => DropdownMenuItem<String>(
                                        value: option,
                                        child: Text(option, style: TextStyle(fontSize: 14)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle context selection
                              },
                            ),
                          ),
                          // Category Dropdown
                          Container(
                            width: constraints.maxWidth / 3 - 12,
                            margin: EdgeInsets.only(right: 6),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Category', style: TextStyle(fontSize: 12)),
                              items: ['Category 1', 'Category 2', 'Category 3']
                                  .map((category) => DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category, style: TextStyle(fontSize: 12)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle category selection
                              },
                            ),
                          ),
                          // Year Dropdown
                          Container(
                            width: constraints.maxWidth / 3 - 12,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              hint: Text('Year', style: TextStyle(fontSize: 14)),
                              items: ['2020', '2021', '2022']
                                  .map((year) => DropdownMenuItem<String>(
                                        value: year,
                                        child: Text(year, style: TextStyle(fontSize: 14)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                // Handle year selection
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
