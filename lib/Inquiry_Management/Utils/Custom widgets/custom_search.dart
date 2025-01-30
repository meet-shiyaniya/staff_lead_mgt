import 'package:flutter/material.dart';

import '../../Model/followup_Model.dart';
// import 'package:inquiry_management_ui/Model/followup_Model.dart';

class SearchBar1 extends StatefulWidget {
  final List<LeadModel> items; // List of LeadModel items
  final Function(List<LeadModel>) onSearch; // Callback function for search results

  SearchBar1({required this.items, required this.onSearch});

  @override
  _SearchBar1State createState() => _SearchBar1State();
}

class _SearchBar1State extends State<SearchBar1> {
  bool _isExpanded = false;
  TextEditingController _controller = TextEditingController();
  List<LeadModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items); // Initialize with all items
  }
  void _filterSearchResults(String query) {
    List<LeadModel> results = [];

    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();

      results = widget.items.where((lead) {
        final nameMatch = lead.name.toLowerCase().contains(lowerQuery);
        final numberMatch = lead.phone.toLowerCase().contains(lowerQuery);
        final usernameMatch = lead.username.toLowerCase().contains(lowerQuery);

        if (nameMatch || numberMatch || usernameMatch) {
          print("Matched: ${lead.name}, ${lead.phone}, ${lead.username}");
        }

        return nameMatch || numberMatch || usernameMatch;
      }).toList();
    } else {
      results = List.from(widget.items);
    }

    setState(() {
      _filteredItems = results;
    });

    widget.onSearch(_filteredItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _isExpanded ? 250.0 : 50.0, // Expands when pressed
                height: 40.0,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (_isExpanded) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _controller,
                            onChanged: _filterSearchResults, // Call search function
                            decoration: InputDecoration(
                              hintText: 'Search by Name, Number, or Username...',
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ],
                    IconButton(
                      icon: Icon(_isExpanded ? Icons.clear : Icons.search),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                          if (!_isExpanded) {
                            _controller.clear(); // Clear search text when collapsed
                            _filterSearchResults(""); // Reset list
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
