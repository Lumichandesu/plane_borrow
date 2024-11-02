import 'package:flutter/material.dart';

class Dashboardstaff extends StatelessWidget {
  const Dashboardstaff({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the height and width of the device
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),

          // Main Dashboard content
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.1), // Adjust top padding for layout
              children: [
                // Container for Dashboard header and items
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Gray color
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.03,
                    horizontal: screenWidth * 0.04,
                  ), // Responsive padding
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center align
                    children: [
                      // Dashboard Header (Title) with Logout button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Centered title
                          Expanded(
                            child: Center(
                              child: Text(
                                'DASHBOARD',
                                style: TextStyle(
                                  fontSize: screenHeight *
                                      0.05, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: screenHeight * 0.03), // Responsive height

                      // Borrowed Assets Card
                      _buildDashboardCard(
                        icon: Icons.inventory_2_outlined,
                        iconColor: Colors.black,
                        assetType: 'borrowed assets',
                        count: 10,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),

                      // Available Assets Card
                      _buildDashboardCard(
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                        assetType: 'available assets',
                        count: 20,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),

                      // Disabled Assets Card
                      _buildDashboardCard(
                        icon: Icons.cancel,
                        iconColor: Colors.red,
                        assetType: 'disabled assets',
                        count: 10,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer section - you can put your footer here
        ],
      ),
    );
  }

  // Method to build the dashboard cards as rectangles
  Widget _buildDashboardCard({
    required IconData icon,
    required Color iconColor,
    required String assetType,
    required int count,
    required double screenHeight, // Pass screenHeight
    required double screenWidth, // Pass screenWidth
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Responsive padding
      child: SizedBox(
        width: double.infinity, // This will make the card take full width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
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
                  style: TextStyle(
                      fontSize: screenHeight * 0.03), // Responsive font size
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    fontWeight: FontWeight.bold,
                  ), // Responsive font size
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
