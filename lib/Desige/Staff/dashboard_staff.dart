import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plane_borrow/api_config.dart';

class DashboardStaff extends StatefulWidget {
  const DashboardStaff({super.key});

  @override
  _DashboardStaffState createState() => _DashboardStaffState();
}

class _DashboardStaffState extends State<DashboardStaff> {
  int borrowedCount = 0;
  int availableCount = 0;
  int disabledCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAssetTotals();
  }

  Future<void> _fetchAssetTotals() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/asset-status'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched data: $data');  // Log the fetched data

        setState(() {
          borrowedCount = int.tryParse(data['borrowed_assets']?.toString() ?? '0') ?? 0;
          availableCount = int.tryParse(data['available_assets']?.toString() ?? '0') ?? 0;
          disabledCount = int.tryParse(data['disabled_assets']?.toString() ?? '0') ?? 0;
        });
      } else {
        print('Failed to fetch asset totals: ${response.statusCode}'); // Log status code
      }
    } catch (e) {
      print('Error fetching asset totals: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg', // Ensure this image path is correct
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: EdgeInsets.all(screenHeight * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'DASHBOARD',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Borrowed Assets Card
                      _buildDashboardCard(
                        icon: Icons.inventory_2_outlined,
                        iconColor: Colors.black,
                        assetType: 'Borrowed Assets',
                        count: borrowedCount,
                        screenHeight: screenHeight,
                      ),

                      // Available Assets Card
                      _buildDashboardCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        assetType: 'Available Assets',
                        count: availableCount,
                        screenHeight: screenHeight,
                      ),

                      // Disabled Assets Card
                      _buildDashboardCard(
                        icon: Icons.cancel,
                        iconColor: Colors.red,
                        assetType: 'Disabled Assets',
                        count: disabledCount,
                        screenHeight: screenHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required Color iconColor,
    required String assetType,
    required int count,
    required double screenHeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 72),
                const SizedBox(height: 8),
                Text(
                  assetType,
                  style: TextStyle(fontSize: screenHeight * 0.03),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}