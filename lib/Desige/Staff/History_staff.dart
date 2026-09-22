import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plane_borrow/api_config.dart';

class HistoryStaff extends StatefulWidget {
  final String? userId;
  const HistoryStaff({
    super.key,
    this.userId,
  });

  @override
  State<HistoryStaff> createState() => _HistoryStaffState();
}

class _HistoryStaffState extends State<HistoryStaff> {
  Future<List<HistoryItem>> fetchHistoryItems() async {
    final response =
        await http.post(Uri.parse('${ApiConfig.baseUrl}/HistoryStaff'));

    if (response.statusCode == 200) {
      // Parse the response body as a Map
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Extract the list from the 'data' field
      List<dynamic> historyItems = jsonResponse['data'];

      // Convert the list to a list of HistoryItem objects
      return historyItems.map((item) => HistoryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<HistoryItem>>(
            future: fetchHistoryItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No history available'));
              } else {
                return ListView(
                  padding: EdgeInsets.only(top: screenHeight * 0.1),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.03,
                        horizontal: screenWidth * 0.04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                'HISTORY',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              HistoryItem item = snapshot.data![index];
                              return _buildHistoryCard(
                                context: context,
                                airplaneImage: item.airplaneImage,
                                modelName: item.modelName,
                                staffName: item.staffId,
                                configuredBy: item.configuredBy,
                                borrowingDate: item.formattedBorrowingDate,
                                returnDate: item.formattedReturnDate,
                                requestBy: item.requestBy,
                                requesterName: item.requesterName,
                                actionButtonText: item.actionButtonText,
                                actionButtonColor: item.actionColor,
                                actionButtonText2: item.actionButtonText2,
                                actionButtonColor2: item.actionColor2,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String airplaneImage,
    required String modelName,
    required String staffName,
    required String configuredBy,
    required String borrowingDate,
    required String returnDate,
    required String requestBy,
    required String requesterName,
    required String actionButtonText,
    required Color actionButtonColor,
    required String actionButtonText2,
    required Color actionButtonColor2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  airplaneImage.startsWith('http')
                      ? Image.network(
                          airplaneImage,
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/$airplaneImage',
                          width: 120,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      modelName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildInfoRow(
                            Icons.verified_user, 'Approved by', configuredBy),
                        _buildInfoRow(Icons.person, 'Staff', staffName),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Borrower:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(requesterName),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateColumn('BORROWING DATE', borrowingDate),
                  _buildDateColumn('RETURN DATE', returnDate),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // จัดกลางในแนวนอน
                children: [
                  // ข้อความแรก
                  Center(
                    child: Text(
                      actionButtonText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: actionButtonColor,
                      ),
                    ),
                  ),

                  // ข้อความที่สอง
                  const SizedBox(width: 10), // ระยะห่างระหว่างข้อความทั้งสอง
                  Center(
                    child: Text(
                      actionButtonText2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: actionButtonColor2,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class HistoryItem {
  final String airplaneImage;
  final int historyId;
  final int rqtBy;
  final int planeId;
  final String modelName;
  final String configuredBy;
  final String staffId;
  final String requestBy;
  final String requesterName;
  final DateTime borrowingDate;
  final DateTime returnDate;
  final String actionButtonText;
  final String actionButtonColor;
  final String actionButtonText2;
  final String actionButtonColor2;

  HistoryItem({
    required this.airplaneImage,
    required this.historyId,
    required this.planeId,
    required this.rqtBy,
    required this.modelName,
    required this.configuredBy,
    required this.staffId,
    required this.requestBy,
    required this.requesterName,
    required this.borrowingDate,
    required this.returnDate,
    required this.actionButtonText,
    required this.actionButtonColor,
    required this.actionButtonText2,
    required this.actionButtonColor2,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      airplaneImage:
          json['image'] ?? 'default_image.jpg', // default image if null
      rqtBy: json['rqtBy'] ?? 0, // default to 0 if null
      historyId: json['historyId'] ?? 0, // default to 0 if null
      planeId: json['planeId'] ?? 0, // default to 0 if null
      modelName: json['planeName']?.toString() ??
          'Unknown Model', // fallback to 'Unknown Model'
      staffId: json['StaffName']?.toString() ?? 'N/A', // fallback to 'N/A'
      requestBy: json['rqtBy']?.toString() ?? '', // empty string if null
      requesterName:
          json['rqtByName']?.toString() ?? 'Unknown', // fallback to 'Unknown'
      configuredBy:
          json['LenderName']?.toString() ?? 'Unknown', // fallback to 'Unknown'
      borrowingDate: json['bDate'] != null
          ? DateTime.tryParse(json['bDate']) ??
              DateTime.now() // default to current date if invalid or null
          : DateTime.now(), // fallback to current date if null
      returnDate: json['rDate'] != null
          ? DateTime.tryParse(json['rDate']) ??
              DateTime.now() // default to current date if invalid or null
          : DateTime.now(), // fallback to current date if null
      actionButtonText: json['ApprovedStatus'] == 1
          ? 'Approved'
          : json['ApprovedStatus'] == 0
              ? 'Rejected'
              : 'Pending', // if null, set as 'Pending'
      actionButtonColor: json['ApprovedStatus'] == 1
          ? 'green'
          : json['ApprovedStatus'] == 0
              ? 'red'
              : 'orange', // if null, set as 'yellow'
      actionButtonText2: json['ReturnStaus'] == 1
          ? 'Return'
          : 'Not Return', // fallback if null
      actionButtonColor2:
          json['ReturnStaus'] == 1 ? 'green' : 'red', // fallback if null
    );
  }

  Color get actionColor {
    if (actionButtonColor == 'green') {
      return Colors.green;
    } else if (actionButtonColor == 'orange') {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color get actionColor2 {
    return actionButtonColor2 == 'green' ? Colors.green : Colors.red;
  }

  String get formattedBorrowingDate {
    return DateFormat('yyyy-MM-dd').format(borrowingDate.toLocal());
  }

  String get formattedReturnDate {
    return DateFormat('yyyy-MM-dd').format(returnDate.toLocal());
  }
}
