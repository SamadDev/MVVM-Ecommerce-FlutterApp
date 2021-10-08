import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/Services/Users_db.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  User CurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      CurrentUser();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<String> signUp(
      {String email,
      String password,
      String fullName,
      String phoneNumber,
      String governorate,
      String address}) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await users_dbServices(uid: user.uid)
          .addUserData(fullName, phoneNumber, governorate, address);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
