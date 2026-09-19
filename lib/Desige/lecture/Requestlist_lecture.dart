import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RequestLecture extends StatefulWidget {
  const RequestLecture({super.key});

  @override
  _RequestLectureState createState() => _RequestLectureState();
}

class _RequestLectureState extends State<RequestLecture>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fetchRequest();
  }

  Future<void> _fetchRequest() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.3:3000/RequestLecture'),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Log สำหรับตรวจสอบข้อมูล
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          setState(() {
            requests =
                jsonResponse.cast<Map<String, dynamic>>().where((request) {
              return request['rqtStatus'] == null || request['rqtStatus'] == 0;
            }).toList();
          });
        } else {
          setState(() {
            requests = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: const Text('No requests available.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch requests: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching requests: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchRequest();
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String content,
      {bool isWarning = true}) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isWarning ? Icons.error_outline : Icons.check_circle,
                    color: isWarning ? Colors.orange : Colors.green,
                    size: 50, // ขนาดของไอคอน
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // ยกเลิก
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // ยืนยัน
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        ) ??
        false; // หากผู้ใช้ปิด dialog โดยไม่เลือกอะไรให้ถือว่า false
  }

  Future<void> _updateRequestStatus(int requestID, int rqtStatus) async {
    setState(() {
      isProcessing = true;
    });

    print('Sending request to update request status');
    print('requestID: $requestID, rqtStatus: $rqtStatus'); // Debug log

    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.3:3000/UpdateRequestStatus'),
        body: json.encode({
          'requestID': requestID,
          'rqtStatus': rqtStatus,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // ลบคำขอที่ได้รับการอนุมัติหรือปฏิเสธออกจากรายการทันที
        setState(() {
          requests.removeWhere((request) => request['requestID'] == requestID);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                const SizedBox(width: 10),
                Text(rqtStatus == 1 ? 'Request approved' : 'Request rejected'),
              ],
            ),
          ),
        );
      } else {
        print(
            'Failed to update request status. Response code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update request status: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      print('Error updating request status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Error updating request status')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: const DecorationImage(
                    image: const AssetImage('assets/images/airplane.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03,
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Center(
                            child: Text(
                              'REQUEST STATUS',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.04,
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
                          padding: const EdgeInsets.only(top: 16),
                          itemCount: requests.isEmpty ? 1 : requests.length,
                          itemBuilder: (context, index) {
                            if (requests.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                  child: const Text(
                                    'No requests available.',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),
                              );
                            }
                            final request = requests[index];
                            final requestID = request['requestID'] ?? 0;

                            return _buildHistoryCard(
                              context: context,
                              airplaneImage:
                                  request['planeImage'] ?? 'default_image.png',
                              modelName:
                                  request['planeName'] ?? 'Unknown Model',
                              requesterName: request['requestName'] ?? 'N/A',
                              requestDate:
                                  _formatDate(request['bDate'] ?? 'N/A'),
                              returnDate:
                                  _formatDate(request['rDate'] ?? 'N/A'),
                              ButtonText: request['rqtStatus'] == null
                                  ? 'Pending'
                                  : (request['rqtStatus'] == 1
                                      ? 'Approved'
                                      : 'Rejected'),
                              ButtonColor: request['rqtStatus'] == null
                                  ? Colors.orange
                                  : (request['rqtStatus'] == 1
                                      ? Colors.green
                                      : Colors.red),
                              requestID: requestID,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date).toLocal();
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String airplaneImage,
    required String modelName,
    required String requesterName,
    required String requestDate,
    required String returnDate,
    required String ButtonText,
    required Color ButtonColor,
    required int requestID,
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
                  Image.asset(
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
              const Text(
                'Borrower:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(requesterName),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateColumn('REQUEST DATE', requestDate),
                  _buildDateColumn('RETURN DATE', returnDate),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: !isProcessing &&
                              ButtonText != 'Approved' &&
                              ButtonText != 'Rejected'
                          ? () async {
                              final shouldProceed = await _showConfirmationDialog(
                                  context,
                                  'Confirm Approval',
                                  'Are you sure you want to approve this request?');

                              if (shouldProceed) {
                                setState(() => isProcessing = true);
                                await _updateRequestStatus(
                                    requestID, 1); // Approve
                                setState(() => isProcessing = false);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Approve',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: !isProcessing &&
                              ButtonText != 'Approved' &&
                              ButtonText != 'Rejected'
                          ? () async {
                              final shouldProceed = await _showConfirmationDialog(
                                  context,
                                  'Confirm Rejection',
                                  'Are you sure you want to reject this request?');

                              if (shouldProceed) {
                                setState(() => isProcessing = true);
                                await _updateRequestStatus(
                                    requestID, 0); // Reject
                                setState(() => isProcessing = false);
                              }
                            }
                          : null,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
