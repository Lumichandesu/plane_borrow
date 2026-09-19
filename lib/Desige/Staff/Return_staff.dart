import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReturnStaff extends StatefulWidget {
  const ReturnStaff({super.key});

  @override
  State<ReturnStaff> createState() => _ReturnStaffState();
}

class _ReturnStaffState extends State<ReturnStaff> {
  List<Map<String, dynamic>> returnStatusData = [];
  @override
  void initState() {
    super.initState();
    fetchReturnItems(); // Fetch data on initialization
  }

  Future<List<ReturnItem>> fetchReturnItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/Returnplane'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => ReturnItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
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
          FutureBuilder<List<ReturnItem>>(
            future: fetchReturnItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
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
                                'RETURN',
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
                              ReturnItem item = snapshot.data![index];
                              return _buildReturnCard(
                                  context: context,
                                  airplaneImage: item.airplaneImage,
                                  modelName: item.modelName,
                                  staffName: item.staffId,
                                  configuredBy: item.configuredBy,
                                  borrowingDate: item.formattedBorrowingDate,
                                  returnDate: item.formattedReturnDate,
                                  requestBy: item.requestBy,
                                  requesterName: item.requesterName,
                                  rqtBy: item.rqtBy,
                                  ReturnStatus: item.ReturnStatus,
                                  planeID: item.planeId);
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
}

Widget _buildReturnCard({
  required BuildContext context,
  required String airplaneImage,
  required String modelName,
  required String staffName,
  required String configuredBy,
  required String borrowingDate,
  required String returnDate,
  required String requestBy,
  required String requesterName,
  required int rqtBy,
  required String ReturnStatus,
  required int planeID,
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: ReturnStatus == "1" || ReturnStatus == 1
                      ? null
                      : () {
                          showConfirmationDialog(
                            context: context,
                            title: 'Confirm Return',
                            content:
                                'Are you sure you want to return this plane?',
                            onConfirm: () {
                              updateReturnStatus(
                                  context, rqtBy, planeID); // ใช้ rqtBy
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Return'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> updateReturnStatus(
    BuildContext context, int rqtBy, int planeID) async {
  try {
    final response = await http.put(
      Uri.parse('http://localhost:3000/UpdateReturnStatus/$rqtBy'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'status': 1, // อัปเดต ReturnStaus เป็น 1
        'planeID': planeID // ระบุ planeID ที่ต้องการอัปเดต
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update!')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // ปิด Dialog
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // ปิด Dialog
              onConfirm(); // เรียกฟังก์ชัน onConfirm
            },
          ),
        ],
      );
    },
  );
}

class ReturnItem {
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
  final int id;
  final String planeName;
  final String ReturnStatus;

  ReturnItem(
      {required this.airplaneImage,
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
      required this.id,
      required this.planeName,
      required this.ReturnStatus});

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      airplaneImage: json['image'] ?? 'default_image.jpg',
      rqtBy: json['rqtBy'] ?? 0, // ใช้ 0 หากค่าใน json เป็น null
      historyId: json['historyId'] ?? 0,
      planeId: json['planeId'] ?? 0,
      modelName: json['planeName']?.toString() ?? 'Unknown Model',
      staffId: json['StaffName']?.toString() ?? 'N/A',
      requestBy: json['rqtBy']?.toString() ?? '',
      requesterName: json['rqtByName']?.toString() ?? 'Unknown',
      configuredBy: json['LenderName']?.toString() ?? 'Unknown',
      borrowingDate: json['bDate'] != null
          ? DateTime.tryParse(json['bDate']) ?? DateTime.now()
          : DateTime.now(),
      returnDate: json['rDate'] != null
          ? DateTime.tryParse(json['rDate']) ?? DateTime.now()
          : DateTime.now(),
      id: json['id'] ?? 0, // ตรวจสอบค่าที่เป็น null
      planeName: json['planeName'] ?? 'Unknown',
      ReturnStatus: json['ReturnStaus']?.toString() ?? 'N/A',
    );
  }
  String get formattedBorrowingDate {
    return DateFormat('yyyy-MM-dd').format(borrowingDate.toLocal());
  }

  String get formattedReturnDate {
    return DateFormat('yyyy-MM-dd').format(returnDate.toLocal());
  }
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
