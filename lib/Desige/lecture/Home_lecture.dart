import 'package:flutter/material.dart';
import 'package:plane_borrow/Desige/lecture/Dashboard_lecture.dart';
import 'package:plane_borrow/Desige/lecture/History_lecture.dart';
import 'package:plane_borrow/Desige/lecture/Listplane_lecture.dart';
import 'package:plane_borrow/Desige/lecture/Requestlist_lecture.dart';

class HomeLecture extends StatefulWidget {
  const HomeLecture({super.key});

  @override
  State<HomeLecture> createState() => _AppbarstudentState();
}

class _AppbarstudentState extends State<HomeLecture> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                icon: Icon(Icons.dashboard),
                text: 'Dashbord',
              ),
              Tab(
                icon: Icon(Icons.watch_later_rounded),
                text: 'History',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Listplanelecture(),
            Requestlistlecture(),
            DashboardLecture(),
            HistoryLecture()
          ],
        ),
      ),
    );
  }
}
