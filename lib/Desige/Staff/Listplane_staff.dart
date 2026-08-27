import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AddPlane.dart';
import 'package:plane_borrow/pages/Loginpage.dart';
import 'EditPlane.dart';

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
      final response =
          await http.get(Uri.parse('http://192.168.1.5:3000/plane'));
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

  Future<void> _confirmAndDeletePlane(
      BuildContext context, String planeId) async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plane'),
          content: const Text('Do you want to delete?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final response = await http.delete(
          Uri.parse('http://192.168.1.5:3000/plane/$planeId'),
        );

        if (response.statusCode == 200) {
          setState(() {
            planes
                .removeWhere((plane) => plane['planeID'] == int.parse(planeId));
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delete plane Completed')),
          );
        } else if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plane not found')),
          );
        } else {
          final errorMessage = jsonDecode(response.body)['message'] ?? 'Error';
          throw Exception('Please try again: $errorMessage');
        }
      } catch (e) {
        print('Error deleting plane: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
                                  imagePath: plane['image'] != null
                                      ? 'assets/images/${plane['image']}'
                                      : 'assets/images/airplane.jpg',
                                  availability: plane['status'] == 1
                                      ? 'Available'
                                      : plane['status'] == 0
                                          ? 'Unavailable'
                                          : 'Pending',
                                  planeName: plane['planeName'] ?? 'Unknown',
                                  planeTitle: plane['planeTitle'] ?? 'Unknown',
                                  planeDescription:
                                      plane['planeDescription'] ?? '',
                                  category: plane['category'] ?? '',
                                  seat: plane['seat']?.toString() ?? 'N/A',
                                  tailNumber: plane['tailNumber'] ?? 'N/A',
                                  planeId: plane['planeID'].toString(),
                                  currentImage:
                                      plane['currentImage'] ?? 'airplane.jpg',
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
    required String currentImage,
    required String availability,
    required String planeName,
    required String planeTitle,
    required String planeDescription,
    required String category,
    required String seat,
    required String tailNumber,
    required String planeId,
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
                    ? const Color.fromARGB(255, 5, 184, 34)
                    : availability == 'Unavailable'
                        ? Colors.red
                        : Colors.orange,
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final isUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPlane(
                              planeId: planeId,
                              currentImage: currentImage,
                              planeData: {
                                'planeName': planeName,
                                'planeTitle': planeTitle,
                                'planeDescription': planeDescription,
                                'category': category,
                                'seat': seat,
                                'tailNumber': tailNumber,
                                'status': availability == 'Available' ? 1 : 0,
                              },
                            ),
                          ),
                        );

                        if (isUpdated == true) {
                          _fetchPlanes(); // Refresh the plane list
                        }
                      },
                      child: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _confirmAndDeletePlane(context, planeId),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
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
