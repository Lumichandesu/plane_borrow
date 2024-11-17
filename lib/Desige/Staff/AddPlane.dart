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
  String _planeName = '';
  String _seats = '';
  String _tailNumber = '';
  String _planeDescription = '';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _addPlane();
              },
            ),
          ],
        );
      },
    );
  }

  void _addPlane() {
    print('Plane Added');
    print(
        'Name: $_planeName, Seats: $_seats, Tail Number: $_tailNumber, Description: $_planeDescription');
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plane'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                      _showTextInputDialog('Enter Plane Name', (value) {
                        setState(() {
                          _planeName = value;
                        });
                      });
                    },
                    child: Text(
                      _planeName.isEmpty ? 'Click to add plane name' : _planeName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'General Aviation',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInputField('Enter Seats', _seats, (value) {
                        setState(() {
                          _seats = value;
                        });
                      }, Icons.event_seat),
                      _buildInputField('Enter Tail Number', _tailNumber, (value) {
                        setState(() {
                          _tailNumber = value;
                        });
                      }, Icons.airplanemode_active),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      maxLines: 5,
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
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Plane',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String hintText, String value, Function(String) onChanged, IconData icon) {
    return GestureDetector(
      onTap: () {
        _showTextInputDialog(hintText, onChanged);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(value.isEmpty ? hintText : value, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showTextInputDialog(String hintText, Function(String) onChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter $hintText'),
          content: TextField(
            autofocus: true,
            onChanged: onChanged,
            decoration: InputDecoration(hintText: hintText),
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
  }
}

class ListPlaneStaff extends StatelessWidget {
  const ListPlaneStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Plane Staff'),
      ),
      body: const Center(
        child: Text('List of planes for staff'),
      ),
    );
  }
}
