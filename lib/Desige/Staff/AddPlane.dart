import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPlane extends StatefulWidget {
  const AddPlane({super.key});

  @override
  _AddPlaneState createState() => _AddPlaneState();
}

class _AddPlaneState extends State<AddPlane> {
  File? _imageFile;
  String _planeName = ''; // State for plane name
  String _seats = ''; // State for seats
  String _tailNumber = ''; // State for tail number
  String _planeDescription = ''; // State for plane description

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to show the confirmation alert
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Plane Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Plane Name: $_planeName'),
                Text('Seats: $_seats'),
                Text('Tail Number: $_tailNumber'),
                Text('Description: $_planeDescription'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _addPlane(); // Add the plane or submit the data
              },
            ),
          ],
        );
      },
    );
  }

  // Function to simulate adding a plane (for example purposes)
  void _addPlane() {
    // Here, you would typically save or submit the plane data
    print('Plane Added');
    print(
        'Name: $_planeName, Seats: $_seats, Tail Number: $_tailNumber, Description: $_planeDescription');
    // You can show a success message or navigate to another screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(0),
              iconSize: 28,
              splashRadius: 24,
            ),
          ),
          // Main content
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _imageFile!,
                                height: 200,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.grey,
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Enter Plane Name'),
                            content: TextField(
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  _planeName = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter plane name',
                              ),
                            ),
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
                    },
                    child: Text(
                      _planeName.isEmpty
                          ? 'click here to add plane name'
                          : _planeName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'General Aviation', // Static text for category
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Enter Seats'),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _seats = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter number of seats',
                                  ),
                                ),
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
                        },
                        child: Container(
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
                              const Icon(Icons.event_seat, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                _seats.isEmpty ? 'Seats' : _seats,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Enter Tail Number'),
                                content: TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      _tailNumber = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter tail number',
                                  ),
                                ),
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
                        },
                        child: Container(
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
                              const Icon(Icons.airplanemode_active,
                                  color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                _tailNumber.isEmpty
                                    ? 'Tail Number'
                                    : _tailNumber,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      maxLines:
                          5, // Makes the text field multi-line for description
                      onChanged: (value) {
                        setState(() {
                          _planeDescription = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter plane description',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32), // Adds spacing before button
                ],
              ),
            ),
          ),
          // Add Plane Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _showConfirmationDialog, // Show confirmation dialog
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Black background
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Plane',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
