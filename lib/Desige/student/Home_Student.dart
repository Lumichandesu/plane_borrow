import 'package:flutter/material.dart';
import 'Listplane_Student.dart';
import 'Request_Student.dart';
import 'History_Student.dart';

class HomeStudent extends StatefulWidget {
  final String userId; // เพิ่ม userId เพื่อเก็บค่า id ของผู้ใช้
  const HomeStudent({super.key, required this.userId});

  @override
  State<HomeStudent> createState() => _AppbarstudentState();
}

class _AppbarstudentState extends State<HomeStudent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'SkyChauffeur',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: const TabBar(
            labelColor:
                Color.fromARGB(255, 251, 96, 85), // สีของข้อความที่ถูกเลือก
            unselectedLabelColor: Colors.white, // สีของข้อความที่ไม่ได้ถูกเลือก
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.check_box),
                text: 'Request',
              ),
              Tab(
                icon: Icon(Icons.watch_later_rounded),
                text: 'History',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const ListplaneStudent(),
            RequestStudent(userId: widget.userId),
            HistoryStudent3(
                userId: widget.userId), // ส่ง userId ไปยังหน้า HistoryStudent3
          ],
        ),
      ),
    );
  }
}
