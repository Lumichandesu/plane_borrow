import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plane_borrow/pages/Loginpage.dart';

class Listplanelecture extends StatefulWidget {
  const Listplanelecture({super.key});

  @override
  _ListplanelectureState createState() => _ListplanelectureState();
}

class _ListplanelectureState extends State<Listplanelecture> {
  List<dynamic> planes = []; // To hold the fetched plane data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanes();
  }

  // Fetch planes from the server
  Future<void> _fetchPlanes() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/plane')); // Your server URL
      if (response.statusCode == 200) {
        // If server returns a 200 OK response, parse the JSON
        setState(() {
          planes =
              jsonDecode(response.body); // Update planes with the fetched data
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
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main Content
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.only(top: 100),
              children: [
                // Container with the plane list and logout button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Plane List Header with Logout Button
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
                            icon: const Icon(Icons.logout,
                                color: Colors.black, size: 30),
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
                      // Show loading indicator while fetching data
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

  // Plane card builder
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

    // Only wrap with InkWell if plane is available or pending
    return InkWell(
      onTap: isAvailable || isPending
          ? () {
              // Navigate to plane detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaneDetailPage(
                    imagePath: imagePath,
                    planeName: planeName,
                    seat: seat,
                    tailNumber: tailNumber,
                    planeDescription: planeDescription,
                    isPending:
                        isPending, // Pass the pending status to detail page
                  ),
                ),
              );
            }
          : null, // Make the plane card non-clickable if unavailable
      child: cardContent,
    );
  }
}

class PlaneDetailPage extends StatefulWidget {
  final String imagePath;
  final String planeName;
  final String seat;
  final String tailNumber;
  final String planeDescription;
  final bool isPending; // Add isPending to handle Pending status

  const PlaneDetailPage({
    super.key,
    required this.imagePath,
    required this.planeName,
    required this.seat,
    required this.tailNumber,
    required this.planeDescription,
    required this.isPending, // Add this parameter
  });

  @override
  _PlaneDetailPageState createState() => _PlaneDetailPageState();
}

class _PlaneDetailPageState extends State<PlaneDetailPage> {
  DateTime? borrowDate;
  DateTime? returnDate;

  Future<void> _selectDate(BuildContext context, bool isBorrowDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
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
          // Background Image (filling the whole screen)
          Positioned.fill(
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable Content
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
                  // Plane Image at the top without a border
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      widget.imagePath,
                      height: 200, // Adjust the height as needed
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Plane title and category
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
                  // Additional plane details (seats, registration)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Seat number
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
                      // Tail number
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
                  // Plane description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.planeDescription,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Pending status message
                  if (widget.isPending)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'This Pending is in Request',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
