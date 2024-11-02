import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPlane extends StatefulWidget {
  const AddPlane({super.key});

  @override
  State<AddPlane> createState() => _Addplane();
}

class _Addplane extends State<AddPlane> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isEditingTitle = false;
  File? _selectedImage;
  bool isSwitched = false;

  double box1Height = 180.0;
  bool isAvailable = true;
  String seatText = "+";
  String planeText = "+";
  bool isEditingSeat = false;
  bool isEditingPlane = false;

  List<String> seatButtons = [];
  List<Widget> categoryButtons = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

 void _showChangeAlert() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.orange, size: 80), // Larger icon
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
              Icon(Icons.task_alt, color: Colors.green,size: 80,),
              SizedBox(height: 20,),
              Text('Change Complete',
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

  void _addCategoryButton() {
    setState(() {
      categoryButtons.insert(
        0,
        CategoryButton(
          initialText: 'Category ${categoryButtons.length + 1}',
          onRemove: () {
            setState(() {
              categoryButtons.removeAt(0);
            });
          },
        ),
      );
    });
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
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 30),
              onPressed: () {},
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 180),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: box1Height,
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
                                _isEditingTitle
                                    ? Expanded(
                                        child: TextField(
                                          controller: _titleController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter title here',
                                          ),
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 146, 146, 146),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _titleController.text.isEmpty
                                            ? '    TITLE'
                                            : _titleController.text,
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 26, 25, 25),
                                        ),
                                      ),
                                const SizedBox(width: 50),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isEditingTitle = !_isEditingTitle;
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/editing.png',
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                    ],
                  ),
                  Positioned(
                    right: 16,
                    top: 80,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 184, 184, 184),
                            width: 2.0,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    top: 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: categoryButtons,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.black, size: 30),
                              onPressed: _addCategoryButton,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            isEditingSeat
                                ? SizedBox(
                                    width: 80,
                                    child: TextField(
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter seat'),
                                      onSubmitted: (text) {
                                        setState(() {
                                          seatText = text;
                                          isEditingSeat = false;
                                        });
                                      },
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    icon: const Icon(Icons.flight_class,
                                        color: Color.fromRGBO(155, 153, 153, 0.824),
                                        size: 20),
                                    label: Text(
                                      seatText,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(133, 133, 133, 0.824),
                                          fontSize: 12),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Color.fromRGBO(155, 153, 153, 0.824)),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isEditingSeat = true;
                                      });
                                    },
                                  ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              isSwitched ? 'Available' : 'Unavailable',
                              style: TextStyle(
                                color: isSwitched ? Colors.green : Colors.red,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeColor: Colors.orange,
                              inactiveThumbColor:
                                  const Color.fromARGB(255, 187, 187, 187),
                            ),
                            const SizedBox(width: 35),
                            isEditingPlane
                                ? SizedBox(
                                    width: 80,
                                    child: TextField(
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter plane ID'),
                                      onSubmitted: (text) {
                                        setState(() {
                                          planeText = text;
                                          isEditingPlane = false;
                                        });
                                      },
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    icon: const Icon(Icons.local_airport,
                                        color: Color.fromRGBO(155, 153, 153, 0.824),
                                        size: 20),
                                    label: Text(
                                      planeText,
                                      style: const TextStyle(
                                          color: Color.fromRGBO(133, 133, 133, 0.824),
                                          fontSize: 12),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                            color: Color.fromRGBO(155, 153, 153, 0.824)),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isEditingPlane = true;
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 50,
                    right: 40,
                    top: 500,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 184, 184, 184),
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'TITLE',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              hintText: 'TEXT',
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 109, 104, 104),
                            ),
                          ),
                        ],
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

// Define a separate StatefulWidget for CategoryButton
class CategoryButton extends StatefulWidget {
  final String initialText;
  final VoidCallback onRemove;

  const CategoryButton({
    super.key,
    required this.initialText,
    required this.onRemove,
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  late String buttonText;

  @override
  void initState() {
    super.initState();
    buttonText = widget.initialText;
  }

  void _editText() {
    TextEditingController textController = TextEditingController(text: buttonText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Enter category name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                setState(() {
                  buttonText = textController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          onPressed: _editText,
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.black, fontSize: 11),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: widget.onRemove,
        ),
      ],
    );
  }
}
