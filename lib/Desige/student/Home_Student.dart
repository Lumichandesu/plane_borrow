import 'package:flutter/material.dart';
import 'package:plane_borrow/Desige/student/Listplane_Student.dart';
import 'package:plane_borrow/Desige/student/Request_Student.dart';
import 'package:plane_borrow/Desige/student/History_Student.dart';

class HomeStudent extends StatefulWidget {
  const HomeStudent({super.key});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
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
            labelColor: Color.fromARGB(255, 251, 96, 85),
            unselectedLabelColor: Colors.white,
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
        body: const TabBarView(
          children: [
            ListplaneStudent(),
            RequestStudent(),
            HistoryStudent(),
          ],
        ),
      ),
    );
  }
}
