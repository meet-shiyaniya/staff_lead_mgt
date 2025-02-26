import 'package:flutter/material.dart';

class inquiryFilterScreen extends StatefulWidget {
  const inquiryFilterScreen({super.key});

  @override
  State<inquiryFilterScreen> createState() => _inquiryFilterScreenState();
}

class _inquiryFilterScreenState extends State<inquiryFilterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFullScreenModal();
    });
  }

  void _showFullScreenModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(
                  "Filters",
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: "poppins_thin"),
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField("Id"),
                      _buildTextField("Enter Name"),
                      _buildTextField("Mobile No"),
                      _buildTextField("Next Follow Up"),
                      _buildDropdownField("Inquiry Stages", ["Live", "Pending", "Closed"]),
                      _buildDropdownField("Assign To", ["User 1", "User 2", "User 3"]),
                      _buildDropdownField("Owner To", ["Owner 1", "Owner 2"]),
                      _buildDropdownField("Inq Type", ["Type 1", "Type 2"]),
                      _buildDropdownField("Inquiry Source Type", ["Source 1", "Source 2"]),
                      _buildDropdownField("Inquiry Source", ["Source A", "Source B"]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, List<String> items) {
    String? selectedValue;
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (String? value) {
          selectedValue = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(title: Text("Inquiry Filter")),
      body: Center(child: Text("Main Screen Content")),
    );
  }
}