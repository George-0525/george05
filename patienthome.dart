import 'package:flutter/material.dart';
import 'package:george/view/auth/login_.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  // Medications
  bool aspirinTaken = false;
  bool metforminTaken = false;

  // ✅ Editable vitals (user can change them)
  String bloodPressure = "142/88 mmHg";
  String heartRate = "78 bpm";
  String bloodSugar = "105 mg/dL";

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final String patientName =
        (args is String && args.trim().isNotEmpty) ? args : "Patient";

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Menu",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
              _drawerItem(Icons.monitor_heart, "My Health History"),
              _drawerItem(Icons.calendar_month, "My Appointments"),
              _drawerItem(Icons.favorite, "My Doctors"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good Morning 👋",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            Text(patientName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your blood pressure is high",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Your doctor has been notified",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Emergency button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.call),
                label: const Text("Get Emergency Help"),
                onPressed: () {},
              ),
            ),

            const SizedBox(height: 24),

            // ✅ Title + Edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Today's Health Overview",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _editVitalsPopup,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                )
              ],
            ),

            const SizedBox(height: 12),

            // ✅ These values are now editable
            _vitalCard(
              icon: Icons.monitor_heart,
              title: "Blood Pressure",
              value: bloodPressure,
              status: "Needs Attention",
              statusColor: Colors.red,
            ),
            _vitalCard(
              icon: Icons.favorite,
              title: "Heart Rate",
              value: heartRate,
              status: "All Good",
              statusColor: Colors.green,
            ),
            _vitalCard(
              icon: Icons.bloodtype,
              title: "Blood Sugar",
              value: bloodSugar,
              status: "Normal",
              statusColor: Colors.green,
            ),

            const SizedBox(height: 24),

            const Text("Your Medications Today",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            _medicineCard(
              name: "Aspirin 81mg",
              time: "Take at 2:00 PM",
              taken: aspirinTaken,
              onTap: () => setState(() => aspirinTaken = true),
            ),
            _medicineCard(
              name: "Metformin 500mg",
              time: "Take at 6:00 PM",
              taken: metforminTaken,
              onTap: () => setState(() => metforminTaken = true),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Popup to edit vitals manually
  void _editVitalsPopup() {
    final bpCtrl = TextEditingController(text: bloodPressure);
    final hrCtrl = TextEditingController(text: heartRate);
    final sugarCtrl = TextEditingController(text: bloodSugar);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Update your vitals"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: bpCtrl,
                decoration: const InputDecoration(labelText: "Blood Pressure"),
              ),
              TextField(
                controller: hrCtrl,
                decoration: const InputDecoration(labelText: "Heart Rate"),
              ),
              TextField(
                controller: sugarCtrl,
                decoration: const InputDecoration(labelText: "Blood Sugar"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  bloodPressure = bpCtrl.text.trim().isEmpty
                      ? bloodPressure
                      : bpCtrl.text.trim();

                  heartRate = hrCtrl.text.trim().isEmpty
                      ? heartRate
                      : hrCtrl.text.trim();

                  bloodSugar = sugarCtrl.text.trim().isEmpty
                      ? bloodSugar
                      : sugarCtrl.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Vital card widget
  Widget _vitalCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(color: statusColor)),
          ),
        ],
      ),
    );
  }

  // Medicine card widget
  Widget _medicineCard({
    required String name,
    required String time,
    required bool taken,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: taken ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: taken ? Colors.grey.shade300 : Colors.blue.shade50,
            child: Icon(Icons.medication,
                color: taken ? Colors.grey : Colors.blue),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  decoration: taken ? TextDecoration.lineThrough : null,
                  color: taken ? Colors.grey : Colors.black,
                ),
              ),
              Text(time,
                  style: TextStyle(
                      color: taken ? Colors.grey : Colors.grey.shade600)),
            ],
          ),
          const Spacer(),
          if (!taken)
            ElevatedButton(onPressed: onTap, child: const Text("Mark as Taken"))
          else
            const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }
}
