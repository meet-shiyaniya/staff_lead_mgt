import 'package:flutter/material.dart';

import 'colors/colors.dart';
import 'login_screen/login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscureCreatePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/images/login/newlogin.png', height: 200, width: 200),
            const SizedBox(height: 20),
            const Text(
              'Welcome Back! Let\'s get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mobile Number TextField
                  TextFormField(
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Mobile Number',
                      hintText: 'Enter your mobile number',
                      prefixIcon: Icon(Icons.verified, color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Create Password TextField
                  TextFormField(
                    controller: createPasswordController,
                    obscureText: _obscureCreatePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Create Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCreatePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCreatePassword = !_obscureCreatePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please create a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password TextField
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != createPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Login Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Welcome!',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold)),
                              content: Text(
                                  'Welcome back, ${mobileNumberController.text}!',
                                  style: const TextStyle(fontFamily: 'Poppins')),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK',
                                      style: TextStyle(fontFamily: 'Poppins')),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Forgot Password
                  TextButton(
                    onPressed: () {
                      // Forgot Password Logic
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(fontFamily: 'Poppins', color: AppColors.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // New User Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('New User? ',
                          style: TextStyle(fontFamily: 'Poppins')),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: const Text('Create an Account',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.blue)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}