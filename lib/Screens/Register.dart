// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'package:echonest/Screens/Feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:echonest/Services/Auth.dart';
import 'package:echonest/Constants/Constants.dart';


class RegisterP extends StatefulWidget {
final Function()? onTap;
  const RegisterP({super.key, required this.onTap}) ;
  @override
  _RegisterPState createState() => _RegisterPState();
}

class _RegisterPState extends State<RegisterP> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isHiddenPass = true;

  void _tooglePasswordView() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }

  Icon buildKey() {
    if (isHiddenPass == true) {
      return const Icon(Icons.visibility, color: ThemeMain);
    } else {
      return const Icon(Icons.visibility_off, color: ThemeMain);
    }
  }  
  bool isHiddenPass2 = true;

  void _tooglePasswordView2() {
    setState(() {
      isHiddenPass2 = !isHiddenPass2;
    });
  }

  Icon buildKey2() {
    if (isHiddenPass2 == true) {
      return const Icon(Icons.visibility, color: ThemeMain);
    } else {
      return const Icon(Icons.visibility_off, color: ThemeMain);
    }
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/iw.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: nameController,
                      obscureText: false,
                      cursorColor: ThemeMain,
                     
                      decoration: InputDecoration(
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      
                    ),
                  ),
                ),                const SizedBox(height: 15),

                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: emailController,
                      obscureText: false,
                      cursorColor: ThemeMain,
                      validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                      decoration: InputDecoration(
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                     
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      
                      controller: passwordController,
obscureText: isHiddenPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },                      cursorColor: ThemeMain,
                      decoration: InputDecoration(
                                          suffixIcon: InkWell(onTap: _tooglePasswordView, child: buildKey()),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: confirmPasswordController,
 obscureText: isHiddenPass2, // Always hide confirm password
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },                      cursorColor: ThemeMain,
                      decoration: InputDecoration(
                                                            suffixIcon: InkWell(onTap: _tooglePasswordView2, child: buildKey2()),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap:  () async {
                bool isValid =
                    await AuthService.signUp(nameController.text, emailController.text, passwordController.text);
                if (isValid) {
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => Feed(currentUserId: FirebaseAuth.instance.currentUser!.uid),
  ),
);                         } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed'),
        ),
      );                }
              },
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: ThemeMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: ThemeMainBG,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'OR',
                //           style: TextStyle(color: Colors.grey.shade600),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         // Handle Google sign-in (replace with actual logic)
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: ThemeMain),
                //           borderRadius: BorderRadius.circular(20),
                //           color: Colors.grey[100],
                //         ),
                //         child: SvgPicture.asset(
                //           'assets/google.svg',
                //           height: 50,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: ThemeMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
