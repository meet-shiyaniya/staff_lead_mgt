import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Inquiry_Management/Utils/Custom%20widgets/custom_buttons.dart';
import 'package:hr_app/Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'dart:convert'; // For jsonEncode

import '../../Model/Api Model/add_Lead_Model.dart';
import '../../Model/Api Model/inquiry_transfer_Model.dart';
import '../Colors/app_Colors.dart';

class DismissApprovalScreen extends StatefulWidget {
  final String inquiryId;

  const DismissApprovalScreen({required this.inquiryId});

  @override
  _DismissApprovalScreenState createState() => _DismissApprovalScreenState();
}

class _DismissApprovalScreenState extends State<DismissApprovalScreen> {
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController ssmCommentController = TextEditingController();
  String? selectedCloseReason;
  bool isDeclineExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      print('Starting data fetch for inquiryId: ${widget.inquiryId}');
      provider.loadInquiryData(widget.inquiryId).then((_) {
        print('Inquiry data loaded: ${provider.inquiryModel != null}');
        return provider.fetchAddLeadData();
      }).then((_) {
        print('Add lead data fetched');
        return provider.fetchInquiryStatus();
      }).then((_) {
        print('Inquiry status fetched: ${provider.inquiryStatus != null}');
        setState(() {
          final inquiryModel = provider.inquiryModel;
          if (inquiryModel != null && inquiryModel.inquiryData.inquiry_close_reason != null) {
            selectedCloseReason = inquiryModel.inquiryData.inquiry_close_reason;
            print('Selected close reason set to: $selectedCloseReason');
          } else {
            // Set a default value or null based on your logic.  For example, the first available item:
            if (provider.inquiryStatus?.yes != null && provider.inquiryStatus!.yes.isNotEmpty) {
              selectedCloseReason = provider.inquiryStatus!.yes.first.id;
              print('Set selectedCloseReason to first available: $selectedCloseReason');
            } else {
              selectedCloseReason = null; // No options available
              print('No close reasons available, setting selectedCloseReason to null');
            }
          }
        });
      }).catchError((e) {
        print('Error during data fetch: $e');
        setState(() {});
      });
    });
  }

  Map<String, String> formatCreatedAt(String createdAt) {
    try {
      DateTime parsedDate = DateTime.parse(createdAt);
      return {
        'date': DateFormat("dd MMM yyyy").format(parsedDate),
        'time': DateFormat("hh:mm a").format(parsedDate),
      };
    } catch (e) {
      print('Error parsing date $createdAt: $e');
      return {'date': createdAt, 'time': 'N/A'};
    }
  }

  Future<void> _handleAction(String action) async {
    if (selectedCloseReason == null || selectedCloseReason!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a close reason")),
      );
      return;
    }

    if (action == "decline") {
      if (!isDeclineExpanded) {
        // Expand the SSM Comment section on first tap
        setState(() {
          isDeclineExpanded = true;
        });
        return;
      }

      // Validate SSM Comment when Decline is confirmed
      if (ssmCommentController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please provide an SSM Comment")),
        );
        return;
      }
    }

    final provider = Provider.of<UserProvider>(context, listen: false);
    final inquiryModel = provider.inquiryModel!;

    Map<String, dynamic> formData = {
      'remark': remarkController.text,
      'inquiry_close_reason': selectedCloseReason,
      'action': action,
    };

    // Add SSM Comment to formData if declining
    if (action == "decline") {
      formData['ssm_comment'] = ssmCommentController.text;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    bool success;
    if (action == "approve") {
      success = await provider.DismissApprove(
        edit_id: inquiryModel.inquiryData.id,
      );
    } else {
      success = await provider.DismissDecline(
        edit_id: inquiryModel.inquiryData.id,
        remart: remarkController.text, // Pass String, not controller
      );
    }

    Navigator.pop(context); // Close the loading dialog

    if (success) {
      Fluttertoast.showToast(msg: "Lead ${action}d successfully");
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: "Failed to $action lead. Check server logs for details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, inquiryProvider, child) {
        print('Building UI - isLoading: ${inquiryProvider.isLoading}, '
            'isLoadingDropdown: ${inquiryProvider.isLoadingDropdown}');

        if (inquiryProvider.isLoading || inquiryProvider.isLoadingDropdown) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final inquiryModel = inquiryProvider.inquiryModel;

        if (inquiryModel == null) {
          print('InquiryModel is null');
          return Scaffold(
            appBar: AppBar(
              title: const Text("Inquiry Details",
                  style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
              backgroundColor: Colors.deepPurple.shade300,
              leading: const BackButton(color: Colors.white),
            ),
            body: const Center(child: Text("Failed to load inquiry data")),
          );
        }

        if (inquiryProvider.inquiryStatus == null) {
          print('InquiryStatus is null');
          return Scaffold(
            appBar: AppBar(
              title: const Text("Inquiry Details",
                  style: TextStyle(fontFamily: "poppins_thin", color: Colors.white)),
              backgroundColor: AppColor.Buttoncolor,
              leading: const BackButton(color: Colors.white),
            ),
            body: const Center(child: Text("Loading close reasons...")),
          );
        }

        List<Map<String, String>> closeReasonOptions = inquiryProvider.inquiryStatus?.yes
            ?.map((e) => {'id': e.id, 'name': e.inquiryCloseReason})
            ?.toList() ??
            [];

        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Text(
              "Inquiry Details",
              style: TextStyle(fontFamily: "poppins_thin", color: Colors.white),
            ),
            backgroundColor: AppColor.Buttoncolor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildPersonalAndInterestedDetails(inquiryModel, closeReasonOptions, inquiryProvider),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _timelineSection(inquiryModel.processedData ?? []),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Adjusted button section with debugging
              Container(
                color: Colors.white, // Debug: Visualize the container
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Reduced padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Temporarily replace GradientButton with ElevatedButton
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4, // Constrain width
                      child: GradientButton(
                        onPressed: () => _handleAction("approve"),
                        buttonText:("Approve"),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4, // Constrain width
                      child: GradientButton(
                        onPressed: () => _handleAction("decline"),
                        buttonText:("Decline"),
                      ),
                    ),
                    // Uncomment to revert to GradientButton after testing
                    // GradientButton(
                    //   buttonText: "Approve",
                    //   onPressed: () => _handleAction("approve"),
                    // ),
                    // GradientButton(
                    //   buttonText: "Decline",
                    //   onPressed: () => _handleAction("decline"),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalAndInterestedDetails(InquiryModel model, List<Map<String, String>> closeReasonOptions, UserProvider inquiryProvider) {
    return Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: Text(
                  model.inquiryData.id ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: "poppins_thin",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              model.inquiryData.fullName ?? 'N/A',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text("\u260E ${model.inquiryData.mobileno ?? 'N/A'}"),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Int Area:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(model.inquiryData.intrestedArea ?? "N/A"),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Int Site:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(model.intrestedProduct ?? "N/A"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Unit Type:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(model.propertyConfigurationType ?? "N/A"),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Budget:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(model.inquiryData.budget ?? "N/A"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Purpose:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(model.inquiryData.purposeBuy ?? "N/A"),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Approx Buying:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text(model.inquiryData.approxBuy ?? "N/A"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Remark*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
                ),
                TextFormField(
                  controller: remarkController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: model.inquiryRemark ?? 'No remark available',
                  ),
                  maxLines: 3,
                ),
                if (isDeclineExpanded) ...[
                  const SizedBox(height: 16),
                  const Text(
                    "SSM Comment*",
                    style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
                  ),
                  TextFormField(
                    controller: ssmCommentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: "Enter SSM Comment",
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (isDeclineExpanded && (value == null || value.isEmpty)) {
                        return "SSM Comment is required";
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  "Close Reason*",
                  style: TextStyle(fontSize: 16, fontFamily: "poppins_thin"),
                ),
                const SizedBox(height: 5),
                closeReasonOptions.isEmpty
                    ? const Center(
                  child: Text(
                    "No close reasons available",
                    style: TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                  ),
                )
                    : FormField<String>(
                  initialValue: selectedCloseReason,
                  validator: inquiryProvider.isLoadingDropdown
                      ? null // Conditionally disable the validator
                      : (value) {
                    if (value == null || value.isEmpty) {
                      return "Close reason is required";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Close Reason',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "poppins_thin",
                            ),
                          ),
                          value: selectedCloseReason,
                          onChanged: (value) {
                            setState(() {
                              selectedCloseReason = value;
                            });
                            state.didChange(value); // Crucial: Update FormField state
                          },
                          items: closeReasonOptions.map((Map<String, String> item) {
                            return DropdownMenuItem<String>(
                              value: item['id'],
                              child: Text(
                                item['name'] ?? 'N/A',
                                style: const TextStyle(fontFamily: "poppins_thin", fontSize: 16),
                              ),
                            );
                          }).toList(),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(-5, -10),
                            maxHeight: 200,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            elevation: 10,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _timelineSection(List<ProcessedData> processedData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Timeline",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        processedData.isEmpty
            ? const Center(child: Text("No timeline data available"))
            : SizedBox(
          width: double.infinity,
          child: Timeline.tileBuilder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            theme: TimelineThemeData(
              direction: Axis.vertical,
              connectorTheme: const ConnectorThemeData(color: Colors.grey, thickness: 2.0),
              indicatorTheme: const IndicatorThemeData(size: 12.0, color: Colors.deepPurple),
              nodePosition: 0.1,
            ),
            builder: TimelineTileBuilder.connected(
              itemCount: processedData.length,
              connectionDirection: ConnectionDirection.before,
              indicatorBuilder: (_, index) => const DotIndicator(
                color: Colors.deepPurple,
                size: 12.0,
              ),
              connectorBuilder: (_, index, __) => const SolidLineConnector(
                color: Colors.grey,
              ),
              contentsBuilder: (context, index) {
                final item = processedData[index];
                final formattedDate = formatCreatedAt(item.createdAt);
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 64,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.statusLabel ?? 'N/A',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              item.username ?? 'N/A',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              "Next: ${item.nxtFollowDate ?? 'N/A'}",
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item.remarkText ?? 'No remarks',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${formattedDate['date']} - ${formattedDate['time']}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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