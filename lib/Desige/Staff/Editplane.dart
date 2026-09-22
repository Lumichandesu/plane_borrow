import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:plane_borrow/api_config.dart';

class EditPlane extends StatefulWidget {
  final String planeId;
  final String currentImage;
  final Map<String, dynamic> planeData;

  const EditPlane({
    super.key,
    required this.planeId,
    required this.currentImage,
    required this.planeData,
  });

  @override
  _EditPlaneState createState() => _EditPlaneState();
}

class _EditPlaneState extends State<EditPlane> {
  late TextEditingController _planeNameController;
  late TextEditingController _seatsController;
  late TextEditingController _tailNumberController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _planeNameController =
        TextEditingController(text: widget.planeData['planeName'] ?? '');
    _seatsController =
        TextEditingController(text: widget.planeData['seat']?.toString() ?? '');
    _tailNumberController =
        TextEditingController(text: widget.planeData['tailNumber'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.planeData['planeDescription'] ?? '');
    _categoryController =
        TextEditingController(text: widget.planeData['category'] ?? '');
    _isAvailable = (widget.planeData['status'] == 1);
  }

  @override
  void dispose() {
    _planeNameController.dispose();
    _seatsController.dispose();
    _tailNumberController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

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

  Future<void> _savePlane() async {
    final Map<String, dynamic> updatedData = {
      'planeName': _planeNameController.text,
      'planeTitle': widget.planeData['planeTitle'] ?? 'General Aviation',
      'status': _isAvailable ? 1 : 0,
      'category': _categoryController.text,
      'seat': _seatsController.text,
      'planeDescription': _descriptionController.text,
      'tailNumber': _tailNumberController.text,
      'image': widget.currentImage,
    };

    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/updateplane/${widget.planeId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plane updated successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
                _savePlane(); // Actually call the API
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
                    // Display the current image
                    Image.asset(
                      'assets/images/${widget.currentImage}',
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: Icon(Icons.image_not_supported, size: 60)),
                        );
                      },
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
                    GestureDetector(
                      onTap: () =>
                          _editTextField('Category', _categoryController),
                      child: Text(
                        _categoryController.text,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
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
