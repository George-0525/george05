import 'package:flutter/material.dart';
import 'package:george/view/auth/login_.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  // -------------------------------
  // Demo data (front-end only)
  // Change/add patients here easily
  // -------------------------------
  static final List<Map<String, String>> patients = [
    {"name": "Margaret Thompson", "info": "72 years • 10 min ago"},
    {"name": "Robert Chen", "info": "68 years • 2 hours ago"},
    {"name": "Dorothy Williams", "info": "75 years • 1 hour ago"},
    {"name": "James Martinez", "info": "70 years • 30 min ago"},
  ];

  @override
  Widget build(BuildContext context) {
    // -------------------------------
    // Get doctor name from Login
    // Login sends it using RouteSettings(arguments: username)
    // -------------------------------
    final args = ModalRoute.of(context)?.settings.arguments;
    final String doctorName =
        (args is String && args.trim().isNotEmpty) ? args : "Doctor";

    return Scaffold(
      backgroundColor: Colors.grey[50],

      // -------------------------------
      // Drawer (Menu)
      // -------------------------------
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Menu",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              _drawerItem(Icons.people, "All Patients"),
              _drawerItem(Icons.warning_amber, "Alerts"),
              _drawerItem(Icons.settings, "Settings"),

              const Spacer(),

              // -------------------------------
              // Sign Out (go back to Login)
              // -------------------------------
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context); // close drawer

                    // Clear all pages and go to Login
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                  child: const Text("Sign Out"),
                ),
              ),
            ],
          ),
        ),
      ),

      // -------------------------------
      // App bar
      // -------------------------------
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 58, 74, 219),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Doctor Portal",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              "Dr. $doctorName",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),

      // -------------------------------
      // Body
      // -------------------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------
            // Small stats cards
            // Change numbers here easily
            // -------------------------------
            Row(
              children: const [
                Expanded(child: _statCard(number: "24", label: "Patients")),
                SizedBox(width: 10),
                Expanded(child: _statCard(number: "2", label: "Alerts")),
                SizedBox(width: 10),
                Expanded(child: _statCard(number: "94%", label: "Adherence")),
              ],
            ),

            const SizedBox(height: 22),

            // -------------------------------
            // Alerts section
            // -------------------------------
            Text(
              "Active Alerts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            _alertCard(
              name: "Margaret Thompson",
              issue: "BP: 142/88",
              time: "10 min ago",
            ),
            const SizedBox(height: 12),
            _alertCard(
              name: "James Martinez",
              issue: "Missed medication",
              time: "30 min ago",
            ),

            const SizedBox(height: 22),

            // -------------------------------
            // Patients section (simple list)
            // -------------------------------
            Text(
              "All Patients",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),

            // Build patient list
            ...patients.map((p) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _patientTile(
                  name: p["name"]!,
                  info: p["info"]!,
                  onTap: () {
                    // Later you can open patient details page
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailsPage()));
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // Drawer item
  // -------------------------------
  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Add navigation later if you create pages
      },
    );
  }

  // -------------------------------
  // Alert card
  // -------------------------------
  Widget _alertCard({
    required String name,
    required String issue,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(issue, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                const SizedBox(height: 3),
                Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Later: message or call
            },
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // Patient tile
  // -------------------------------
  Widget _patientTile({
    required String name,
    required String info,
    required VoidCallback onTap,
  }) {
    final initials = name.isNotEmpty
        ? name.split(" ").take(2).map((e) => e[0]).join()
        : "P";

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(info, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// -------------------------------
// Simple stat card widget
// -------------------------------
class _statCard extends StatelessWidget {
  final String number;
  final String label;

  const _statCard({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
