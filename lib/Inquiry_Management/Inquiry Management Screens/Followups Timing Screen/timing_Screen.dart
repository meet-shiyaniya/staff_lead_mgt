import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
// import 'package:lottie/lottie.dart';

import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/allInquiryModel.dart';
import '../../Model/category_Model.dart';
import '../../Model/followup_Model.dart';
import '../../Utils/Colors/app_Colors.dart';
import '../../Utils/Custom widgets/custom_buttons.dart';
import '../../Utils/Custom widgets/custom_dialog.dart';
import '../../Utils/Custom widgets/custom_search.dart';
import '../../Utils/Custom widgets/filter_Bottomsheet.dart';
import '../../Utils/Custom widgets/pending_Card.dart';
// import '../../test_Screen.dart';
import '../Followup Screen/list_filter_Screen.dart';

class TimingScreen extends StatefulWidget {
  const TimingScreen({super.key});

  @override
  State<TimingScreen> createState() => _TimingScreenState();
}

class _TimingScreenState extends State<TimingScreen> {
  String selectedList = "All Leads";
  String selectedValue = "15";
  int? selectedIndex;
  List<LeadModel> LeadList = [
    LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"jaisdjshadkanadabcbcamnmnsaasddadsdsSS"),
    LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"NASDNAXNSXMN"),
    LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"DJASHNDJNASN"),
    LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"NANDNASMD"),
    LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"DUIQOJSZ"),
    LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"DJIJSAJKJ"),
    LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"UWIDHNXN"),
    LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"IDUEIWYDJANXM"),
    LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"JEIOJDNMKS"),
    LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"EIOWJFDMKX"),
    LeadModel("1", "abc", "leadmgt", "Feedback", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"E9UWJIODKSMX"),
    LeadModel("2", "xyz", "leadmgt", "Negotiations", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"EIJMFKDASJIED"),
    LeadModel("3", "pqr", "leadmgt", "Appointment", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"OIUJDISKAMX "),
    LeadModel("4", "lmn", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"IEUWIOEJDSKMX"),
    LeadModel("5", "jkl", "leadmgt", "Fresh", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"IEDJSKMX"),
  ];

  List<CategoryModel> categoryList = [];
  List<LeadModel> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;


  String? selectedAction = null; // Set to null initially
  String? selectedEmployee = null; // Set to null initially
  final List<String> actions = ['markAsComplete','assignToUser','delete'];
  final List<String> employees = ['employee 1','employee 2','employee 3'];

  @override
  void initState() {
    super.initState();
    selectedCards = List.generate(LeadList.length, (index) => false);
    categoryList = [
      CategoryModel("Feedback", LeadList.where((lead) => lead.label == "Feedback").toList()),
      CategoryModel("Negotiations", LeadList.where((lead) => lead.label == "Negotiation").toList()),
      CategoryModel("Appointment", LeadList.where((lead) => lead.label == "Appointment").toList()),
      CategoryModel("Qualified", LeadList.where((lead) => lead.label == "Qualified").toList()),
      CategoryModel("Fresh", LeadList.where((lead) => lead.label == "Fresh").toList()),
      CategoryModel("All Lead", LeadList),
    ];
    filteredLeads = List.from(LeadList);
  }

  // Function to apply filters
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      // Apply filters to filteredLeads
      filteredLeads = LeadList.where((lead) {
        bool matches = true;

        // Check filters one by one
        if (filters['id'].isNotEmpty && !lead.id.contains(filters['id'])) {
          matches = false;
        }
        if (filters['name'].isNotEmpty && !lead.name.contains(filters['name'])) {
          matches = false;
        }
        if (filters['mobile'].isNotEmpty && !lead.phone.contains(filters['mobile'])) {
          matches = false;
        }
        if (filters['nextFollowUp'].isNotEmpty && !lead.nextFollowUpDate.contains(filters['nextFollowUp'])) {
          matches = false;
        }
        if (filters['inquiryStatus'].isNotEmpty && !filters['inquiryStatus'].contains(lead.label)) {
          matches = false;
        }
        if (filters['intProduct'] != null && filters['intProduct'] != lead.inquiryType) {
          matches = false;
        }
        if (filters['assignother'] != null && filters['assignother'] != lead.username) {
          matches = false;
        }
        // You can add more filters here based on the other fields

        return matches;
      }).toList();
    });
  }

  void _updateSearchResults(List<LeadModel> results) {
    setState(() {
      filteredLeads = results;
    });
  }

  void filterLeads(String category) {
    setState(() {
      if (category == "All Lead") {
        filteredLeads = List.from(LeadList);
      } else {
        filteredLeads = LeadList.where((lead) => lead.label == category).toList();
      }
    });
  }


  void handleAction(String action, String employee) {
    // print("Action: $action on items: $selectedItemsPerFilter");
    setState(() {
      // selectedItemsPerFilter[selectedIndex]?.clear();
      // isSelectionMode = false;
      selectedAction = null;
      selectedEmployee=null;
    });
  }
  void toggleSelection(int index) {
    selectedCards[index] = !selectedCards[index];
    anySelected = selectedCards.contains(true);
    print("anySelected : $anySelected");
    setState(() {});
  }


  final TextEditingController nextFollowupcontroller=TextEditingController();
  String selectedcallFilter = "Follow Up";
  List<String> callList=['Followup','Dismissed','Appointment','Cnr'];


  String? selectedMembership;
  String? selectedApx;
  String? selectedPurpose;
  String? selectedTime;


  void _updateAppliedFilters(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;
      filteredId = filters['Id'];
    });
  }
  Map<String, dynamic> appliedFilters = {};
  void resetFilters() {
    setState(() {
      filteredLeads = List.from(LeadList); // Reset the list to the original
      appliedFilters.clear(); // Clear all applied filters
      filteredId = null; // Clear filtered ID
    });
  }
  // void showBottomModalSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
  //     ),
  //     builder: (context) => FractionallySizedBox(
  //       heightFactor: 0.6,
  //       child: FilterModal(
  //         onFilterApplied: (List<LeadModel> filteredList, Map<String, dynamic> filters) {
  //           _updateSearchResults(filteredList); // Pass the filtered list
  //           _updateAppliedFilters(filters); // Update the applied filters in the parent
  //         },
  //         appliedFilters: appliedFilters,
  //       ),
  //     ),
  //   );
  // }
  // Track the applied filters
  String? filteredId;
  String? filteredName;
  String? filteredMobile;
  List<String> filteredStatus = [];

  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);
    if (selectedCards.length != inquiryProvider.inquiries.length) {
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiries.length,
            (index) => false,
      );


  }
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Followup",style: TextStyle(fontFamily: "poppins_thin",color: Colors.white),),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          SearchBar1(
            items: LeadList,
            onSearch:  _updateSearchResults,

          ),
          SizedBox(width: 10,),
          CircleAvatar(
            backgroundColor: Colors.white,
            // backgroundColor: Colors.deepPurple.shade300,
            child: IconButton(
                onPressed: () {
                  // showBottomModalSheet(context);
                }, icon: Icon(Icons.filter_list_outlined,color: Colors.black,)),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          if (anySelected)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Action',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedAction,
                        onChanged: (value) {
                          setState(() {
                            selectedAction = value;
                          });
                        },
                        items: actions.map((action) => DropdownMenuItem(
                          value: action,
                          child: Text(action,
                              style: TextStyle(
                                  fontFamily: "poppins_thin")),
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Employee',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "poppins_thin",
                          ),
                        ),
                        value: selectedEmployee,
                        onChanged: (value) {
                          setState(() {
                            selectedEmployee = value;
                          });
                        },
                        items: employees
                            .map((employee) => DropdownMenuItem(
                          value: employee,
                          child: Text(employee,
                              style: TextStyle(
                                  fontFamily: "poppins_thin")),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: SizedBox(
                      // width: 100, // Limit the width of the button
                      child: GradientButton(
                        buttonText: "Submit",
                        onPressed: () {
                          if (selectedAction == null || selectedEmployee == null) {
                            // Show dialog to prompt the user to select data
                            showsubmitdialog(context);
                          } else {
                            // Show confirmation dialog
                            showConfirmationDialog(context);
                            handleAction(selectedAction!, selectedEmployee!);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListSelectionScreen(
                    initialSelectedIndex: selectedIndex,
                    optionList: categoryList.map((category) {
                      return CategoryModel(category.title, category.leads);
                    }).toList(),
                  ),
                ),
              );

              if (result != null && result is Map) {
                setState(() {
                  selectedIndex = result["selectedIndex"];
                  CategoryModel selectedCategory = result["selectedCategory"];
                  selectedList = selectedCategory.title;
                  selectedValue = selectedCategory.leadCount.toString();
                });
                filterLeads(selectedList);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.deepPurple.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedList, style: TextStyle(fontFamily: "poppins_thin", fontSize: 16)),
                    Row(
                      children: [
                        Icon(Icons.group, color: Colors.black),
                        SizedBox(width: 8.0),
                        Text(selectedValue, style: TextStyle(fontFamily: "poppins_thin")),
                        Icon(Icons.arrow_drop_down, color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredLeads.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset('asset/Inquiry_module/no_result.json', fit: BoxFit.contain, width: 300, height: 300),
                ),
                Center(
                  child: Text(
                    "No results found",
                    style: TextStyle(color: Colors.red, fontSize: 26,fontFamily: "poppins_thin"),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
    if (index < inquiryProvider.inquiries.length) {
      Inquiry inquiry = inquiryProvider.inquiries[index];
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onLongPress: () {
              toggleSelection(index);
            },

            child: TestCard(
              id: filteredLeads[index].id,
              name: filteredLeads[index].name,
              username: filteredLeads[index].username,
              label: filteredLeads[index].label,
              followUpDate: filteredLeads[index].followUpDate,
              nextFollowUpDate: filteredLeads[index].nextFollowUpDate,
              inquiryType: filteredLeads[index].inquiryType,
              intArea: inquiry.InqArea,
              purposeBuy: inquiry.PurposeBuy,
              daySkip: inquiry.dayskip,
              hourSkip: inquiry.hourskip,
              // phone: filteredLeads[index].phone,
              // email: filteredLeads[index].email,
              source: filteredLeads[index].source,
              isSelected: selectedCards[index],
              onSelect: () {
                toggleSelection(index);
              },
              callList: [
                "Followup",
                "Dismissed",
                "Appointment",
                "Negotiation",
                "Feedback",
                "Cnr"
              ],
              // selectedTime: selectedTime,
              // selectedPurpose: selectedPurpose,
              // selectedApx: selectedApx,
              // selectedAction: selectedAction,
              selectedcallFilter: selectedcallFilter,
              // selectedEmployee: selectedEmployee,
              data: inquiry,
              isTiming: true,
              nextFollowupcontroller: nextFollowupcontroller,
            ),
          );
        },
      );
    }},
            ),
          ),
        ],
      ),
    );
  }
}
