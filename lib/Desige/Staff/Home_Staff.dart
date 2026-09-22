import 'package:flutter/material.dart';
import 'History_staff.dart';
import 'Listplane_staff.dart';
import 'Return_staff.dart';
import 'dashboard_staff.dart'; // Make sure this import is correct

class HomeStaff extends StatefulWidget {
  final String userId; // Add userId parameter
  const HomeStaff({super.key, required this.userId});

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
            labelColor: Color.fromARGB(255, 251, 96, 85),
            unselectedLabelColor: Colors.white,
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
                text: 'Dashboard',
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
            const ListplaneStaff(),
            const ReturnStaff(),
            const DashboardStaff(),
            HistoryStaff(userId: widget.userId), // Pass the userId here
          ],
        ),
      ),
    );
  }
}
