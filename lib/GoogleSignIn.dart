import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInPage extends StatefulWidget {
  GoogleSignInPage(this.onSignedInCallback, {Key? key}) : super(key: key);
  Function onSignedInCallback;

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? uid;
  String? userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 200,
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () async {
                    signInWithGoogle();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future signInWithGoogle() async {
    // Initialize Firebase

    User? user;
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount == null) return;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential? authResult;
    authResult = await _auth.signInWithCredential(credential);

    if (authResult != null) {
      user = authResult.user!;
    }
    // The `GoogleAuthProvider` can only be used while running on the web
    // GoogleAuthProvider authProvider = GoogleAuthProvider();

    // try {
    //   final UserCredential userCredential =
    //       await _auth.signInWithPopup(authProvider);

    //   user = userCredential.user;
    //   print(user);
    // } catch (e) {
    //   print(e);
    // }

    if (user != null) {
      debugPrint("User is signed in");
      widget.onSignedInCallback();
      uid = user.uid;
      //  name = user.displayName;
      userEmail = user.email;
      //  imageUrl = user.photoURL;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
    }

    // return user;
  }
}
