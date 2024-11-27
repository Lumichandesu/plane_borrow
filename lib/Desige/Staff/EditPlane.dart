import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPlane extends StatefulWidget {
  final String planeId; // รหัสเครื่องบินที่ต้องการแก้ไข
  final String currentImage; // ชื่อไฟล์ปัจจุบันที่ใช้
  final Map<String, dynamic> planeData; // ข้อมูลปัจจุบันของเครื่องบิน

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
  final _formKey = GlobalKey<FormState>();
  final _imageController = TextEditingController();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _seatsController;
  late TextEditingController _tailNumberController;

  bool _status = false; // สำหรับสถานะเครื่องบิน

  // รายการของไฟล์รูปภาพเครื่องบิน
  final List<String> _imageOptions = [
    'Beechcraft Bonanza G36.png',
    'CESSANA 172.png',
    'Cirrus SR-22T.png',
    'Diamond DA40.png',
    'Embraer Phonom 300.png',
    'Gulfstream G280.png'
  ];
  String? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.planeData['planeName']);
    _descriptionController =
        TextEditingController(text: widget.planeData['planeDescription']);
    _categoryController =
        TextEditingController(text: widget.planeData['category']);
    _seatsController =
        TextEditingController(text: widget.planeData['seat'].toString());
    _tailNumberController =
        TextEditingController(text: widget.planeData['tailNumber']);
    _status = widget.planeData['status'] == 1;

    // ถ้าค่าเริ่มต้นไม่อยู่ในรายการ ให้เพิ่มลงใน _imageOptions
    if (_imageOptions.contains(widget.currentImage)) {
      _selectedImage = widget.currentImage;
    } else {
      _imageOptions.add(widget.currentImage); // เพิ่มค่าใหม่ลงในตัวเลือก
      _selectedImage = widget.currentImage; // กำหนดค่าเริ่มต้น
    }
  }

  Future<void> _updatePlane() async {
    if (!_formKey.currentState!.validate()) return;

    final int seats = int.tryParse(_seatsController.text) ?? 0;

    final updatedPlane = {
      'planeName': _nameController.text,
      'status': _status ? 1 : 0,
      'category': _categoryController.text, // หมวดหมู่ดีฟอลต์
      'seat': seats,
      'planeDescription': _descriptionController.text.isEmpty
          ? 'No description'
          : _descriptionController.text,
      'tailNumber': _tailNumberController.text,
      'image': _selectedImage ?? '', // ใช้ค่า _selectedImage
    };

    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.5:3000/updateplane/${widget.planeId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedPlane),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plane updated successfully!')),
        );
        Navigator.pop(context, updatedPlane); // ส่งข้อมูลกลับหน้าก่อนหน้า
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to update plane');
      }
    } catch (e) {
      print('Error updating plane: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Plane'),
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
                  'Edit Plane Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // 1. Select Image
                DropdownButtonFormField<String>(
                  value: _selectedImage,
                  items: _imageOptions
                      .map((image) => DropdownMenuItem(
                            value: image,
                            child: Text(image), // แสดงชื่อไฟล์เครื่องบิน
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedImage = value!;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Select Image'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select an image'
                      : null,
                ),
                const SizedBox(height: 20),
                // 2. Plane Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Plane Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter plane name'
                      : null,
                ),
                // 3. Category
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                // 4. Seats
                TextFormField(
                  controller: _seatsController,
                  decoration: const InputDecoration(labelText: 'Seats'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final seats = int.tryParse(value ?? '');
                    if (seats == null || seats <= 0) {
                      return 'Please enter a valid number of seats';
                    }
                    return null;
                  },
                ),
                // 5. Tail Number
                TextFormField(
                  controller: _tailNumberController,
                  decoration: const InputDecoration(labelText: 'Tail Number'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter tail number'
                      : null,
                ),
                // 6. Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
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
                  onPressed: _updatePlane,
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
