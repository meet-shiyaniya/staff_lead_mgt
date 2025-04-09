import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../Provider/UserProvider.dart';
import '../staff_HRM_module/Screen/Color/app_Color.dart';
import 'Models/fetch_Lead_Reports_Model.dart';

class LeadReportsScreen extends StatefulWidget {
  @override
  State<LeadReportsScreen> createState() => _LeadReportsScreenState();
}

class _LeadReportsScreenState extends State<LeadReportsScreen> {
  String? selectedPageId; // Variable to store selected page_id
  String? selectedOption; // Will be set to first available option after data loads

  @override
  void initState() {
    super.initState();
    // Fetch the dropdown data and initial lead reports after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.fetchCampaignDropdown().then((_) {
        // After dropdown data is loaded, set initial selection and fetch reports
        final dropdownData = provider.campaignDropdownData?.dropDown
            ?.map((dropDown) => {
          "page_id": dropDown.pageId ?? "",
          "page_name": dropDown.pageName ?? ""
        })
            .toList() ??
            [];
        if (dropdownData.isNotEmpty) {
          setState(() {
            selectedOption = dropdownData.firstWhere(
                  (item) => item['page_name']!.isNotEmpty,
              orElse: () => dropdownData.first,
            )['page_name'];
            selectedPageId = dropdownData.firstWhere(
                  (item) => item['page_name'] == selectedOption,
              orElse: () => dropdownData.first,
            )['page_id'];
          });
          if (selectedPageId != null && selectedPageId!.isNotEmpty) {
            provider.fetchLeadReports(pageID: int.parse(selectedPageId!));
          }
        }
      });
    });
  }

  void _fetchReportsForPageId(String pageId) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchLeadReports(pageID: int.parse(pageId));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        // Convert provider data to a list of maps for easier handling
        final dropdownData = provider.campaignDropdownData?.dropDown
            ?.map((dropDown) => {
          "page_id": dropDown.pageId ?? "",
          "page_name": dropDown.pageName ?? ""
        })
            .toList() ??
            [];

        // Show loading state while fetching campaign dropdown data
        if (provider.isLoadingCampaignDropdown) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Lead Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "poppins_thin",
                  fontSize: 18,
                ),
              ),
              backgroundColor: appColor.primaryColor,
              centerTitle: true,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: const Center(
              child: Text(
                'Campaign Data Loading...',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        // Check for null or invalid dropdown data after loading
        bool isDropdownEmpty = provider.campaignDropdownData == null;

        if (isDropdownEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Lead Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "poppins_thin",
                  fontSize: 18,
                ),
              ),
              backgroundColor: appColor.primaryColor,
              centerTitle: true,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: const Center(
              child: Text(
                'No Campaign Data Available!',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "poppins_thin",
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        // If dropdown data is valid, proceed with the original UI
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Lead Reports',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "poppins_thin",
                fontSize: 18,
              ),
            ),
            backgroundColor: appColor.primaryColor,
            centerTitle: true,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                color: Colors.white,
                offset: const Offset(0, 12),
                position: PopupMenuPosition.under,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                itemBuilder: (BuildContext context) => dropdownData.map((option) {
                  if (option['page_name']!.isEmpty) return null;
                  return PopupMenuItem<String>(
                    value: option['page_name'],
                    child: Text(
                      option['page_name']!,
                      style: TextStyle(
                        color: option['page_name'] == selectedOption
                            ? Colors.deepPurple
                            : Colors.grey.shade700,
                        fontFamily: "poppins_thin",
                        fontSize: 13,
                      ),
                    ),
                  );
                }).whereType<PopupMenuItem<String>>().toList(),
                onSelected: (String value) {
                  setState(() {
                    selectedOption = value;
                    final selectedItem = dropdownData.firstWhere(
                          (item) => item['page_name'] == value,
                      orElse: () => {"page_id": "", "page_name": ""},
                    );
                    selectedPageId = selectedItem['page_id'];
                    print('Selected Page ID: $selectedPageId'); // For debugging
                  });
                  if (selectedPageId != null && selectedPageId!.isNotEmpty) {
                    _fetchReportsForPageId(selectedPageId!);
                  }
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Container(
            color: Colors.grey[100],
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Show shimmer effect while loading lead reports
                if (provider.isLeadRpLoading) {
                  return _buildShimmerEffect(constraints);
                }
                // After loading, check if lead reports data is null
                else if (provider.leadReportsData == null) {
                  return const Center(child: Text('No data available'));
                }
                // If data is available, display the content
                else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Campaign Performance',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "poppins_thin",
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCampaignTable(
                                      constraints, provider.leadReportsData!.campaignReport),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Swipe to see more →',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.swipe, size: 16, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: 4,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lead Statistics',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "poppins_thin",
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildLeadStatsTable(
                                      constraints, provider.leadReportsData!.leadReport),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect(BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowHeight: 48,
                          dataRowHeight: 48,
                          columns: List.generate(
                            7,
                                (index) => DataColumn(
                              label: Container(
                                width: 80,
                                height: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          rows: List.generate(
                            7, // Simulate 7 rows for shimmer (including Unspecified and Total)
                                (index) => DataRow(
                              cells: List.generate(
                                7,
                                    (index) => DataCell(
                                  Container(
                                    width: 80,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowHeight: 48,
                          dataRowHeight: 48,
                          columns: List.generate(
                            5,
                                (index) => DataColumn(
                              label: Container(
                                width: 80,
                                height: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          rows: List.generate(
                            5, // Simulate 5 rows for shimmer
                                (index) => DataRow(
                              cells: List.generate(
                                5,
                                    (index) => DataCell(
                                  Container(
                                    width: 80,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignTable(BoxConstraints constraints, CampaignReport campaignReport) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: "poppins_thin",
          fontSize: 13,
        ),
        headingTextStyle: TextStyle(
          color: Colors.deepPurple,
          fontFamily: "poppins_thin",
          fontSize: 13.1,
        ),
        columnSpacing: 20,
        headingRowHeight: 48,
        dataRowHeight: 48,
        headingRowColor: MaterialStateProperty.all(Colors.deepPurple[50]),
        border: TableBorder.all(
          color: Colors.grey[300]!,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        columns: const [
          DataColumn(label: Text('Campaign')),
          DataColumn(label: Text('AD Sets')),
          DataColumn(label: Text('AD Name')),
          DataColumn(label: Text('Inquiry')),
          DataColumn(label: Text('Lead')),
          DataColumn(label: Text('Visits')),
          DataColumn(label: Text('Booking')),
        ],
        rows: [
          ...campaignReport.campaigns.expand((campaign) {
            List<DataRow> rows = [];

            campaign.ads.asMap().forEach((index, ad) {
              rows.add(
                DataRow(
                  cells: [
                    DataCell(
                      index == 0
                          ? ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          campaign.campaignName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          ad.adsetName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          ad.adName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(ad.inquiryCount)),
                    DataCell(Text(ad.leadCount)),
                    DataCell(Text(ad.inquiryVisitsCount)),
                    DataCell(Text(ad.inquiryBookingCount)),
                  ],
                ),
              );
            });

            rows.add(
              DataRow(
                color: MaterialStateProperty.all(Colors.grey[100]),
                cells: [
                  DataCell(Text('Total', style: const TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(SizedBox.shrink()),
                  const DataCell(SizedBox.shrink()),
                  DataCell(Text(campaign.totalInquiry.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(campaign.totalLead.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(campaign.totalVisit.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(campaign.totalBooking.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            );

            return rows;
          }).toList(),
          // Add Unspecified row
          DataRow(
            color: MaterialStateProperty.all(Colors.red[50]),
            cells: [
              DataCell(Text('Unspecified', style: const TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              DataCell(Text(campaignReport.totals.faildInquiryCount.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.faildLeadCount.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.faildVisitCount.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.faildBookingCount.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          // Add Total row
          DataRow(
            color: MaterialStateProperty.all(Colors.green[50]),
            cells: [
              DataCell(Text('Total', style: const TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(SizedBox.shrink()),
              const DataCell(SizedBox.shrink()),
              DataCell(Text(campaignReport.totals.finalTotalInquiry.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.finalTotalLead.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.finalTotalVisit.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(campaignReport.totals.finalTotalBooking.toString() ?? '0',
                  style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadStatsTable(BoxConstraints constraints, LeadReport leadReport) {
    // Step 1: Extract unique product names (e.g., BEH, STV, ANB, etc.) from the data
    final List<String> productNames = leadReport.data
        .expand((datum) => datum.products.keys)
        .toSet()
        .toList();

    // Step 2: Define the columns dynamically
    final List<DataColumn> columns = [
      const DataColumn(label: Text('Month')),
      ...productNames.map((productName) => DataColumn(label: Text(productName))),
      const DataColumn(label: Text('Total')),
    ];

    // Step 3: Build the rows dynamically using data directly
    final List<DataRow> rows = leadReport.data.map((stats) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>((states) {
          if (stats.timePeriod == 'This Week' || stats.timePeriod == 'Today') {
            return Colors.green[50];
          }
          return null;
        }),
        cells: [
          DataCell(Text(stats.timePeriod)),
          // For each product name, get the corresponding value from products map
          ...productNames.map((productName) {
            final value = stats.products[productName] ?? '0';
            return DataCell(Text(value.toString()));
          }),
          DataCell(Text(stats.total.toString())),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: "poppins_thin",
          fontSize: 13,
        ),
        headingTextStyle: const TextStyle(
          color: Colors.deepPurple,
          fontFamily: "poppins_thin",
          fontSize: 13.1,
        ),
        columnSpacing: 20,
        headingRowHeight: 48,
        headingRowColor: MaterialStateProperty.all(Colors.deepPurple[50]),
        border: TableBorder.all(
          color: Colors.grey[300]!,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        columns: columns,
        rows: rows,
      ),
    );
  }
}