import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pare/src/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  GeneralUser? generalUser;
  String? theError;

  Stream<DocumentSnapshot>? userSnapshot;

  //a void func to set the error message
  void setTheError(String? err) {
    theError = err;
    notifyListeners();
  }

  void checkTheUser() async {
    if (theUser != null) {
      if (await fetchUserInfo(theUser!.uid)) {
      } else {
        logOut();
      }
    }
  }

  AuthProvider() {
    checkTheUser();
  }

  // a void func which updates the value of the generalUser
  void setTheGeneralUser(GeneralUser theGUser) {
    generalUser = theGUser;
    debugPrint(generalUser.toString());

    if (theUser != null) {
      userSnapshot = FirebaseFirestore.instance
          .collection('users')
          .doc(theUser!.uid)
          .snapshots();

      userSnapshot?.listen((event) {
        generalUser = GeneralUser.fromMap(event.data() as Map<String, dynamic>);
        notifyListeners();
      });
    } else {
      userSnapshot = null;
    }

    notifyListeners();
  }

  Future<bool> fetchUserInfo(String uid) async {
    DocumentSnapshot _userSnap =
        await _firebaseFirestore.collection('users').doc(uid).get();
    if (_userSnap.exists) {
      //map the data to a general_user data model
      GeneralUser _generalUser =
          GeneralUser.fromMap(_userSnap.data() as Map<String, dynamic>);
      debugPrint('================================================');
      debugPrint((_userSnap.data() as Map<String, dynamic>).toString());
      debugPrint('================================================');
      setTheGeneralUser(_generalUser);
      return true;
    } else {
      return false;
    }
  }

  Stream<List<GeneralUser>?> fetchAllUsersStream() {
    return _firebaseFirestore.collection('users').snapshots().map((event) =>
        event.docs.map((e) => GeneralUser.fromMap(e.data())).toList());
  }

  User? theUser = FirebaseAuth
      .instance.currentUser; //to have the current user as the initial value

  void setTheUser(User? user) {
    theUser = user;
    generalUser = null;
    if (user != null) {
      fetchUserInfo(user.uid);
    }
    notifyListeners();
  }

  // logout method
  logOut() async {
    await _firebaseAuth.signOut();
    setTheUser(null);
  }

//method to register the user using email and password
// todo error handling
  Future<String> registerWithEmailAndPassword(
      String email, String password) async {
    String? errorMessage;
    try {
      UserCredential theUserCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      setTheError(null);

      return theUserCredentials.user?.uid ?? '';
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address is invalid";
          break;
        case "operation-not-allowed":
          errorMessage = "Your email address is invalid";
          break;
        case "weak-password":
          errorMessage = "Your password is wrong.";
          break;
        case "email-already-in-use":
          errorMessage = "User with this email has been disabled.";
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return theUser!.uid;
  }

//method to login the user using email and password
// error handling
  // Future<String> loginWithEmailAndPassword(
  //     String email, String password) async {
  //   String? errorMessage;
  //   try {
  //     UserCredential theUserCredentials = await _firebaseAuth
  //         .signInWithEmailAndPassword(email: email, password: password);
  //     setTheUser(theUserCredentials.user);
  //     // _firebaseFirestore
  //     //     .collection('users')
  //     //     .doc(theUserCredentials.user!.uid)
  //     //     .set({});
  //     //TODO: user from db
  //     setTheError(null);
  //     return theUserCredentials.user?.uid ?? '';
  //   } on FirebaseAuthException catch (error) {
  //     switch (error.code) {
  //       case "invalid-email":
  //         errorMessage = "Your email address is invalid";
  //         break;
  //       case "user-not-found":
  //         errorMessage = "Your email address is invalid";
  //         break;
  //       case "wrong-password":
  //         errorMessage = "Your password is wrong.";
  //         break;
  //       case "user-disabled":
  //         errorMessage = "User with this email has been disabled.";
  //         break;

  //       default:
  //         errorMessage = "An undefined Error happened.";
  //     }
  //   }

  //   if (errorMessage != null) {
  //     return Future.error(errorMessage);
  //   }
  //   return theUser!.uid;
  // }

  Future<String> signIn(String email, String password) async {
    String? errorMessage;

    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print(result.toString());
      theUser = result.user;
    } on FirebaseAuthException catch (error) {
      //return Future.error("Wrong Email or Password") ;
      print(error.code);
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address is invalid";
          break;
        case "user-not-found":
          errorMessage = "Your email address is invalid";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return theUser!.uid;
  }

  // Future<String> signIn(String email, String password) async {
  //   FirebaseUser user;
  //   String errorMessage;

  //   try {
  //     AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     user = result.user;
  //   } catch (error) {
  //     switch (error.code) {
  //       case "ERROR_INVALID_EMAIL":
  //         errorMessage = "Your email address appears to be malformed.";
  //         break;
  //       case "ERROR_WRONG_PASSWORD":
  //         errorMessage = "Your password is wrong.";
  //         break;
  //       case "ERROR_USER_NOT_FOUND":
  //         errorMessage = "User with this email doesn't exist.";
  //         break;
  //       case "ERROR_USER_DISABLED":
  //         errorMessage = "User with this email has been disabled.";
  //         break;
  //       case "ERROR_TOO_MANY_REQUESTS":
  //         errorMessage = "Too many requests. Try again later.";
  //         break;
  //       case "ERROR_OPERATION_NOT_ALLOWED":
  //         errorMessage = "Signing in with Email and Password is not enabled.";
  //         break;
  //       default:
  //         errorMessage = "An undefined Error happened.";
  //     }
  //   }

  //   if (errorMessage != null) {
  //     return Future.error(errorMessage);
  //   }

  //   return user.uid;
  // }

  Stream<User?> get authStatusChanges => _firebaseAuth.authStateChanges();

  Future<bool> resetPassword(String email) async {
    String? errorMessage;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "user-not-found":
          errorMessage = "Email not found";
          break;
        
        default:
          errorMessage = error.code;
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return true;
  }
}
