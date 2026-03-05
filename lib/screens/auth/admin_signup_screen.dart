import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard_screen.dart';

class AdminSignupScreen extends ConsumerStatefulWidget {
  const AdminSignupScreen({super.key});

  @override
  ConsumerState<AdminSignupScreen> createState() =>
      _AdminSignupScreenState();
}

class _AdminSignupScreenState
    extends ConsumerState<AdminSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 10,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [


                      const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 52,
                        color: Color(0xFF1F2937),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Create Admin Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Register new administrator access",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text("Full Name"),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration("Enter full name"),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? "Enter full name"
                            : null,
                      ),

                      const SizedBox(height: 20),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text("Email"),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration("Enter email"),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? "Enter email"
                            : null,
                      ),

                      const SizedBox(height: 20),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text("Password"),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: _inputDecoration("Minimum 6 characters")
                            .copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword =
                                !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.length < 6
                            ? "Minimum 6 characters"
                            : null,
                      ),

                      const SizedBox(height: 20),


                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text("Confirm Password"),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscurePassword,
                        decoration:
                        _inputDecoration("Re-enter password"),
                        validator: (value) {
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),


                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF1F2937),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: signup,
                          child: const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),


                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  void signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final authService = ref.read(authServiceProvider);

    final error = await authService.signUp(
      fullName: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully 🎉"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );


      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
        ),
      );
    }
  }
}