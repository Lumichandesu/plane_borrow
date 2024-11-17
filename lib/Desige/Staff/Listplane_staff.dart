import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AddPlane.dart';
import 'package:plane_borrow/pages/Loginpage.dart';
import 'EditPlane.dart';  // Make sure the path is correct

class ListplaneStaff extends StatefulWidget {
  const ListplaneStaff({super.key});

  @override
  State<ListplaneStaff> createState() => _ListPlaneState();
}

class _ListPlaneState extends State<ListplaneStaff> {
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddPlane(),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
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
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    color: const Color(0xFFC8C8C8),
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
              color: availability == 'Available'
                  ? const Color.fromARGB(255, 5, 184, 34)  // Green for available
                  : availability == 'Unavailable'
                      ? Colors.red  // Red for unavailable
                      : Colors.orange,  // Orange for pending
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planeName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Seats: $seat',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditPlane(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/editing.png',
                  height: 30,
                  width: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
}
