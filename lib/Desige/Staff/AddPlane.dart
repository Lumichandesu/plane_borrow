import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plane_borrow/api_config.dart';

class AddPlane extends StatefulWidget {
  const AddPlane({super.key});

  @override
  _AddPlaneState createState() => _AddPlaneState();
}

class _AddPlaneState extends State<AddPlane> {
  final _formKey = GlobalKey<FormState>();
  final _imageController = TextEditingController();

  String _planeName = '';
  String _seats = '';
  String _tailNumber = '';
  String _planeDescription = '';
  String _category = 'Commercial'; // ค่าเริ่มต้น
  bool _status = true; // ค่าเริ่มต้นสำหรับสถานะ

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _addPlane() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> planeData = {
      'planeName': _planeName,
      'planeTitle': 'General Aviation',
      'status': _status ? 1 : 0,
      'category': _category,
      'seat': _seats,
      'planeDescription': _planeDescription,
      'tailNumber': _tailNumber,
      'image': _imageController.text,
    };

    const String apiUrl = '${ApiConfig.baseUrl}/addplane';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(planeData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Plane added successfully: ID ${responseData['id']}')),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add plane: $error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Plane'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Plane Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // 1. Image File Name
                TextFormField(
                  controller: _imageController,
                  decoration:
                      const InputDecoration(labelText: 'Image File Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter image file name'
                      : null,
                ),
                const SizedBox(height: 20),
                // 2. Plane Name
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Plane Name'),
                  onChanged: (value) => _planeName = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter plane name'
                      : null,
                ),
                const SizedBox(height: 20),
                // 3. Category
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) => _category = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter category'
                      : null,
                ),
                const SizedBox(height: 20),
                // 4. Seats
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Seats'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _seats = value,
                  validator: (value) {
                    final seats = int.tryParse(value ?? '');
                    if (seats == null || seats <= 0) {
                      return 'Please enter a valid number of seats';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // 5. Tail Number
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tail Number'),
                  onChanged: (value) => _tailNumber = value,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter tail number'
                      : null,
                ),
                const SizedBox(height: 20),
                // 6. Description
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onChanged: (value) => _planeDescription = value,
                ),
                const SizedBox(height: 20),
                // 7. Status
                Row(
                  children: [
                    const Text('Active'),
                    Switch(
                      value: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 8. Save Changes Button
                ElevatedButton(
                  onPressed: _addPlane,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
