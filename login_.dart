import 'package:flutter/material.dart';

// Import home pages
import 'package:george/view/auth/patienthome.dart';
import 'package:george/view/auth/doctorhome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDoctor = false;
  bool showPassword = false;

  bool isSignUpMode = false; // ✅ toggle between Login / Sign Up

  int triesLeft = 3;
  bool locked = false;

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController(); // ✅ new
  final TextEditingController passwordCtrl = TextEditingController();

  // ✅ Demo database (front-end only)
  // role -> username -> {phone, pass}
  static final Map<String, Map<String, Map<String, String>>> accounts = {
    "patient": {
      "george": {"phone": "0790000000", "pass": "George@05"},
    },
    "doctor": {
      "omar": {"phone": "0780000000", "pass": "Omar@05"},
    },
  };

  @override
  void dispose() {
    usernameCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String get roleKey => isDoctor ? "doctor" : "patient";

  void _clearFields() {
    usernameCtrl.clear();
    phoneCtrl.clear();
    passwordCtrl.clear();
  }

  bool _isValidPhone(String phone) {
    // simple check: only digits and length 9-14
    final cleaned = phone.replaceAll(" ", "");
    final okDigits = RegExp(r'^\d+$').hasMatch(cleaned);
    return okDigits && cleaned.length >= 9 && cleaned.length <= 14;
  }

  void _signUp() {
    if (locked) return;

    final username = usernameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    final password = passwordCtrl.text;

    if (username.isEmpty || phone.isEmpty || password.isEmpty) {
      _showMsg("Please enter username, phone number, and password");
      return;
    }

    if (!_isValidPhone(phone)) {
      _showMsg("Please enter a valid phone number (digits only)");
      return;
    }

    if (password.length < 6) {
      _showMsg("Password must be at least 6 characters");
      return;
    }

    final roleMap = accounts[roleKey]!;
    if (roleMap.containsKey(username)) {
      _showMsg("Username already exists. Please login.");
      return;
    }

    // ✅ create account
    roleMap[username] = {"phone": phone, "pass": password};

    _showMsg("Account created! You can now sign in.");
    setState(() => isSignUpMode = false);
    _clearFields();
  }

  void _signIn() {
    if (locked) return;

    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text;

    if (username.isEmpty || password.isEmpty) {
      _showMsg("Please enter username and password");
      return;
    }

    final roleMap = accounts[roleKey]!;
    final userData = roleMap[username];

    final bool ok = userData != null && userData["pass"] == password;

    // ✅ Success
    if (ok) {
      if (!isDoctor) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientHomePage(),
            settings: RouteSettings(arguments: username),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorHomePage(),
            settings: RouteSettings(arguments: username),
          ),
        );
      }
      return;
    }

    // ❌ Wrong credentials
    setState(() {
      triesLeft--;
      if (triesLeft <= 0) locked = true;
    });

    if (locked) {
      _showMsg("Too many tries. Login is locked.");
      return;
    }

    _showMsg(
      isDoctor
          ? "No doctor account found. Tries left: $triesLeft"
          : "No patient account found. Tries left: $triesLeft",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f9fc),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f9fc),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    "image/healthgaurdd.png",
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  "GuardianCare",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: Text(
                  locked
                      ? "Login locked"
                      : isSignUpMode
                          ? (isDoctor ? "Doctor sign up" : "Patient sign up")
                          : (isDoctor ? "Doctor sign in" : "Patient sign in"),
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Login/Signup switch
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: locked
                        ? null
                        : () {
                            setState(() => isSignUpMode = false);
                            _clearFields();
                          },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight:
                            !isSignUpMode ? FontWeight.bold : FontWeight.normal,
                        color: !isSignUpMode ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  const Text("|"),
                  TextButton(
                    onPressed: locked
                        ? null
                        : () {
                            setState(() => isSignUpMode = true);
                            _clearFields();
                          },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight:
                            isSignUpMode ? FontWeight.bold : FontWeight.normal,
                        color: isSignUpMode ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text("Sign in as"),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: locked
                          ? null
                          : () {
                              setState(() => isDoctor = false);
                              _clearFields();
                            },
                      child: _roleCard(
                        icon: Icons.favorite_border,
                        label: "Patient",
                        selected: !isDoctor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: locked
                          ? null
                          : () {
                              setState(() => isDoctor = true);
                              _clearFields();
                            },
                      child: _roleCard(
                        icon: Icons.local_hospital,
                        label: "Doctor",
                        selected: isDoctor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text("Username"),
              const SizedBox(height: 6),
              TextField(
                controller: usernameCtrl,
                enabled: !locked,
                decoration: InputDecoration(
                  hintText: "Enter username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              // ✅ Phone only in Sign Up mode
              if (isSignUpMode) ...[
                const SizedBox(height: 18),
                const Text("Phone number"),
                const SizedBox(height: 6),
                TextField(
                  controller: phoneCtrl,
                  enabled: !locked,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter phone number",
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],

              const SizedBox(height: 18),

              const Text("Password"),
              const SizedBox(height: 6),
              TextField(
                controller: passwordCtrl,
                enabled: !locked,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: locked
                        ? null
                        : () => setState(() => showPassword = !showPassword),
                  ),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
               onPressed: null, // non functional
               child: Text("Forgot Password"),
               ),


              if (!isSignUpMode)
                Text(
                  "Tries left: $triesLeft",
                  style: TextStyle(color: locked ? Colors.red : Colors.grey),
                ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: locked
                      ? null
                      : (isSignUpMode ? _signUp : _signIn),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: Text(
                    locked
                        ? "Locked"
                        : (isSignUpMode ? "Create Account" : "Sign In"),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Simple role card widget
  Widget _roleCard({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
        color: selected ? Colors.blue.shade50 : Colors.white,
      ),
      child: Column(
        children: [
          Icon(icon, color: selected ? Colors.blue : Colors.grey),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}