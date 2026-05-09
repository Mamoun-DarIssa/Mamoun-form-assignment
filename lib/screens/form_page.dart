import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_field.dart';
import 'success_page.dart';

class FormPage extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const FormPage({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool isHovering = false;

  String username = "", email = "", password = "";
  String gender = "Male";
  String country = "Palestine 🇵🇸";
  bool rememberMe = false;
  double age = 18;
  DateTime? date;

  XFile? image;
  Uint8List? imageBytes;

  Offset imageOffset = Offset.zero;
  double imageScale = 1.0;

  final countries = [
    "Pakistan",
    "India",
    "USA",
    "UK",
    "Canada",
    "Palestine 🇵🇸",
  ];

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    Offset tempOffset = Offset.zero;
    double tempScale = 1.0;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialog) {
            return Dialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: SizedBox(
                width: 420,
                height: 520,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "Crop Profile Picture",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Center(
                          child: ClipOval(
                            child: Container(
                              width: 260,
                              height: 260,
                              color: Colors.black26,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setDialog(() {
                                    tempOffset += details.delta;
                                    final limit = (tempScale - 1) * 120;
                                    tempOffset = Offset(
                                      tempOffset.dx.clamp(-limit, limit),
                                      tempOffset.dy.clamp(-limit, limit),
                                    );
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()
                                          ..translate(tempOffset.dx, tempOffset.dy)
                                          ..scale(tempScale, tempScale),
                                        child: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Zoom",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Slider(
                        value: tempScale,
                        min: 1,
                        max: 3,
                        activeColor: Colors.amber,
                        onChanged: (v) {
                          setDialog(() {
                            tempScale = v;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  image = picked;
                                  imageBytes = bytes;
                                  imageOffset = tempOffset;
                                  imageScale = tempScale;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Confirm"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildImage(bool isLightMode) {
    if (imageBytes == null) {
      // Camera icon – visible in both modes
      return Icon(
        Icons.add_a_photo,
        size: 36,
        color: isLightMode ? Colors.grey[800] : Colors.white70,
      );
    }
    return ClipOval(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(imageOffset.dx, imageOffset.dy)
            ..scale(imageScale, imageScale),
          child: Image.memory(
            imageBytes!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = !widget.isDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: widget.isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1A2A3A), Color(0xFF0F2027)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 40,
              ),
              child: Center(
                child: Card(
                  elevation: 12,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: widget.isDark
                          ? Colors.black.withOpacity(0.85)
                          : Colors.white,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Mamoun DarIssa Form",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  widget.isDark ? Icons.light_mode : Icons.dark_mode,
                                  color: widget.isDark ? Colors.amber : Colors.indigo,
                                ),
                                onPressed: widget.toggleTheme,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Profile Picture",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            onEnter: (_) => setState(() => isHovering = true),
                            onExit: (_) => setState(() => isHovering = false),
                            child: GestureDetector(
                              onTap: pickImage,
                              child: AnimatedScale(
                                scale: isHovering ? 1.05 : 1.0,
                                duration: const Duration(milliseconds: 180),
                                child: CircleAvatar(
                                  radius: 80,
                                  // FIXED: visible background in light mode
                                  backgroundColor: isLightMode
                                      ? Colors.grey[200]
                                      : Colors.white24,
                                  child: buildImage(isLightMode),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Input fields
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Username",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
                            ),
                            style: TextStyle(
                              color: isLightMode ? Colors.black87 : Colors.white,
                            ),
                            onSaved: (v) => username = v!,
                            validator: (v) => v!.length < 4 ? "Minimum 4 characters" : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
                            ),
                            style: TextStyle(
                              color: isLightMode ? Colors.black87 : Colors.white,
                            ),
                            onSaved: (v) => password = v!,
                            validator: (v) => v!.length < 8 ? "Minimum 8 characters" : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
                            ),
                            style: TextStyle(
                              color: isLightMode ? Colors.black87 : Colors.white,
                            ),
                            onSaved: (v) => email = v!,
                            validator: (v) =>
                                !RegExp(r'\S+@\S+\.\S+').hasMatch(v!) ? "Invalid email" : null,
                          ),

                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor: Colors.amber,
                                onChanged: (v) => setState(() => rememberMe = v!),
                              ),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                  color: isLightMode ? Colors.black87 : Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                "Gender: ",
                                style: TextStyle(
                                  color: isLightMode ? Colors.black87 : Colors.white70,
                                ),
                              ),
                              Radio(
                                value: "Male",
                                groupValue: gender,
                                activeColor: Colors.amber,
                                onChanged: (v) => setState(() => gender = v!),
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                  color: isLightMode ? Colors.black87 : Colors.white70,
                                ),
                              ),
                              Radio(
                                value: "Female",
                                groupValue: gender,
                                activeColor: Colors.amber,
                                onChanged: (v) => setState(() => gender = v!),
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: isLightMode ? Colors.black87 : Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          DropdownButtonFormField(
                            value: country,
                            items: countries
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setState(() => country = v!),
                            decoration: InputDecoration(
                              labelText: "Country",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              filled: true,
                              fillColor: isLightMode ? Colors.grey[100] : Colors.grey[900],
                            ),
                            dropdownColor: isLightMode ? Colors.white : Colors.grey[800],
                            style: TextStyle(
                              color: isLightMode ? Colors.black87 : Colors.white,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            "Age: ${age.toInt()}",
                            style: TextStyle(
                              color: isLightMode ? Colors.black87 : Colors.white70,
                            ),
                          ),
                          Slider(
                            value: age,
                            min: 10,
                            max: 60,
                            activeColor: Colors.amber,
                            onChanged: (v) => setState(() => age = v),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  date == null
                                      ? "No date selected"
                                      : "${date!.toLocal()}".split(' ')[0],
                                  style: TextStyle(
                                    color: isLightMode ? Colors.black87 : Colors.white70,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: isLightMode ? Colors.black87 : Colors.white70,
                                ),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() => date = picked);
                                  }
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 4,
                            ),
                            onPressed: loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() => loading = true);
                                      await Future.delayed(const Duration(seconds: 1));
                                      setState(() => loading = false);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SuccessPage(
                                            username: username,
                                            email: email,
                                            gender: gender,
                                            country: country,
                                            age: age.toInt(),
                                            date: date,
                                            rememberMe: rememberMe,
                                            image: image,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: loading
                                ? const CircularProgressIndicator(color: Colors.black)
                                : const Text(
                                    "Submit",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}