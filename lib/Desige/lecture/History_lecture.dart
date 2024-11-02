import 'package:flutter/material.dart';

class HistoryLecture extends StatelessWidget {
  const HistoryLecture({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/airplane.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Main History content
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
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.03,
                      horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and logout button
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'HISTORY',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // History Cards
                      _buildHistoryCard(
                        context: context,
                        airplaneImage:
                            'assets/images/Beechcraft Bonanza G36.png',
                        modelName: 'Beechcraft Bonanza G36',
                        staffName: 'Tylar',
                        configuredBy: 'Ariana Grande',
                        borrowingDate: '21-10-2024',
                        returnDate: '22-10-2024',
                        approvedDate: '21-10-2024',
                        actionText: 'Return',
                        actionTextColor: Colors.green,
                      ),
                      _buildHistoryCard(
                        context: context,
                        airplaneImage: 'assets/images/CESSANA 172.png',
                        modelName: 'Beechcraft Bonanza G36',
                        staffName: 'Tylar',
                        configuredBy: 'Ariana Grande',
                        borrowingDate: '21-10-2024',
                        returnDate: '22-10-2024',
                        actionText: 'Rejected',
                        actionTextColor: Colors.red,
                        showRejectDate: true,
                        rejectDate: '21-10-2024',
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

  // Method to build history card
  Widget _buildHistoryCard({
    required BuildContext context,
    required String airplaneImage,
    required String modelName,
    required String staffName,
    required String configuredBy,
    required String borrowingDate,
    required String returnDate,
    required String actionText,
    required Color actionTextColor,
    String? approvedDate,
    bool showRejectDate = false,
    String? rejectDate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airplane image and model name
              Row(
                children: [
                  Image.asset(
                    airplaneImage,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      modelName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Staff and Approved by information on the same line
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow(
                      Icons.verified_user, 'Approved by', configuredBy),
                  _buildInfoRow(Icons.person, 'Staff', staffName),
                ],
              ),
              const SizedBox(height: 16),

              // Borrowing details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateColumn('BORROWING DATE', borrowingDate),
                  _buildDateColumn('RETURN DATE', returnDate),
                  if (!showRejectDate && approvedDate != null)
                    _buildDateColumn('APPROVE DATE', approvedDate),
                  if (showRejectDate)
                    _buildDateColumn('REJECT DATE', rejectDate ?? ''),
                ],
              ),
              const SizedBox(height: 16),

              // Action text (Return or Rejected)
              Center(
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: actionTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build info row with an icon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget to build date columns
  Widget _buildDateColumn(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(date,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
