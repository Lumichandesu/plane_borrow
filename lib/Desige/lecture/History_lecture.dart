import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryLecture extends StatefulWidget {
  final String userId; // เพิ่มตัวแปร userId

  const HistoryLecture({super.key, required this.userId});

  @override
  State<HistoryLecture> createState() => _HistoryLectureState();
}

class _HistoryLectureState extends State<HistoryLecture> {
  Future<List<HistoryItem>> fetchHistoryItems(String userId) async {
    final response = await http.post(Uri.parse(
        'http://localhost:3000/HistoryStudentByLender/${widget.userId}'));
    print('User ID for API request: ${widget.userId}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => HistoryItem.fromJson(item)).toList();
    } else {
      print('Failed to load history: ${response.statusCode}');
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
            future: fetchHistoryItems(widget.userId),
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
                                approvedBy: item.approvedBy,
                                configuredBy: item.configuredBy,
                                borrowingDate: item.formattedBorrowingDate,
                                returnDate: item.formattedReturnDate,
                                requestBy: item.requestBy,
                                requesterName: item.requesterName,
                                actionButtonText: item.actionButtonText,
                                actionButtonColor: item.actionColor,
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
    required String approvedBy,
    required String configuredBy,
    required String borrowingDate,
    required String returnDate,
    required String requestBy,
    required String requesterName,
    required String actionButtonText,
    required Color actionButtonColor,
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
  final String approvedBy;
  final String requestBy;
  final String requesterName;
  final DateTime borrowingDate;
  final DateTime returnDate;
  final String actionButtonText;
  final String actionButtonColor;

  HistoryItem({
    required this.airplaneImage,
    required this.historyId,
    required this.planeId,
    required this.rqtBy,
    required this.modelName,
    required this.configuredBy,
    required this.staffId,
    required this.approvedBy,
    required this.requestBy,
    required this.requesterName,
    required this.borrowingDate,
    required this.returnDate,
    required this.actionButtonText,
    required this.actionButtonColor,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      airplaneImage: json['image'],
      rqtBy: json['rqtBy'],
      historyId: json['historyId'] ?? 0,
      planeId: json['planeId'] ?? 1,
      modelName: json['planeName']?.toString() ?? '',
      staffId: json['StaffName']?.toString() ?? '',
      approvedBy: json['StaffName']?.toString() ?? '',
      requestBy: json['rqtBy']?.toString() ?? '',
      requesterName: json['rqtByName']?.toString() ?? '',
      configuredBy: json['LenderName']?.toString() ?? '',
      borrowingDate: DateTime.parse(json['bDate']),
      returnDate: DateTime.parse(json['rDate']),
      actionButtonText: json['ApprovedStatus'] == 1 ? 'Approved' : 'Rejected',
      actionButtonColor: json['ApprovedStatus'] == 1 ? 'green' : 'red',
    );
  }

  Color get actionColor {
    return actionButtonColor == 'green' ? Colors.green : Colors.red;
  }

  String get formattedBorrowingDate {
    return DateFormat('yyyy-MM-dd').format(borrowingDate.toLocal());
  }

  String get formattedReturnDate {
    return DateFormat('yyyy-MM-dd').format(returnDate.toLocal());
  }
}
