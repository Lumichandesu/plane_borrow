import 'package:flutter/material.dart';

class ReturnStaff extends StatefulWidget {
  const ReturnStaff({super.key});

  @override
  State<ReturnStaff> createState() => _ReturnStaffState();
}

class _ReturnStaffState extends State<ReturnStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned.fill(
          child: ListView(padding: const EdgeInsets.only(top: 80), children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), // Smaller radius
                  topRight: Radius.circular(40), // Smaller radius
                ),
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 16, horizontal: 12), // Reduced padding
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Center(
                      child: Text(
                        "Return Plane",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold), // Smaller font size
                      ),
                    ),
                    const SizedBox(height: 12), // Reduced space
                    returnCard(
                      image: 'assets/images/Beechcraft Bonanza G36.png',
                      status: 'Borrowing',
                      statusColor: Colors.white,
                      context: context,
                    ),
                    const SizedBox(height: 12), // Reduced space
                    returnCard(
                      image: 'assets/images/Beechcraft Bonanza G36.png',
                      status: 'Borrowing',
                      statusColor: Colors.white,
                      context: context,
                    ),
                    const SizedBox(height: 12), // Reduced space
                    returnCard(
                      image: 'assets/images/Beechcraft Bonanza G36.png',
                      status: 'Borrowing',
                      statusColor: Colors.white,
                      context: context,
                    ),
                    const SizedBox(height: 12), // Reduced space
                    returnCard(
                      image: 'assets/images/Beechcraft Bonanza G36.png',
                      status: 'Borrowing',
                      statusColor: Colors.white,
                      context: context,
                    ),
                  ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

Widget returnCard({
  required String image,
  required String status,
  required Color statusColor,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.all(4), // Further reduced padding
    decoration: BoxDecoration(
      color: Colors.grey[400],
      borderRadius: BorderRadius.circular(10), // Smaller radius
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: 120, // Further reduced image width
              height: 120, // Further reduced image height
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6), // Further reduced space
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Beechcraft Bonanza G36',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12), // Smaller font size
                ),
                const SizedBox(height: 4), // Reduced space
                const Row(
                  children: [
                    Icon(Icons.person, size: 14), // Reduced icon size
                    Text('Borrower',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12)), // Smaller font size
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.circular(15), // Smaller radius
                      ),
                      child: const Text(
                        '001',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12, // Smaller font size
                        ),
                      ),
                    ),
                    const SizedBox(width: 4), // Further reduced space
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius:
                            BorderRadius.circular(15), // Smaller radius
                      ),
                      child: const Text(
                        'Rhaenyra Targaryen',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12, // Smaller font size
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(color: Colors.grey),
        Row(
          children: [
            const SizedBox(width: 6), // Further reduced space
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BORROWING DATE',
                    style: TextStyle(fontSize: 12)), // Smaller font size
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15), // Smaller radius
                  ),
                  child: const Text(
                    '18-10-2024',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RETURN DATE',
                    style: TextStyle(fontSize: 12)), // Smaller font size
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15), // Smaller radius
                  ),
                  child: const Text(
                    '22-10-2024',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4), // Further reduced space
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FilledButton(
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(6)), // Smaller radius
                    ),
                  ),
                  child: const Text('Return',
                      style: TextStyle(fontSize: 12)), // Smaller font size
                ),
                const SizedBox(width: 4), // Further reduced space
                FilledButton(
                  onPressed: () {
                    _NOshowConfirmationDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(6))), // Smaller radius
                  ),
                  child: const Text('Not Return',
                      style: TextStyle(fontSize: 12)), // Smaller font size
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
                const SizedBox(width: 4), // Further reduced space
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor == Colors.white
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12, // Smaller font size
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

void _NOshowConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48, // Reduced icon size
            ),
            SizedBox(width: 6),
          ],
        ),
        content: const Text('Are you sure you do not want to return the plane?',
            style: TextStyle(fontSize: 12)), // Smaller font size
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No',
                style: TextStyle(fontSize: 12)), // Smaller font size
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Yes',
                style: TextStyle(fontSize: 12)), // Smaller font size
          ),
        ],
      );
    },
  );
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 48, // Reduced icon size
            ),
            SizedBox(width: 6),
          ],
        ),
        content: const Text('Are you sure you want to return the plane?',
            style: TextStyle(fontSize: 12)), // Smaller font size
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No',
                style: TextStyle(fontSize: 12)), // Smaller font size
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Yes',
                style: TextStyle(fontSize: 12)), // Smaller font size
          ),
        ],
      );
    },
  );
}
