import 'dart:io'; // For handling file paths
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images

class EditPlane extends StatefulWidget {
  const EditPlane({super.key});

  @override
  _EditPlaneState createState() => _EditPlaneState();
}

class _EditPlaneState extends State<EditPlane> {
  final TextEditingController _planeNameController =
      TextEditingController(text: "Diamond DA40");
  final TextEditingController _seatsController =
      TextEditingController(text: "4 Seats");
  final TextEditingController _tailNumberController =
      TextEditingController(text: "N12345");
  final TextEditingController _descriptionController = TextEditingController(
      text:
          "The cockpit is glass-panel equipped with avionics like the Garmin G1000 system (in most configurations), providing navigation, autopilot, and flight management systems. This makes the aircraft easy to fly and enhances situational awareness for the pilot.");

  File? _imageFile; // To hold the selected image
  bool _isAvailable = true; // Track the availability status

  // Function to handle editing text
  void _editTextField(String field, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $field',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to pick image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile =
            File(pickedFile.path); // Update the image with the selected file
      });
    }
  }

  // Function to show the confirmation dialog when saving changes
  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to save the changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // Handle the save action here
                // For example, you can add logic to save the data or perform actions
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap the content inside SingleChildScrollView
        child: Stack(
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
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
                child: Column(
                  children: [
                    // Availability Toggle Switch moved above the image
                    const Text(
                      'STATUS ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          value: _isAvailable,
                          onChanged: (bool value) {
                            setState(() {
                              _isAvailable = value;
                            });
                          },
                        ),
                        Text(
                          _isAvailable ? 'Available' : 'Disabled',
                          style: TextStyle(
                            fontSize: 16,
                            color: _isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Add some spacing

                    // Message above the image
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Click item you want to edit',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                    // Display the current image or a default image
                    _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              _imageFile!,
                              height: 200,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Image.asset(
                            "assets/images/Diamond DA40.png", // Default image if no image is picked
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                    const SizedBox(height: 16),
                    // Button to change the image
                    ElevatedButton(
                      onPressed: _pickImage, // Trigger the image picker
                      child: const Text('Change Image'),
                    ),
                    const SizedBox(height: 16),
                    // Editable Plane Name
                    GestureDetector(
                      onTap: () =>
                          _editTextField('Plane Name', _planeNameController),
                      child: Text(
                        _planeNameController.text,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'General Aviation', // Static text for category
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // Row with Seats and Tail Number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Editable Seats with fixed width
                        GestureDetector(
                          onTap: () =>
                              _editTextField('Seats', _seatsController),
                          child: Container(
                            width: 150, // Fixed width for consistency
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.event_seat,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  _seatsController.text,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Editable Tail Number with fixed width
                        GestureDetector(
                          onTap: () => _editTextField(
                              'Tail Number', _tailNumberController),
                          child: Container(
                            width: 150, // Fixed width for consistency
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.airplanemode_active,
                                    color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  _tailNumberController.text,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Editable Plane Description
                    GestureDetector(
                      onTap: () =>
                          _editTextField('Description', _descriptionController),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _descriptionController.text,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed:
              _showSaveConfirmationDialog, // Show the confirmation dialog
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Button color
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
