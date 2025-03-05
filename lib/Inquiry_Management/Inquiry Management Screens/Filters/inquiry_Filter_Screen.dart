import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../Provider/UserProvider.dart';

// import '../../Provider/UserProvider.dart';

// Model for filtered inquiries
class AllInquiryFilter {
  int status;
  String message;
  Pagination pagination;
  List<Map<String, String>> inquiries;

  AllInquiryFilter({
    required this.status,
    required this.message,
    required this.pagination,
    required this.inquiries,
  });

  factory AllInquiryFilter.fromJson(Map<String, dynamic> json) => AllInquiryFilter(
    status: json["status"],
    message: json["message"],
    pagination: Pagination.fromJson(json["pagination"]),
    inquiries: List<Map<String, String>>.from(
        json["inquiries"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String>(k, v.toString())))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "pagination": pagination.toJson(),
    "inquiries": List<dynamic>.from(inquiries.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}

class Pagination {
  int currentPage;
  int totalPages;
  int totalRecords;
  int perPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
    totalRecords: json["total_records"],
    perPage: json["per_page"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "total_pages": totalPages,
    "total_records": totalRecords,
    "per_page": perPage,
  };
}

// API Service for filtering inquiries
class FilterApiService {
  static const String baseUrl = 'https://admin.dev.ajasys.com/api';
  final _secureStorage = const FlutterSecureStorage();

  Future<AllInquiryFilter> filterInquiries(Map<String, dynamic> filters) async {
    try {
      String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/filter_allinquiry'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          ...filters,
        }),
      );

      if (response.statusCode == 200) {
        return AllInquiryFilter.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to filter inquiries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering inquiries: $e');
    }
  }
}

class InquiryFilterScreen extends StatefulWidget {
  const InquiryFilterScreen({super.key});

  @override
  State<InquiryFilterScreen> createState() => _InquiryFilterScreenState();
}

class _InquiryFilterScreenState extends State<InquiryFilterScreen> {
  List<Map<String, String>> _allInquiries = [];
  bool _isFiltering = false;
  String? _filterError;
  Pagination? _pagination;
  Map<String, dynamic> _lastFilters = {};
  final ScrollController _scrollController = ScrollController();
  bool _hasShownBottomSheet = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasShownBottomSheet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<UserProvider>(context, listen: false).fetchFilterData();
        _showInquiryBottomSheet(context);
      });
      _hasShownBottomSheet = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showInquiryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.9,
        maxChildSize: 0.9,
        builder: (context, scrollController) => InquiryBottomSheet(
          onFilterApplied: (result, filters) {
            Navigator.pop(context);
            setState(() {
              _allInquiries = result.inquiries;
              _pagination = result.pagination;
              _lastFilters = filters;
              _filterError = null;
            });
          },
          onFilterError: (error) {
            setState(() {
              _filterError = error;
            });
          },
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _loadNextPage() async {
    if (_pagination == null || _pagination!.currentPage >= _pagination!.totalPages) {
      return;
    }

    setState(() {
      _isFiltering = true;
    });

    try {
      final filters = {
        ..._lastFilters,
        'page': _pagination!.currentPage + 1,
      };
      final result = await FilterApiService().filterInquiries(filters);
      setState(() {
        _allInquiries.addAll(result.inquiries);
        _pagination = result.pagination;
        _isFiltering = false;
      });
    } catch (e) {
      setState(() {
        _filterError = e.toString();
        _isFiltering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Inquiry Filter",
          style: TextStyle(
            fontFamily: "poppins_thin",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _filterError = null;
                _allInquiries.clear();
                _pagination = null;
              });
              Provider.of<UserProvider>(context, listen: false).fetchFilterData();
              _showInquiryBottomSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            if (_filterError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _filterError!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontFamily: "poppins_thin",
                  ),
                ),
              ),
            if (_allInquiries.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "Apply filters to see inquiries",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontFamily: "poppins_thin",
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Inquiries Found', //${_allInquiries.length}
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          fontFamily: "poppins_thin",
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _allInquiries.length + (_isFiltering ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _allInquiries.length) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final inquiry = _allInquiries[index];
                          return InquiryCard(
                            id: inquiry['id'] ?? 'N/A',
                            name: inquiry['full_name'] ?? 'N/A',
                            username: inquiry['assign_id'] ?? 'N/A',
                            label: inquiry['mobileno'] ?? 'N/A',
                            inquiryType: inquiry['inquiry_type'] ?? 'N/A',
                            intArea: inquiry['intrested_area'] ?? 'N/A',
                            purposeBuy: inquiry['purpose_buy'] ?? 'N/A',
                            followUpDate: inquiry['nxt_follow_up'] ?? 'N/A',
                            nextFollowUpDate: inquiry['next_follow_up'] ?? 'N/A',
                            daySkip: inquiry['day_skip'] ?? '0',
                            hourSkip: inquiry['hour_skip'] ?? '0',
                            isSelected: false,
                            onSelect: () {},
                            context: context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InquiryCard extends StatelessWidget {
  final String id;
  final String name;
  final String username;
  final String label;
  final String inquiryType;
  final String intArea;
  final String purposeBuy;
  final String followUpDate;
  final String nextFollowUpDate;
  final String daySkip;
  final String hourSkip;
  final bool isSelected;
  final VoidCallback onSelect;
  final BuildContext context;

  const InquiryCard({
    Key? key,
    required this.id,
    required this.name,
    required this.username,
    required this.label,
    required this.inquiryType,
    required this.intArea,
    required this.purposeBuy,
    required this.followUpDate,
    required this.nextFollowUpDate,
    required this.daySkip,
    required this.hourSkip,
    required this.isSelected,
    required this.onSelect,
    required this.context,
  }) : super(key: key);

  Widget _buildTag(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "poppins_thin",
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTag(
                    id,
                    Colors.deepPurple.shade500,
                    Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: "poppins_thin",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              username,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          "asset/Inquiry_module/call-forwarding.png",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => InquiryScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          "asset/Inquiry_module/map.png",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddVisitScreen(inquiryId: id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                          "asset/Inquiry_module/rupee.png",
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(inquiryId: id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  _buildTag(
                    label,
                    Colors.grey.shade200,
                    Colors.black87,
                  ),
                  _buildTag(
                    "Type: $inquiryType",
                    Colors.deepPurple.shade50,
                    Colors.deepPurple.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Next Follow-up: $nextFollowUpDate",
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "poppins_thin",
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "asset/Inquiry_module/calendar.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        daySkip.isNotEmpty ? daySkip : "0",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins_thin",
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.asset(
                        "asset/Inquiry_module/clock.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hourSkip.isNotEmpty ? hourSkip : "0",
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins_thin",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isSelected)
                Align(
                  alignment: Alignment.centerRight,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      onSelect();
                    },
                    activeColor: Colors.deepPurple,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class InquiryBottomSheet extends StatefulWidget {
  final Function(AllInquiryFilter, Map<String, dynamic>) onFilterApplied;
  final Function(String) onFilterError;

  const InquiryBottomSheet({
    super.key,
    required this.onFilterApplied,
    required this.onFilterError,
  });

  @override
  _InquiryBottomSheetState createState() => _InquiryBottomSheetState();
}

class _InquiryBottomSheetState extends State<InquiryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _selectedInquiryStages = [];
  String? _selectedAssignTo;
  String? _selectedOwnerTo;
  String? _selectedInquiryType;
  String? _selectedInquirySourceType;
  String? _selectedInquirySource;
  String? _selectedInterestedArea;
  String? _selectedPropertySubType;
  String? _selectedPropertyType;
  String? _selectedInterestedSite;
  String? _selectedPropertyConfiguration;

  bool _isFiltering = false;
  final FilterApiService _filterApiService = FilterApiService();

  Future<void> _applyFilters() async {
    setState(() {
      _isFiltering = true;
    });

    Map<String, dynamic> filters = {'page': 1};

    if (_idController.text.isNotEmpty) {
      filters['id'] = _idController.text;
    }
    if (_nameController.text.isNotEmpty) {
      filters['name'] = _nameController.text;
    }
    if (_mobileController.text.isNotEmpty) {
      filters['mobile_no'] = _mobileController.text;
    }
    if (_selectedDate != null) {
      filters['next_follow_up'] =
      '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}';
    }
    if (_selectedInquiryStages.isNotEmpty) {
      filters['inquiry_stages'] = _selectedInquiryStages.join(',');
    }
    if (_selectedAssignTo != null) {
      filters['assign_to'] = _selectedAssignTo;
    }
    if (_selectedOwnerTo != null) {
      filters['owner_to'] = _selectedOwnerTo;
    }
    if (_selectedInquiryType != null) {
      filters['inquiry_type'] = _selectedInquiryType;
    }
    if (_selectedInquirySourceType != null) {
      filters['inquiry_source_type'] = _selectedInquirySourceType;
    }
    if (_selectedInquirySource != null) {
      filters['inquiry_source'] = _selectedInquirySource;
    }
    if (_selectedInterestedArea != null) {
      filters['interested_area'] = _selectedInterestedArea;
    }
    if (_selectedPropertySubType != null) {
      filters['project_sub_type'] = _selectedPropertySubType;
    }
    if (_selectedPropertyType != null) {
      filters['project_type'] = _selectedPropertyType;
    }
    if (_selectedInterestedSite != null) {
      filters['IntSite'] = _selectedInterestedSite;
    }
    if (_selectedPropertyConfiguration != null) {
      filters['PropertyConfiguration'] = _selectedPropertyConfiguration;
    }

    try {
      print("Applying filters: $filters");
      final result = await _filterApiService.filterInquiries(filters);
      print("API Response: ${result.toJson()}");
      widget.onFilterApplied(result, filters);
    } catch (e) {
      print("Error applying filters: $e");
      widget.onFilterError(e.toString());
    } finally {
      setState(() {
        _isFiltering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        final filterData = provider.filterData;
        if (filterData == null) {
          return const Center(child: Text('No filter data available'));
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.grey[100],
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _idController,
                                  decoration: _buildInputDecoration('ID'),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: _buildInputDecoration('ENTER NAME'),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.phone,
                                  decoration: _buildInputDecoration('MOBILE NO'),
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2026),
                                    );
                                    if (date != null) {
                                      setState(() => _selectedDate = date);
                                    }
                                  },
                                  child: InputDecorator(
                                    decoration: _buildInputDecoration('NEXT FOLLOW UP'),
                                    child: Text(
                                      _selectedDate == null
                                          ? 'NEXT FOLLOW UP'
                                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                      style: TextStyle(
                                        color: _selectedDate == null ? Colors.grey[400] : Colors.black,
                                        fontSize: 14,
                                        fontFamily: "poppins_thin",
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                MultiSelectDropdownTextField(
                                  options: filterData.inquiryStages.map((e) => e.inquiryStages ?? '').toList(),
                                  selectedOptions: _selectedInquiryStages,
                                  onSelectionChanged: (selected) {
                                    setState(() {
                                      _selectedInquiryStages = selected;
                                    });
                                  },
                                  hintText: 'INQUIRY STAGES (LIVE)',
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.assignTo.map((e) => e.firstname ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedAssignTo = value;
                                    });
                                  },
                                  hintText: 'ASSIGN TO',
                                  selectedValue: _selectedAssignTo,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.ownerTo.map((e) => e.firstname ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedOwnerTo = value;
                                    });
                                  },
                                  hintText: 'OWNER TO',
                                  selectedValue: _selectedOwnerTo,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.inquiryDetails.map((e) => e.inquiryDetails ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedInquiryType = value;
                                    });
                                  },
                                  hintText: 'INQ TYPE',
                                  selectedValue: _selectedInquiryType,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.inquirySourceType.map((e) => e.inquirySourceType ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedInquirySourceType = value;
                                    });
                                  },
                                  hintText: 'INQUIRY SOURCE TYPE',
                                  selectedValue: _selectedInquirySourceType,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.inquirySource.map((e) => e.source ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedInquirySource = value;
                                    });
                                  },
                                  hintText: 'INQUIRY SOURCE',
                                  selectedValue: _selectedInquirySource,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.inquirySource.map((e) => e.source ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedInterestedArea = value;
                                    });
                                  },
                                  hintText: 'INT AREA',
                                  selectedValue: _selectedInterestedArea,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.projectSubType.map((e) => e.projectSubType ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedPropertySubType = value;
                                    });
                                  },
                                  hintText: 'PROPERTY SUB TYPE',
                                  selectedValue: _selectedPropertySubType,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.projectType.map((e) => e.projectType ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedPropertyType = value;
                                    });
                                  },
                                  hintText: 'PROPERTY TYPE',
                                  selectedValue: _selectedPropertyType,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.intSite.map((e) => e.productName ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedInterestedSite = value;
                                    });
                                  },
                                  hintText: 'SELECT INT SITE',
                                  selectedValue: _selectedInterestedSite,
                                ),
                                const SizedBox(height: 16),
                                CombinedDropdownTextField(
                                  options: filterData.propertyConfiguration.map((e) => e.propertyconfigurationType ?? '').toList(),
                                  onSelected: (value) {
                                    setState(() {
                                      _selectedPropertyConfiguration = value;
                                    });
                                  },
                                  hintText: 'SELECT PROPERTY CONFIGURATION',
                                  selectedValue: _selectedPropertyConfiguration,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        if (_isFiltering)
                          const Center(child: CircularProgressIndicator())
                        else
                          ElevatedButton(
                            onPressed: _applyFilters,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.deepPurple.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.deepPurple.withOpacity(0.3),
                            ),
                            child: const Text(
                              'Apply Filter',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "poppins_thin",
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontFamily: "poppins_thin",
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class MultiSelectDropdownTextField extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>) onSelectionChanged;
  final String hintText;

  const MultiSelectDropdownTextField({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    required this.hintText,
  });

  @override
  State<MultiSelectDropdownTextField> createState() => _MultiSelectDropdownTextFieldState();
}

class _MultiSelectDropdownTextFieldState extends State<MultiSelectDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _updateControllerText();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _updateControllerText() {
    _controller.text = widget.selectedOptions.isEmpty
        ? ''
        : widget.selectedOptions.join(', ');
  }

  void _onFocusChange() {
    setState(() {
      _isDropdownVisible = _focusNode.hasFocus;
      if (_isDropdownVisible) {
        _showOverlay(context);
      } else {
        _hideOverlay();
      }
    });
  }

  void _toggleOption(String option) {
    setState(() {
      if (widget.selectedOptions.contains(option)) {
        widget.selectedOptions.remove(option);
      } else {
        widget.selectedOptions.add(option);
      }
      _updateControllerText();
      widget.onSelectionChanged(widget.selectedOptions);
    });
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 50.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = widget.selectedOptions.contains(option);
                  return InkWell(
                    onTap: () => _toggleOption(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) => _toggleOption(option),
                            activeColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "poppins_thin",
                                color: isSelected ? Colors.deepPurple : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: "poppins_thin",
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              suffixIconConstraints: const BoxConstraints(minWidth: 40),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up, color: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _showOverlay(context);
              });
            },
          ),
        ],
      ),
    );
  }
}

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;
  final String hintText;
  final String? selectedValue;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
    required this.hintText,
    this.selectedValue,
  });

  @override
  State<CombinedDropdownTextField> createState() => _CombinedDropdownTextFieldState();
}

class _CombinedDropdownTextFieldState extends State<CombinedDropdownTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isDropdownVisible = false;
  List<String> _filteredOptions = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _filteredOptions = widget.options;
    if (widget.selectedValue != null) {
      _controller.text = widget.selectedValue!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isDropdownVisible = _focusNode.hasFocus;
      if (_isDropdownVisible) {
        _showOverlay(context);
      } else {
        _hideOverlay();
      }
    });
  }

  void _filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) => option.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectOption(String option) {
    setState(() {
      _controller.text = option;
      _filteredOptions = widget.options;
      _isDropdownVisible = false;
    });
    widget.onSelected(option);
    _focusNode.unfocus();
    _hideOverlay();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0.0, 50.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: "poppins_thin",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: "poppins_thin",
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              suffixIconConstraints: const BoxConstraints(minWidth: 40),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up, color: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = true;
                    _focusNode.requestFocus();
                    _filterOptions(_controller.text);
                    _showOverlay(context);
                  });
                },
              ),
            ),
            onChanged: (value) {
              _filterOptions(value);
              widget.onSelected(value);
            },
            onTap: () {
              setState(() {
                _isDropdownVisible = true;
                _focusNode.requestFocus();
                _filterOptions(_controller.text);
                _showOverlay(context);
              });
            },
          ),
        ],
      ),
    );
  }
}

class InquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inquiry Details")),
      body: const Center(child: Text("Inquiry Details Screen")),
    );
  }
}

class AddVisitScreen extends StatelessWidget {
  final String inquiryId;

  const AddVisitScreen({super.key, required this.inquiryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Visit")),
      body: Center(child: Text("Add Visit Screen for Inquiry ID: $inquiryId")),
    );
  }
}

class BookingScreen extends StatelessWidget {
  final String inquiryId;

  const BookingScreen({super.key, required this.inquiryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking")),
      body: Center(child: Text("Booking Screen for Inquiry ID: $inquiryId")),
    );
  }
}