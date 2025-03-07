import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

// API Model
class AssignToOtherModel {
  String rowCountHtml;
  String html;
  int totalPage;
  int response;
  int stutusDataAllow;
  int stutus;
  String message;
  int rowcount;
  List<Map<String, String?>> tooltipId;
  int totalMembersCount;

  AssignToOtherModel({
    required this.rowCountHtml,
    required this.html,
    required this.totalPage,
    required this.response,
    required this.stutusDataAllow,
    required this.stutus,
    required this.message,
    required this.rowcount,
    required this.tooltipId,
    required this.totalMembersCount,
  });

  factory AssignToOtherModel.fromJson(Map<String, dynamic> json) {
    // Ensure tooltip_id is parsed as a List<Map<String, String?>>
    List<Map<String, String?>> tooltipId = [];
    if (json["tooltip_id"] is List) {
      tooltipId = List<Map<String, String?>>.from(
        json["tooltip_id"].map((x) => Map<String, String?>.from(x)),
      );
    }

    return AssignToOtherModel(
      rowCountHtml: json["row_count_html"],
      html: json["html"],
      totalPage: json["total_page"],
      response: json["response"],
      stutusDataAllow: json["stutus_data_allow"],
      stutus: json["stutus"],
      message: json["Message"],
      rowcount: json["rowcount"],
      tooltipId: tooltipId,
      totalMembersCount: json["total_members_count"],
    );
  }
}

// Data Provider Class
class InquiryProvider with ChangeNotifier {
  List<Map<String, String?>> _inquiries = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;

  List<Map<String, String?>> get inquiries => _inquiries;
  bool get isLoading => _isLoading;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> fetchInquiries(int pageNumber, int datastages) async {
    _isLoading = true;
    notifyListeners();

    String? token = await _secureStorage.read(key: 'token');
    const String apiUrl = "https://admin.dev.ajasys.com/api/show_list_Dismiss_allinquiry";

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?pageNumber=$pageNumber'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": token,
          "follow_up_day": "assign_to_other",
          "datastages": datastages, // Pass the datastages parameter
        }),
      );

      if (response.statusCode == 200) {
        final data = AssignToOtherModel.fromJson(jsonDecode(response.body));
        _inquiries = data.tooltipId;
        _totalPages = data.totalPage;
        _currentPage = pageNumber;
      }
    } catch (e) {
      print('Error fetching inquiries: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}

// Custom Card Widget
class InquiryCard extends StatefulWidget {
  final Map<String, String?> inquiry;
  final bool isSelected;
  final VoidCallback onSelect;

  const InquiryCard({
    required this.inquiry,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  _InquiryCardState createState() => _InquiryCardState();
}

class _InquiryCardState extends State<InquiryCard> {
  Color getLabelColor(String label) {
    // Implement your color logic based on label
    return Colors.green;
  }

  Color getBorderColor(String label) {
    // Implement your border color logic
    return Colors.green.shade800;
  }

  Widget _buildSourceContainer(String? source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        source ?? 'Unknown',
        style: const TextStyle(fontFamily: "poppins_thin", fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onSelect,
      child: Card(
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: widget.isSelected ? 14.0 : 4.0,
        color: widget.isSelected ? Colors.deepPurple.shade100 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                      child: Text(
                        widget.inquiry['id'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: "poppins_thin",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.inquiry['full_name'] ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 15),
                            Text(
                              ": ${widget.inquiry['assign_id'] ?? ''}",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: getLabelColor(widget.inquiry['inquiry_stage'] ?? ''),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1.0,
                        color: getBorderColor(widget.inquiry['inquiry_stage'] ?? ''),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.inquiry['inquiry_stage'] ?? '',
                        style: const TextStyle(
                          fontFamily: "poppins_thin",
                          color: Colors.black,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xffebf0f4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        "Inq Type: ${widget.inquiry['inquiry_type'] ?? ''}",
                        style: const TextStyle(
                          fontFamily: "poppins_thin",
                          color: Colors.black,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Next Follow-up: ${widget.inquiry['next_followup_date'] ?? ''}",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: "poppins_thin",
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  const Text("Source: ", style: TextStyle(fontFamily: "poppins_thin", fontSize: 12)),
                  _buildSourceContainer(widget.inquiry['inquiry_source_type']),
                  const SizedBox(width: 7),
                  Image.asset("asset/Inquiry_module/calendar.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text(widget.inquiry['day_skip'] ?? "0"),
                  const SizedBox(width: 10),
                  Image.asset("asset/Inquiry_module/clock.png", height: 18, width: 18),
                  const SizedBox(width: 3),
                  Text(widget.inquiry['hour_skip'] ?? "0"),
                ],
              ),
              if (widget.isSelected)
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: widget.isSelected,
                    onChanged: (bool? value) {
                      widget.onSelect();
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

// Main Screen
class InquiryListScreen extends StatefulWidget {
  final int datastages;

  const InquiryListScreen({required this.datastages});

  @override
  _InquiryListScreenState createState() => _InquiryListScreenState();
}

class _InquiryListScreenState extends State<InquiryListScreen> {
  final ScrollController _scrollController = ScrollController();
  late InquiryProvider _inquiryProvider;
  List<bool> selectedCards = [];

  @override
  void initState() {
    super.initState();
    _inquiryProvider = InquiryProvider();
    _inquiryProvider.fetchInquiries(1, widget.datastages); // Pass datastages here
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        _inquiryProvider._currentPage < _inquiryProvider._totalPages) {
      _inquiryProvider.fetchInquiries(_inquiryProvider._currentPage + 1, widget.datastages); // Pass datastages here
    }
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedCards.length <= index) {
        selectedCards.addAll(List.filled(index - selectedCards.length + 1, false));
      }
      selectedCards[index] = !selectedCards[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inquiries')),
      body: ListenableBuilder(
        listenable: _inquiryProvider,
        builder: (context, child) {
          return ListView.builder(
            controller: _scrollController,
            itemCount: _inquiryProvider.inquiries.length + (_inquiryProvider.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _inquiryProvider.inquiries.length) {
                return InquiryCard(
                  inquiry: _inquiryProvider.inquiries[index],
                  isSelected: index < selectedCards.length ? selectedCards[index] : false,
                  onSelect: () => toggleSelection(index),
                );
              } else {
                return _inquiryProvider.isLoading
                    ? Center(
                  child: Lottie.asset(
                    'asset/loader.json',
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                  ),
                )
                    : const SizedBox();
              }
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}