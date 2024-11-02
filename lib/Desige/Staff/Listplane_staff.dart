import 'package:flutter/material.dart';
import 'AddPlane.dart';
import 'Editplane.dart';
import 'package:plane_borrow/pages/Loginpage.dart';

class ListplaneStaff extends StatefulWidget {
  const ListplaneStaff({super.key});

  @override
  State<ListplaneStaff> createState() => _ListPlaneState();
}

final List<Map<String, dynamic>> plane = [
  {
    'ID': '001',
    'name': 'CESSNA 172 SKYHAWK',
    'category': 'General Aviation',
    'seat': '4 seat',
    'aircraft': 'N72370',
    'TitleName': 'CESSNA 172 SKYHAWK detail',
    'description': 'The Cessna 172 Skyhawk is a popular and reliable...',
    'Image': 'assets/images/CESSANA 172.png',
    'availability': 'Available'
  },
  {
    'ID': '002',
    'name': 'Cirrus SR-22T-GTS',
    'category': 'Single-engine',
    'seat': '4-5 seat',
    'aircraft': 'N994KD',
    'TitleName': 'N994KD Cirrus SR-22T-GTS detail',
    'description': 'The Cirrus SR22T-GTS (N994KD) is a sleek, turbocharged...',
    'Image': 'assets/images/Cirrus SR-22T.png',
    'availability': 'Unavailable'
  },
  {
    'ID': '003',
    'name': 'Embraer Phenom 300',
    'category': 'Light Jet',
    'seat': '6-9 seat',
    'aircraft': 'N300EM',
    'TitleName': 'Embraer Phenom 300 detail',
    'description': 'The Embraer Phenom 300 is a fast, luxurious light jet...',
    'Image': 'assets/images/Embraer Phonom 300.png',
    'availability': 'Unavailable'
  },
  {
    'ID': '004',
    'name': 'Gulftstream G280',
    'category': 'Super-midsize Jet',
    'seat': '10 seat',
    'aircraft': 'N280GX',
    'TitleName': 'Gulftstream G280 detail',
    'description':
        'The Gulfstream G280 is a fast, long-range business jet with room for up to 10 passengers, known for its luxury, efficiency, and transcontinental reach.',
    'Image': 'assets/images/Gulfstream G280.png',
    'availability': 'Available'
  },
  {
    'ID': '005',
    'name': 'Diamond DA40',
    'category': 'Single-engine light aircraft',
    'seat': '4 seat',
    'aircraft': 'N123DA',
    'TitleName': 'Diamond DA40 detail',
    'description':
        'The Diamond DA40 is a modern, single-engine, four-seat aircraft known for its safety, fuel efficiency, and advanced avionics, making it a popular choice for flight training and personal travel.',
    'Image': 'assets/images/Diamond DA40.png',
    'availability': 'Available'
  },
  {
    'ID': '006',
    'name': 'Beechcraft Bonanza G36',
    'category': ' Single-engine light aircraft',
    'seat': '6 seat',
    'aircraft': 'N123BG',
    'TitleName': 'Beechcraft Bonanza G36 detail',
    'description':
        'The Beechcraft Bonanza G36 is a powerful, single-engine, six-seat aircraft known for its luxury, reliability, and long range, making it ideal for both business and personal travel.',
    'Image': 'assets/images/Beechcraft Bonanza G36.png',
    'availability': 'Available'
  },
];

class _ListPlaneState extends State<ListplaneStaff> {
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
                      // Header section with PLANE LIST title and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Add Plane Icon
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
                          // PLANE LIST Title
                          const Text(
                            'PLANE LIST',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // Logout button
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

                      // Generate cards from the plane list
                      ...plane.map((planeData) => _buildPlaneCard(
                            context: context,
                            imagePath: planeData['Image'],
                            availability: planeData['availability'],
                            planeName: planeData['name'],
                          )),
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
  }) {
    bool isAvailable = availability == 'Available';

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
                color: isAvailable
                    ? const Color.fromARGB(255, 5, 184, 34)
                    : Colors.red,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Editplane(
                                plane: {}, // Pass the necessary plane data
                              )),
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
