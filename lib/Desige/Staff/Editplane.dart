import 'package:flutter/material.dart';
import 'AddPlane.dart';

class Editplane extends StatefulWidget {
  final Map<String, dynamic> plane; // รับข้อมูล plane เป็น parameter
  const Editplane({super.key, required this.plane});

  // Add other planes similarly

  @override
  State<Editplane> createState() => _Editplane();
}

class _Editplane extends State<Editplane> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Declare a variable to hold the toggle switch state
  void _showChangeAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  color: Colors.orange, size: 80), // Larger icon
              SizedBox(height: 8),
              Text(
                'Confirm Change',
                style: TextStyle(fontSize: 20), // Larger title text
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to make this change?',
            textAlign: TextAlign.center, // Center the content text
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _showCompletionAlert();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCompletionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.task_alt,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Change Complete',
                style: TextStyle(fontSize: 20), // Larger title text
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const Text('Your change has been successfully completed.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool isSwitched = false;
  bool _isEditing = false;
  String seatText = "4 SEAT";
  String planeText = "N7230";
  bool isEditingSeat = false;
  bool isEditingPlane = false; // ตัวแปรควบคุมโหมดการแก้ไข
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
          // Add button using GestureDetector
          Positioned(
            top: 30,
            left: 16,
            child: GestureDetector(
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
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // Logout button
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ),
          // Scrollable area with both boxes
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 180),
              child: Column(
                children: [
                  // Box 1 (CESSNA 127 and SKYHAWK)
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'CESSANA 172', // แสดง TitleName
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Opacity(
                              opacity: 1,
                              child: Image.asset(
                                'assets/images/editing.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 0),
                        // const Text(
                        //   '    SKYHAWK',
                        //   style: TextStyle(
                        //     fontSize: 25,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // Stack to overlay the image between Box 1 and Box 2
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Box 2 (Additional Information)
                      Transform.translate(
                        offset: const Offset(0, -50),
                        child: Container(
                          width: double.infinity,
                          height: 1000,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 700),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: _showChangeAlert,
                                  child: const Text(
                                    'SAVE CHANGES',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Image positioned between the two boxes
                      Positioned(
                        top:
                            -160, // Adjust the position to overlay between Box 1 and Box 2
                        left: 120,
                        right: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/CESSANA 172.png', // Replace with your image
                            height: 260,
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Category button and add icon
                      Positioned(
                        top: 50, // Adjust to place under the image
                        left: 30, // Align to the left
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side:
                                          const BorderSide(color: Colors.black),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'General Aviation',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 11),
                                  ),
                                ),
                                const SizedBox(width: 0),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.black, size: 30),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Borrow Status Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Align elements
                              children: [
                                const Text(
                                  'BORROW STATUS',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.flight_class,
                                      color:
                                          Color.fromRGBO(155, 153, 153, 0.824),
                                      size: 20),
                                  label: const Text(
                                    '4 SEAT',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            133, 133, 133, 0.824),
                                        fontSize: 12),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              155, 153, 153, 0.824)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Toggle switch and label
                            Row(
                              children: [
                                const SizedBox(width: 0),
                                Text(
                                  isSwitched ? 'Available' : 'Unavailable',
                                  style: TextStyle(
                                    color: isSwitched
                                        ? Colors.green
                                        : Colors
                                            .red, // Change color based on state
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched =
                                          value; // Update the toggle state
                                    });
                                  },
                                  activeColor: Colors
                                      .orange, // Color when the switch is on
                                  inactiveThumbColor: const Color.fromARGB(
                                      255,
                                      187,
                                      187,
                                      187), // Color when the switch is off
                                ),
                                const SizedBox(width: 39),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.local_airport,
                                      color:
                                          Color.fromRGBO(155, 153, 153, 0.824),
                                      size: 20),
                                  label: const Text(
                                    'N72370',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            133, 133, 133, 0.824),
                                        fontSize: 12),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              155, 153, 153, 0.824)),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                            Positioned(
                              left: 100,
                              right: -200,
                              top: 500,
                              child: Container(
                                width: 350,
                                height: 300,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 184, 184, 184),
                                    width: 2.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // ไอคอนแก้ไขอยู่ขวาสุด
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end, // ให้ไอคอนอยู่ทางขวา
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isEditing =
                                                  !_isEditing; // สลับโหมดการแก้ไข
                                            });
                                          },
                                          child: Icon(
                                            _isEditing
                                                ? Icons.check
                                                : Icons
                                                    .edit, // เปลี่ยนไอคอนตามโหมด
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // TextField for title
                                    TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter title here',
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      readOnly:
                                          !_isEditing, // ตั้งให้แก้ไขได้เมื่อเป็นโหมดแก้ไข
                                    ),
                                    const SizedBox(height: 8),
                                    // TextField for description
                                    TextField(
                                      controller: _descriptionController,
                                      decoration: const InputDecoration(
                                        hintText: 'TEXT',
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 109, 104, 104),
                                      ),
                                      readOnly:
                                          !_isEditing, // ตั้งให้แก้ไขได้เมื่อเป็นโหมดแก้ไข
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
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
