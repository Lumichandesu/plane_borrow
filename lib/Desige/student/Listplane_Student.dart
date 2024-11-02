import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plane_borrow/pages/Loginpage.dart';

class Listplanestudent extends StatelessWidget {
  const Listplanestudent({super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row for Plane List Header and Logout Button
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

                      // Plane Cards
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/Beechcraft Bonanza G36.png',
                        availability: 'Available',
                        planeName: 'CESSNA 172 SKYHAWK',
                      ),
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/CESSANA 172.png',
                        availability: 'Unavailable',
                        planeName: 'N994KD Cirrus SR-22T-GTS',
                      ),
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/Cirrus SR-22T.png',
                        availability: 'Unavailable',
                        planeName: 'Embraer Phenom 300',
                      ),
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/Diamond DA40.png',
                        availability: 'Available',
                        planeName: 'Gulfstream G280',
                      ),
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/Embraer Phonom 300.png',
                        availability: 'Available',
                        planeName: 'Diamond DA40',
                      ),
                      _buildPlaneCard(
                        context: context,
                        imagePath: 'assets/images/Gulfstream G280.png',
                        availability: 'Available',
                        planeName: 'Beechcraft Bonanza G36',
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
  }) {
    bool isAvailable = availability == 'Available';

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
                    : Colors.red,
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

    // Only wrap with InkWell if plane is available
    return isAvailable
        ? InkWell(
            onTap: () {
              // Navigate to a new page with plane details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaneDetailPage(
                    imagePath: imagePath,
                    planeName: planeName,
                  ),
                ),
              );
            },
            child: cardContent,
          )
        : cardContent;
  }
}

class PlaneDetailPage extends StatefulWidget {
  final String imagePath;
  final String planeName;

  const PlaneDetailPage({
    super.key,
    required this.imagePath,
    required this.planeName,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              // Add share logic here
            },
          ),
        ],
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

                  // Container with icon and text for seats and registration
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
                        child: const Row(
                          children: [
                            Icon(Icons.event_seat, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              '4 SEAT',
                              style: TextStyle(color: Colors.grey),
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
                        child: const Row(
                          children: [
                            Icon(Icons.airplanemode_active, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'N72370',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Availability Status
                  const Row(
                    children: [
                      Text(
                        'Borrow Status: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Plane details description
                  const Text(
                    'CESSNA 172 SKYHAWK DETAILS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The Cessna 172 Skyhawk is a popular and reliable four-seater aircraft, perfect for flight training, sightseeing, and general aviation. It features a single piston engine, reaching speeds of up to 140 knots and a range of 640 nautical miles. Comfortable and easy to handle, it\'s ready for rent, providing a smooth and safe flying experience. A valid pilot\'s license and document verification are required for rental.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // Date Borrowing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        borrowDate == null
                            ? 'Select Borrow Date'
                            : 'Borrow Date: ${DateFormat('dd-MM-yyyy').format(borrowDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date Return
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        returnDate == null
                            ? 'Select Return Date'
                            : 'Return Date: ${DateFormat('dd-MM-yyyy').format(returnDate!)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: borrowDate == null
                            ? null
                            : () => _selectDate(context, false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rent Now Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Booking Confirmed'),
                              content: const Text(
                                  'You can check your reservation in the request list.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'RENT NOW',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
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
