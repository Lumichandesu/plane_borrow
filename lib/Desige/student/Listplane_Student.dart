import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plane_borrow/pages/Loginpage.dart';

class ListplaneStudent extends StatefulWidget {
  const ListplaneStudent({super.key});

  @override
  _ListplaneStudentState createState() => _ListplaneStudentState();
}

class _ListplaneStudentState extends State<ListplaneStudent> {
  List<dynamic> planes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
  }

  Future<void> _fetchPlanes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/plane'));
      if (response.statusCode == 200) {
        setState(() {
          planes = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load planes');
      }
    } catch (e) {
      print('Error fetching planes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.only(top: 100),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PLANE LIST',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.black, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Loginpage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                              children: planes.map((plane) {
                                return _buildPlaneCard(
                                  context: context,
                                  imagePath: 'assets/images/${plane['image']}',
                                  availability: plane['status'] == 1
                                      ? 'Available'
                                      : plane['status'] == 0
                                          ? 'Unavailable'
                                          : 'Pending',
                                  planeName: plane['planeName'],
                                  seat: plane['seat'].toString(),
                                  tailNumber: plane['tailNumber'],
                                  planeDescription: plane['planeDescription'],
                                );
                              }).toList(),
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

  Widget _buildPlaneCard({
    required BuildContext context,
    required String imagePath,
    required String availability,
    required String planeName,
    required String seat,
    required String tailNumber,
    required String planeDescription,
  }) {
    bool isAvailable = availability == 'Available';
    bool isPending = availability == 'Pending';

    Widget cardContent = Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              availability,
              style: TextStyle(
                color: isAvailable
                    ? const Color.fromARGB(255, 5, 184, 34)
                    : (isPending ? Colors.orange : Colors.red),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              planeName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: isAvailable || isPending
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaneDetailStudentPage(
                    imagePath: imagePath,
                    planeName: planeName,
                    seat: seat,
                    tailNumber: tailNumber,
                    planeDescription: planeDescription,
                    isPending: isPending,
                  ),
                ),
              );
            }
          : null,
      child: cardContent,
    );
  }
}

class PlaneDetailStudentPage extends StatefulWidget {
  final String imagePath;
  final String planeName;
  final String seat;
  final String tailNumber;
  final String planeDescription;
  final bool isPending;

  const PlaneDetailStudentPage({
    super.key,
    required this.imagePath,
    required this.planeName,
    required this.seat,
    required this.tailNumber,
    required this.planeDescription,
    required this.isPending,
  });

  @override
  _PlaneDetailStudentPageState createState() => _PlaneDetailStudentPageState();
}

class _PlaneDetailStudentPageState extends State<PlaneDetailStudentPage> {
  DateTime? borrowDate;
  DateTime? returnDate;

  Future<void> _selectDate(BuildContext context, bool isBorrowDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isBorrowDate
          ? DateTime.now()
          : borrowDate!.add(const Duration(days: 1)),
      firstDate: isBorrowDate
          ? DateTime.now()
          : borrowDate!.add(const Duration(days: 1)),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        if (isBorrowDate) {
          borrowDate = pickedDate;
          returnDate = null;
        } else {
          returnDate = pickedDate;
        }
      });
    }
  }

  void dummyRentFunction() {
    print("RENT NOW clicked!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.imagePath,
                      height: 200,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.planeName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'General Aviation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.event_seat, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              widget.seat,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.airplanemode_active, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              widget.tailNumber,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      widget.planeDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!widget.isPending)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Select Borrow Date'),
                            IconButton(
                              onPressed: () => _selectDate(context, true),
                              icon: const Icon(Icons.calendar_today, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Select Return Date'),
                            IconButton(
                              onPressed: borrowDate == null
                                  ? null
                                  : () => _selectDate(context, false),
                              icon: const Icon(Icons.calendar_today, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: (borrowDate != null && returnDate != null)
                              ? dummyRentFunction
                              : null,
                          child: const Text('RENT NOW'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
