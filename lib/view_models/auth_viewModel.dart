import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/view_models/user_info_viewModel.dart';

class auth_viewModel {
  final FirebaseAuth _firebaseAuth;

  auth_viewModel(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  User CurrentUser() => _firebaseAuth.currentUser;

  Future<User> AnonymousOrCurrent() async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    }
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<UserCredential> signUp(
      {String email,
      String password,
      String fullName,
      String phoneNumber,
      String governorate,
      String address}) async {
    if (_firebaseAuth.currentUser.isAnonymous) {
      try {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        UserCredential result =
            await _firebaseAuth.currentUser.linkWithCredential(credential);
        User user = result.user;

        await user_info_viewModel(uid: user.uid)
            .addUserData(fullName, phoneNumber, governorate, address);
        return result;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        UserCredential result = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        User user = result.user;

        await user_info_viewModel(uid: user.uid)
            .addUserData(fullName, phoneNumber, governorate, address);
        return result;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
