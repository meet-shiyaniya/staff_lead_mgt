import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/category_Model.dart';

class ListSelectionScreen extends StatefulWidget {
  final int? initialSelectedIndex;
  final List<CategoryModel> optionList;

  ListSelectionScreen({
    this.initialSelectedIndex,
    required this.optionList,
  });

  @override
  _ListSelectionScreenState createState() => _ListSelectionScreenState();
}

class _ListSelectionScreenState extends State<ListSelectionScreen> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Choose Stage",
          style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.optionList.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: isSelected ? 6 : 4,
              color: isSelected ? Colors.deepPurple.shade100 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: ListTile(
                title: Text(
                  widget.optionList[index].title,
                  style: TextStyle(
                    color: isSelected ? Colors.deepPurple : Colors.black,
                    fontFamily: isSelected ? "poppins_thin" : "poppins_light",
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Colors.deepPurple.shade300
                      : Colors.grey.shade200,
                  child: Text(
                    widget.optionList[index].title[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group,
                      color: isSelected ? Colors.deepPurple : Colors.black,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      widget.optionList[index].leadCount.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.deepPurple : Colors.black,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  Navigator.pop(context, {
                    "selectedIndex": selectedIndex,
                    "selectedCategory": widget.optionList[index],
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
