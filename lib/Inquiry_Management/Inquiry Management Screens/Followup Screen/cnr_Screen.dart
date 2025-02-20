import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/UserProvider.dart';
import '../../Model/Api Model/allInquiryModel.dart';
import '../../Model/category_Model.dart';
import '../../Model/followup_Model.dart';
import '../../Utils/Custom widgets/custom_buttons.dart';
import '../../Utils/Custom widgets/custom_dialog.dart';
import '../../Utils/Custom widgets/pending_Card.dart';
import 'list_filter_Screen.dart';

class CnrScreen extends StatefulWidget {
  const CnrScreen({super.key});

  @override
  State<CnrScreen> createState() => _CnrScreenState();
}

class _CnrScreenState extends State<CnrScreen> {
  String selectedList = "All Leads";
  String selectedValue = "5";
  int? selectedIndex;

  List<LeadModel> LeadList = [
    LeadModel("1", "abc", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "abc@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"IEDJSXKZM,"),
    LeadModel("2", "xyz", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "xyz@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"OIDUJSKM,A"),
    LeadModel("3", "pqr", "leadmgt", "Qualified", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "pqr@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"SIAJDKMX"),
    LeadModel("4", "lmn", "leadmgt", "Cnr", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "lmn@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"WIQUDJKSM"),
    LeadModel("5", "jkl", "leadmgt", "Cnr", '02-01-2025', '04-01-2025', "Fresh", "1232312311", "jkl@gmail.com", "Facebook",'table','1-2 days','ielts','3 months',"QIWYDUSJNZ"),
  ];

  List<CategoryModel> categoryList = [];
  List<LeadModel> filteredLeads = [];
  List<bool> selectedCards = [];
  bool anySelected = false;

  String? selectedAction = null; // Set to null initially
  String? selectedEmployee = null; // Set to null initially
  final List<String> actions = ['markAsComplete','assignToUser','delete'];
  final List<String> employees = ['employee 1','employee 2','employee 3'];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

      Future.microtask(() {
        Provider.of<UserProvider>(context, listen: false).fetchInquiries();
      });

      _scrollController = ScrollController();
      _scrollController.addListener(_onScroll);
    }

    void _onScroll() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        Provider.of<UserProvider>(context, listen: false).fetchInquiries();
      }
    }

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();

    selectedCards = List.generate(LeadList.length, (index) => false);
    categoryList = [
      CategoryModel("Qualified", LeadList.where((lead) => lead.label == "Qualified").toList()),
      CategoryModel("Cnr", LeadList.where((lead) => lead.label == "Cnr").toList()),
      CategoryModel("All Lead", LeadList),
    ]; // All leads grouped here

    filteredLeads = List.from(LeadList);
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

  final TextEditingController nextFollowupcontroller=TextEditingController();
  String selectedcallFilter = "Follow Up";
  List<String> callList=['Followup','Dismissed','Appointment',"Negotiation","Feedback",'Cnr'];

  void handleAction(String action, String employee) {
    // print("Action: $action on items: $selectedItemsPerFilter");
    setState(() {
      // selectedItemsPerFilter[selectedIndex]?.clear();
      // isSelectionMode = false;
      selectedAction = null;
      selectedEmployee=null;
    });
  }

  String? selectedMembership;
  String? selectedApx;
  String? selectedPurpose;
  String? selectedTime;

  void toggleSelection(int index) {
    selectedCards[index] = !selectedCards[index];
    anySelected = selectedCards.contains(true);
    print("anySelected : $anySelected");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final inquiryProvider = Provider.of<UserProvider>(context);
    if (selectedCards.length != inquiryProvider.inquiries.length) {
      selectedCards = List<bool>.generate(
        inquiryProvider.inquiries.length,
            (index) => false,
      );

  }
    return Column(
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
                  optionList: categoryList,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 26.0, ),
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
          child: ListView.builder(

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
              callList: callList,
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
    );
  }
}