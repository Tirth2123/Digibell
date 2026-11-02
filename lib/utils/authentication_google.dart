// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/app_constants.dart';
//
// class Authentication {
//   static FirebaseAuth auth = FirebaseAuth.instance;
//
//   static SnackBar customSnackBar({required String content}) {
//     return SnackBar(
//       backgroundColor: Colors.white,
//       content: Text(
//         content,
//         style: TextStyle(color: Colors.black54, letterSpacing: 0.5),
//       ),
//     );
//   }
//
//   static Future<FirebaseApp> initializeFirebase({
//     required BuildContext context,
//   }) async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();
//
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       final SharedPreferences preferences = await SharedPreferences.getInstance();
//       preferences.setBool(AppConstants.login, true);
//       /*Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => HomeScreen(),
//         ),
//       );*/
//     }
//
//     return firebaseApp;
//   }
//
//   static Future<User?> signInWithGoogle({required BuildContext context}) async {
//     User? user;
//
//     if (kIsWeb) {
//       GoogleAuthProvider authProvider = GoogleAuthProvider();
//
//       try {
//         final UserCredential userCredential = await auth.signInWithPopup(authProvider);
//
//         user = userCredential.user;
//       } catch (e) {
//       }
//     } else {
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//
//       final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//
//         try {
//           final UserCredential userCredential = await auth.signInWithCredential(credential);
//           user = userCredential.user;
//         } on FirebaseAuthException catch (e) {
//           if (e.code == 'account-exists-with-different-credential') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               Authentication.customSnackBar(
//                 content: 'The account already exists with a different credential',
//               ),
//             );
//           } else if (e.code == 'invalid-credential') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               Authentication.customSnackBar(
//                 content: 'Error occurred while accessing credentials. Try again.',
//               ),
//             );
//           }
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             Authentication.customSnackBar(
//               content: 'Error occurred using Google Sign In. Try again.',
//             ),
//           );
//         }
//       }
//     }
//
//     return user;
//   }
//
//   static Future<void> signOut({required BuildContext context}) async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//
//     try {
//       if (!kIsWeb) {
//         await googleSignIn.signOut();
//         //await FacebookAuth.instance.logOut();
//       }
//       await FirebaseAuth.instance.signOut();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         Authentication.customSnackBar(
//           content: 'Error signing out. Try again.',
//         ),
//       );
//     }
//   }
//
//
//
//   static Future<User?> signInWithFacebook(BuildContext context) async {
//     User? user;
//
//     try {
//       final LoginResult result = await FacebookAuth.instance.login();
//
//
//
//       if (result.status == LoginStatus.success) {
//         // final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
//         // final userCredential = await auth.signInWithCredential(facebookCredential);
//         // user = userCredential.user;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           Authentication.customSnackBar(
//             content: result.message!,
//           ),
//         );
//         user = null;
//       }
//     } on FirebaseAuthException catch (e) {
//       user = null;
//       //AlertUtils.showManuallyCloseDialogue(context, e.message ?? 'Please try again', 3, 'Oops!');
//     } on Exception catch (e) {
//       throw e;
//     }
//
//     return user;
//   }
// }
