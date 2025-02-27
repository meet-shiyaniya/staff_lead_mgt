import 'package:flutter/material.dart';
import 'package:hr_app/Inquiry_Management/Utils/Colors/app_Colors.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/custom_buttons.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:lottie/lottie.dart';

class InquiryScreen extends StatefulWidget {
  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String selectedTab = "Follow Up";
  final List<String> tabs = ["Follow Up", "Dismissed", "Appointment", "CNR", "Negotiations", "Feedback"];
  bool isEditing = false;
  String selectedArea = "Masma";
  String selectedSite = "Royal Business Hub";
  String selectedUnitType = "1 BHK + 1 BHK";
  String selectedBudget = "3";
  String selectedPurpose = "Personal Use";
  String selectedBuyingTime = "2 Month";
  String? selectedApx;
  final List<Map<String, String>> timelineData = [
    {
      "date": "17-07-2024 12:04 PM",
      "user": "Demo",
      "status": "Follow up",
      "nextDate": "17-07-2024 12:04 PM",
      "message": "aaa"
    },
    {
      "date": "24-03-2024 11:11 AM",
      "user": "Demo",
      "status": "Follow up",
      "nextDate": "24-03-2024 11:11 AM",
      "message": "5ty6eeter"
    },
    {
      "date": "23-03-2024 07:16 PM",
      "user": "dishant",
      "status": "Follow up",
      "nextDate": "23-03-2024 07:20 PM",
      "message": "Test notification"
    },
    {
      "date": "03-10-2023 12:13 AM",
      "user": "dishant",
      "status": "Trial",
      "nextDate": "05-10-2023 02:42 AM",
      "message": "parvat patiya baju rey che aemna 2chokara che budget che 35 sudhi nu dur no problem che vichari ne kese"
    },
    {
      "date": "02-10-2023 08:43 PM",
      "user": "akhil",
      "status": "Follow up",
      "nextDate": "02-10-2023 11:13 AM",
      "message": "Aje avna che"
    },
    {
      "date": "01-10-2023 01:25 AM",
      "user": "akhil",
      "status": "Contacted",
      "nextDate": "02-10-2023 03:55 PM",
      "message": "Parvat patiya Rahi che baejt vat Kari nhi Monday avnu keji"
    },
  ];
  final List<String> areaOptions = ["Masma", "Olpad", "Adajan", "Vesu"];
  final List<String> siteOptions = ["Royal Business Hub", "Villas 24", "Green Homes", "Sunrise Residency"];
  final List<String> unitOptions = ["1 BHK", "2 BHK", "3 BHK", "4 BHK", "5 BHK", "1 BHK + 1 BHK"];
  final List<String> budgetOptions = ["1", "2", "3", "50", "75", "101", "150", "200"];
  final List<String> purposeOptions = ["Personal Use", "Investment"];
  final List<String> buyingTimeOptions = ["1 Week", "2 Month", "6 Month", "1 Year"];
  bool isDismissed = false;
  DateTime? selectedDate;
  String? selectedTime;
  final TextEditingController nextFollowUpController = TextEditingController();
  final TextEditingController otherActionController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  String? selectedCloseReason;
  String? selectedIntMembership;
  DateTime? appointmentDate;
  String? selectedProject;
  bool showCloseReasonOnly = false;

  final List<String> projectOptions = ["Project A", "Project B", "Project C"];
  final List<String> timeOptions = ["8:00", "9:00", "10:00", "11:00", "12:00"];
  final List<String> closeReasonOptions = ["Budget Problem", "Not Required", "Muscles"];
  final List<String> intMembershipOptions = ["Package 1", "Package 2", "Package 3"];

  Map<String, String> formatCreatedAt(String createdAt) {
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy hh:mm a").parse(createdAt);
      return {
        'date': DateFormat("dd MMM yyyy").format(parsedDate),
        'time': DateFormat("hh:mm a").format(parsedDate),
      };
    } catch (e) {
      return {'date': createdAt, 'time': 'N/A'};
    }
  }

  void showDismissedConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Dismiss Inquiry?", style: TextStyle(fontFamily: "poppins_thin")),
          content: Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset("asset/Inquiry_module/errors.json",height: 170,width: 170),
                Center(
                  child: Text("Did you have conversation with this inquiry?",
                      style: TextStyle(fontFamily: "poppins_thin",fontSize: 18)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                setState(() {
                  isDismissed = true; // Mark as dismissed
                  showCloseReasonOnly = false;
                });
              },
              child: const Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without action
                setState(() {
                  showCloseReasonOnly = true;
                });
              },
              child: const Text("No", style: TextStyle(fontFamily: "poppins_thin")),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateAndTime() async {
    // Pick Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick Time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime.format(context);
          otherActionController.text = _formatDateTime(selectedDate, selectedTime);
        });
      }
    }
  }

  Future<void> _pickAppointmentDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        appointmentDate = pickedDate;
      });
    }
  }

  // Format the Date and Time together
  String _formatDateTime(DateTime? date, String? time) {
    if (date != null && time != null) {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      return '${dateFormat.format(date)} $time';
    }
    return "Select Date & Time";
  }

  void _showCNRDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm CNR", style: TextStyle(fontFamily: "poppins_thin")),
          content: Text("Are you sure you want to mark this inquiry as CNR?", style: TextStyle(fontFamily: "poppins_thin")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Add your CNR logic here
                print("Inquiry marked as CNR");
              },
              child: Text("Yes", style: TextStyle(fontFamily: "poppins_thin")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without action
              },
              child: Text("No", style: TextStyle(fontFamily: "poppins_thin")),
            ),
          ],
        );
      },
    );
  }
  void _handleTabChange(String value) {
    if (value == "Dismissed") {
      showDismissedConfirmationDialog();
    }

    setState(() {
      selectedTab = value;
      remarkController.clear();
      nextFollowUpController.clear();
      otherActionController.clear();
      selectedCloseReason = null;
      selectedIntMembership = null;
      appointmentDate = null;
      selectedProject = null;
      showCloseReasonOnly = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Inquiry Details",
            style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
        backgroundColor: AppColor.Buttoncolor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.deepPurple.shade300,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: Text(
                                  "687676",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "poppins_thin",
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Chota Rajan",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColor.Buttoncolor,
                            radius: 18,
                            child: IconButton(
                              icon: Icon(
                                isEditing ? Icons.save : Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  isEditing = !isEditing;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Text("\u260E +91 99********"),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile("Int Area", selectedArea, areaOptions,
                                  (newValue) {
                                setState(() {
                                  selectedArea = newValue;
                                });
                              }),
                          _infoTile("Int Site", selectedSite, siteOptions,
                                  (newValue) {
                                setState(() {
                                  selectedSite = newValue;
                                });
                              }),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile("Unit Type", selectedUnitType, unitOptions,
                                  (newValue) {
                                setState(() {
                                  selectedUnitType = newValue;
                                });
                              }),
                          _infoTile("Budget", selectedBudget, budgetOptions,
                                  (newValue) {
                                setState(() {
                                  selectedBudget = newValue;
                                });
                              }),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoTile("Purpose", selectedPurpose, purposeOptions,
                                  (newValue) {
                                setState(() {
                                  selectedPurpose = newValue;
                                });
                              }),
                          _infoTile("Approx Buying", selectedBuyingTime,
                              buyingTimeOptions, (newValue) {
                                setState(() {
                                  selectedBuyingTime = newValue;
                                });
                              }),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: MainButtonGroup(
                  buttonTexts: tabs,
                  selectedButton: selectedTab,
                  onButtonPressed: _handleTabChange,
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: _buildTabContent(),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _remarkSection(), // ✅ Wrapped in Card for proper display
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value, List<String> options, ValueChanged<String> onChanged) {
    return isEditing == false
        ? SizedBox(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(value),
      ]),
    )
        : SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
        CombinedDropdownTextField(
          options: options,
          onSelected: (newValue) {
            onChanged(newValue);
          },
          hintText: title,
        ),
      ]),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case "Follow Up":
        return _buildFollowUpForm();
      case "Dismissed":
        return _buildDismissedForm();
      case "Appointment":
        return _buildAppointmentForm();
      case "Negotiations":
      case "Feedback":
        return _buildOtherActionForm();
      case "CNR":
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showCNRDialog();
        });
        return Container(); // Return an empty container as the dialog is shown
      default:
        return Container(); // Or some default content
    }
  }

  Widget _buildFollowUpForm() {
    return Column(
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    nextFollowUpController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: nextFollowUpController,
                    decoration: InputDecoration(
                      labelText: "Next Follow Up *",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "DD/MM/YYYY",
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: CombinedDropdownTextField(
                options: timeOptions,
                onSelected: (newValue) {
                  setState(() {
                    selectedApx = newValue;
                  });
                },
                hintText: "Time",
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDismissedForm() {
    return Column(
      children: [
        if (!showCloseReasonOnly)
          TextFormField(
            controller: remarkController,
            decoration: InputDecoration(
              labelText: "Remark *",
              labelStyle: const TextStyle(fontFamily: "poppins_thin"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: "Your Message here...",
            ),
            maxLines: 3,
          ),
        SizedBox(height: 16),
        CombinedDropdownTextField(
          options: closeReasonOptions,
          onSelected: (newValue) {
            setState(() {
              selectedCloseReason = newValue;
            });
          },
          hintText: "Close Reason",
        ),
      ],
    );
  }

  Widget _buildAppointmentForm() {
    return Column(
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        CombinedDropdownTextField(
          options: projectOptions,
          onSelected: (newValue) {
            setState(() {
              selectedProject = newValue;
            });
          },
          hintText: "Select Project",
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    nextFollowUpController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: nextFollowUpController,
                    decoration: InputDecoration(
                      labelText: "Next Follow Up *",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "DD/MM/YYYY",
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: CombinedDropdownTextField(
                options: timeOptions,
                onSelected: (newValue) {
                  setState(() {
                    selectedApx = newValue;
                  });
                },
                hintText: "Time",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () async {
            _pickAppointmentDate();
          },
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Appointment Date *",
                labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: "DD/MM/YYYY",
                suffixIcon: const Icon(Icons.calendar_month),
              ),
              controller: TextEditingController(
                text: appointmentDate != null
                    ? "${appointmentDate?.day}/${appointmentDate?.month}/${appointmentDate?.year}"
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtherActionForm() {
    return Column(
      children: [
        TextFormField(
          controller: remarkController,
          decoration: InputDecoration(
            labelText: "Remark *",
            labelStyle: const TextStyle(fontFamily: "poppins_thin"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: "Your Message here...",
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _pickDateAndTime();
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: otherActionController,
                    decoration: InputDecoration(
                      labelText: "Select Date & Time",
                      labelStyle: const TextStyle(fontFamily: "poppins_thin"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "DD/MM/YYYY HH:MM",
                      hintStyle: const TextStyle(fontFamily: "poppins_thin"),
                      suffixIcon: const Icon(Icons.calendar_month),
                    ),
                    readOnly: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _remarkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Timeline",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity, // Constrain to full width of parent
          child: Timeline.tileBuilder(
            shrinkWrap: true, // Allow the timeline to size to its content
            physics: NeverScrollableScrollPhysics(), // Keep it non-scrollable
            theme: TimelineThemeData(
              direction: Axis.vertical, // Ensure vertical timeline
              connectorTheme: ConnectorThemeData(
                color: Colors.grey,
                thickness: 2.0,
              ),
              indicatorTheme: IndicatorThemeData(
                size: 12.0,
                color: Colors.deepPurple,
              ),
              nodePosition: 0.1, // Position indicators and connectors closer to the left
            ),
            builder: TimelineTileBuilder.connected(
              itemCount: timelineData.length,
              connectionDirection: ConnectionDirection.before,
              indicatorBuilder: (_, index) => DotIndicator(
                color: Colors.deepPurple,
                size: 12.0,
              ),
              connectorBuilder: (_, index, __) => SolidLineConnector(
                color: Colors.grey,
              ),
              contentsBuilder: (context, index) {
                final item = timelineData[index];
                final formattedDate = formatCreatedAt(item["date"]!);

                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0), // Adjusted padding
                  child: Container(
                    width: MediaQuery.of(context).size.width - 64, // Constrain width relative to screen
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item["status"]!,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              item["user"]!,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              "Next: ${item["nextDate"]!}",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item["message"]!,
                                maxLines: 3, // Limit lines to prevent excessive height
                                overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${formattedDate['date']} - ${formattedDate['time']}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

}

class MainButtonGroup extends StatefulWidget {
  final List<String> buttonTexts;
  final String selectedButton;
  final ValueChanged<String> onButtonPressed;

  const MainButtonGroup({
    Key? key,
    required this.buttonTexts,
    required this.selectedButton,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  _MainButtonGroupState createState() => _MainButtonGroupState();
}

class _MainButtonGroupState extends State<MainButtonGroup> {
  late String _selectedButton;

  @override
  void initState() {
    super.initState();
    _selectedButton = widget.selectedButton;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.buttonTexts.map((text) => _buildButton(text)).toList(),
    );
  }

  Widget _buildButton(String text) {
    final bool isSelected = _selectedButton == text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.deepPurple.shade100 : Colors.white,
          foregroundColor: isSelected ? Colors.deepPurple : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedButton = text;
          });
          widget.onButtonPressed(text);
        },
        child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class CombinedDropdownTextField extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelected;
  final String hintText;

  const CombinedDropdownTextField({
    super.key,
    required this.options,
    required this.onSelected,
    this.hintText = 'Select or Type',
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
    _filteredOptions = widget.options; // Initialize with all options
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
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectOption(String option) {
    setState(() {
      _controller.text = option;
      _filteredOptions = widget.options; // Reset to all options after selection
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
          offset: Offset(0.0, size.height + 5.0),
          child: Card(
            elevation: 4,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  return InkWell(
                    onTap: () => _selectOption(option),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(option),
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
              hintStyle: const TextStyle(fontFamily: "poppins_light"),
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              suffixIcon: _isDropdownVisible
                  ? IconButton(
                icon: const Icon(Icons.arrow_drop_up),
                onPressed: () {
                  setState(() {
                    _isDropdownVisible = false;
                    _focusNode.unfocus();
                    _hideOverlay();
                    _filteredOptions = widget.options;
                    _controller.clear(); // Clear the text
                  });
                },
              )
                  : IconButton(
                icon: const Icon(Icons.arrow_drop_down),
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