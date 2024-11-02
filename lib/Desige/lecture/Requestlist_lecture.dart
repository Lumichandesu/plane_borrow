import 'package:flutter/material.dart';

class Requestlistlecture extends StatefulWidget {
  const Requestlistlecture({super.key});

  @override
  State<Requestlistlecture> createState() => _RequestlistlectureState();
}

class _RequestlistlectureState extends State<Requestlistlecture> {
  final List<Request> requests = [
    Request(
      borrower: 'Borrower By',
      plane: 'Beechcraft Bonanza G36',
      requestDate: '21-10-2024', // Request Date
      returnDate: '28-10-2024', // Return Date
      status: 'Pending',
    ),
    Request(
      borrower: 'Borrower By',
      plane: 'Beechcraft Bonanza G36',
      requestDate: '21-10-2024', // Request Date
      returnDate: '28-10-2024', // Return Date
      status: 'Pending',
    ),
  ];

  void _updateRequestStatus(int index, String action) {
    setState(() {
      requests[index].status = action == 'approve' ? 'Approved' : 'Rejected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main Request content
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.only(top: 40),
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Request Status',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          final request = requests[index];
                          if (request.status == 'Pending') {
                            return RequestCard(
                              borrower: request.borrower,
                              plane: request.plane,
                              requestDate: request.requestDate,
                              returnDate: request.returnDate,
                              onApprove: () => _showConfirmationDialog(
                                  context, 'approve', index),
                              onReject: () => _showConfirmationDialog(
                                  context, 'reject', index),
                            );
                          } else {
                            return SuccessfulRequestCard(
                              plane: request.plane,
                              borrower: request.borrower,
                              requestDate: request.requestDate, // Request Date
                              returnDate: request.returnDate, // Return Date
                              status: request.status,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String action, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you really want to $action this request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(action),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _updateRequestStatus(index, action);
              },
            ),
          ],
        );
      },
    );
  }
}

class Request {
  final String borrower;
  final String plane;
  final String requestDate; // Request Date
  final String returnDate; // Return Date
  String status;

  Request({
    required this.borrower,
    required this.plane,
    required this.requestDate,
    required this.returnDate,
    this.status = 'Pending',
  });
}

class RequestCard extends StatelessWidget {
  final String borrower;
  final String plane;
  final String requestDate;
  final String returnDate;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.borrower,
    required this.plane,
    required this.requestDate,
    required this.returnDate,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: const Color.fromARGB(255, 214, 214, 214),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/Beechcraft Bonanza G36.png',
                    height: 80,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    plane,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 5),
                  Text(borrower),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('REQUEST DATE:'),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              requestDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15), // เพิ่มขนาดเว้นระยะ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RETURN DATE:'),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              returnDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onApprove,
                    child: const Text('Approve',
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: onReject,
                    child: const Text('Reject',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessfulRequestCard extends StatelessWidget {
  final String plane;
  final String borrower;
  final String requestDate; // Request Date
  final String returnDate; // Return Date
  final String status;

  const SuccessfulRequestCard({
    super.key,
    required this.plane,
    required this.borrower,
    required this.requestDate,
    required this.returnDate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: const Color.fromARGB(255, 214, 214, 214),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/Beechcraft Bonanza G36.png',
                    height: 80,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    plane,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 5),
                  Text(borrower),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('REQUEST DATE:'),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              requestDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15), // เพิ่มขนาดเว้นระยะ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RETURN DATE:'),
                        Container(
                          width: 200,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              returnDate,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Approved' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Centered text size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
