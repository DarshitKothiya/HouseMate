import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper{

  FirebaseAuthHelper._();

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signUpUser({required String email,required String password}) async{

    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  Future<User?> signInUser({required String email,required String password}) async{

    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    return userCredential.user;
  }

  Future<void> logOutUser() async{
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }



  Future<User?> signInWithGoogle() async {

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);

    return userCredential.user;



  }

}