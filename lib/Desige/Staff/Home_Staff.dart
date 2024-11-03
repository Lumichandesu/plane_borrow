import 'package:flutter/material.dart';
import 'package:plane_borrow/Desige/Staff/Listplane_staff.dart';
import 'History_staff.dart';
import 'dashboard_staff.dart'; // Make sure this import is correct
import 'Return_staff.dart';

class HomeStaff extends StatefulWidget {
  const HomeStaff({super.key});

  @override
  State<HomeStaff> createState() => _AppbarstudentState();
}

class _AppbarstudentState extends State<HomeStaff> {
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
            labelColor: Color.fromARGB(255, 251, 96, 85), // Selected text color
            unselectedLabelColor: Colors.white, // Unselected text color
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.u_turn_left_rounded),
                text: 'Return',
              ),
              Tab(
                icon: Icon(Icons.dashboard),
                text: 'Dashboard', // Fixed typo here (from 'Dashbord' to 'Dashboard')
              ),
              Tab(
                icon: Icon(Icons.watch_later_rounded),
                text: 'History',
              ),
            ],
          ),
        ),
        body: TabBarView( // Removed `const` here
          children: [
            ListplaneStaff(),
            ReturnStaff(),
            DashboardStaff(), // Corrected the widget name here
            HistoryStaff()
          ],
        ),
      ),
    );
  }
}