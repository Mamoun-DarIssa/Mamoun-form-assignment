import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SuccessPage extends StatelessWidget {
  final String username, email, gender, country;
  final int age;
  final DateTime? date;
  final bool rememberMe;
  final XFile? image;

  const SuccessPage({
    super.key,
    required this.username,
    required this.email,
    required this.gender,
    required this.country,
    required this.age,
    required this.date,
    required this.rememberMe,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Success animation / icon
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  "Your form has been submitted",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                // Info Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture + Name row
                        Row(
                          children: [
                            // Profile image
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey.shade200,
                              child: image == null
                                  ? const Icon(Icons.person,
                                      size: 40, color: Colors.grey)
                                  : ClipOval(
                                      child: FutureBuilder(
                                        future: image!.readAsBytes(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            );
                                          }
                                          return Image.memory(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: 80,
                                            height: 80,
                                          );
                                        },
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A2A3A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5A6B7C),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32, thickness: 1),
                        // Details grid
                        _infoRow(Icons.person_outline, "Username", username),
                        const SizedBox(height: 12),
                        _infoRow(Icons.email_outlined, "Email", email),
                        const SizedBox(height: 12),
                        _infoRow(Icons.wc, "Gender", gender),
                        const SizedBox(height: 12),
                        _infoRow(Icons.location_on_outlined, "Country", country),
                        const SizedBox(height: 12),
                        _infoRow(Icons.cake, "Age", age.toString()),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.calendar_today,
                          "Date",
                          date == null
                              ? "Not selected"
                              : "${date!.toLocal()}".split(' ')[0],
                        ),
                        const SizedBox(height: 12),
                        _infoRow(
                          Icons.check_box_outlined,
                          "Remember Me",
                          rememberMe ? "Yes" : "No",
                        ),
                        const SizedBox(height: 24),
                        // Back button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2C5364),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Back to Form",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2C5364)),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5B6C),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A2A3A),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}