// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();

//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//       if (googleSignInAccount == null) {
//         // User canceled the sign-in
//         return null;
//       }

//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential authResult = await _auth.signInWithCredential(credential);
//       return authResult.user;
//     } catch (error) {
//       print("Error signing in with Google: $error");
//       return null;
//     }
//   }

//   Future<User?> signUpWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//       if (googleSignInAccount == null) {
//         // User canceled the sign-up
//         return null;
//       }

//       final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );

//       final UserCredential authResult = await _auth.signInWithCredential(credential);

//       return authResult.user;
//     } catch (error) {
//       print('Error signing up with Google: $error');
//       return null;
//     }
//   }

//   Future<void> signOutWithGoogle() async {
//     await googleSignIn.signOut();
//     await _auth.signOut();
//   }

//   Future<User?> signUpWithEmailAndPassword(String email, String password) async {
//     try {
//       // Check if the email is already registered with Google
//       bool isGoogleUser = await isEmailRegisteredWithGoogle(email);

//       if (isGoogleUser) {
//         // If the email is registered with Google, show an error or handle accordingly
//         print("Error: Email is already registered with Google.");
//         return null;
//       }

//       // If the email is not registered with Google, proceed with email/password sign up
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (error) {
//       print("Error registering user: $error");
//       return null;
//     }
//   }

//   // Helper function to check if the email is registered with Google
//   Future<bool> isEmailRegisteredWithGoogle(String email) async {
//     try {
//       GoogleSignInAccount? existingUser = await GoogleSignIn().signInSilently();

//       if (existingUser != null && existingUser.email == email) {
//         return true;
//       }

//       return false;
//     } catch (error) {
//       print("Error checking if email is registered with Google: $error");
//       return false;
//     }
//   }

//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential.user;
//     } catch (error) {
//       print("Error signing in: $error");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _auth.signOut();
//     } catch (error) {
//       print("Error signing out: $error");
//     }
//   }

//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (error) {
//       print("Error resetting password: $error");
//     }
//   }
// }

// final AuthService authService = AuthService();
