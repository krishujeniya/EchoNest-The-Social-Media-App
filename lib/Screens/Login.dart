// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:echonest/Services/Auth.dart';
import 'package:echonest/Screens/Feed.dart';
import 'package:echonest/Constants/Constants.dart';

class Login extends StatefulWidget {
    final Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
 final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHiddenPass = true;

  void _togglePasswordView() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }

  Icon buildKey() {
    return Icon(
      isHiddenPass ? Icons.visibility : Icons.visibility_off,
      color: ThemeMain,
    );
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
                  'assets/iw.png', // Replace with your logo asset path
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back, you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child:  TextFormField(
              controller: emailController,
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
                      cursorColor: ThemeMain,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: InkWell(onTap: _togglePasswordView, child: buildKey()),
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
                GestureDetector(
                  onTap: () async {
                bool isValid = await AuthService.login(emailController.text, passwordController.text);
                if (isValid) {
 Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => Feed(currentUserId: FirebaseAuth.instance.currentUser!.uid),
  ),
);
            } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed'),
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
                        "Sign In",
                        style: TextStyle(
                          color: ThemeMainBG,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your login details? ',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          AuthService.resetPassword(emailController.text,context);
                        },
                        child: const Text(
                          'Get help logging in.',
                          style: TextStyle(
                            color: ThemeMain,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[600],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'OR',
                //           style: TextStyle(color: Colors.grey[600]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[600],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () async {
                //         // // Handle Google sign-in
                //         // User? user = await authService.signInWithGoogle();

                //         // if (user != null) {
                //         //   // Successfully signed in
                //         //   print('User signed in with Google: ${user.displayName}');
                //         //   // Navigate to the next screen or perform other actions
                //         //   Navigator.pushReplacement(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) => const HomeScreen(),
                //         //     ),
                //         //   );
                //         // } else {
                //         //   // Sign-in failed
                //         //   print('Sign-in with Google failed.');
                //         // }
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: ThemeMain),
                //           borderRadius: BorderRadius.circular(20),
                //           color: Colors.grey[100],
                //         ),
                //         child: SvgPicture.asset(
                //           'assets/google.svg', // Replace with your Google icon asset path
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
                      'Not a member? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: ThemeMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
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
