import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RequestStudent extends StatefulWidget {
  final String userId;
  const RequestStudent({super.key, required this.userId});

  @override
  _RequestStudentState createState() => _RequestStudentState();
}

class _RequestStudentState extends State<RequestStudent>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;

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
        Uri.parse('http://192.168.1.3:3000/RequestStudent/${widget.userId}'),
      );

      print('User ID for API request: ${widget.userId}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        setState(() {
          requests = jsonResponse.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        print('Failed to load requests: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching requests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchRequest();
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
      print('Error parsing date: $e');
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
                child: Text(
                  ButtonText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ButtonColor,
                  ),
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
