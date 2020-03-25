import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:raashan_merchant/models/user_info.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  CodeSent,
  LoadingUserInfo
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  UKUserInfo _userInfo;
  bool loadingUserInfo;
  Firestore _db;
  Status _status = Status.Uninitialized;
  String message = "";

  String _verificationId;

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _db = Firestore.instance {
    loadingUserInfo = false;
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  UKUserInfo get userInfo => _userInfo;

  void reset() {
    _status = Status.Unauthenticated;
    message = "";
    _verificationId = null;
    notifyListeners();
  }

  Future<bool> verifyPhoneNumber(_phoneNumber) async {
    message = "";
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      message = authException.message;
      _status = Status.Unauthenticated;
      notifyListeners();
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _status = Status.CodeSent;
      _verificationId = verificationId;
      notifyListeners();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithPhoneNumber(_smsCode) async {
    message = "";
    notifyListeners();

    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithCredential(credential);
      return true;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_CREDENTIAL":
          message = "Invalid code. Try again";
          break;
        case "ERROR_INVALID_VERIFICATION_CODE":
          message = "Invalid code. Try again";
          break;
        default:
          print(message);
          message = "Some error occured. Try again later.";
          break;
      }
      showToast(message);
      _status = Status.CodeSent;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    if (user != null) {
      _firebaseMessaging.unsubscribeFromTopic(user.uid);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');
      prefs.remove('gender');
      prefs.remove('dob');
    }
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _userInfo = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      fetchUserInfo();
    }
    notifyListeners();
  }

  Future<void> fetchUserInfo() async {
    if (user == null) {
      signOut();
      return;
    }

    //Subscribe to uid for notifications
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.subscribeToTopic(user.uid);

    loadingUserInfo = true;
    notifyListeners();

    _db
        .collection('users')
        .document(_user.uid)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        _userInfo = UKUserInfo.fromFirestore(snapshot);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', user.uid);
        // await mergeAuthAndUserInfo(_user, _userInfo);
        loadingUserInfo = false;
        notifyListeners();
      } else {
        Future.delayed(Duration(seconds: 5), () async {
          if (loadingUserInfo) {
            if (_userInfo == null) {
              await createUserInfo(user);
            }
          }
        });
        // UKUserInfo userInfo = UKUserInfo.fromFirebaseUser(user);
        // await _db
        //     .collection('users')
        //     .document(user.uid)
        //     .setData(userInfo.toMapForFirebase(), merge: true);
      }
    });
  }

  Future<void> createUserInfo(FirebaseUser user) async {
    print('creating user on client');
    String email = user.email; // The email of the user.
    String name = user.displayName; // The display name of the user.
    String mobile = user.phoneNumber;
    if (name == null) {
      name = '';
    }
    if (mobile == null) {
      mobile = '';
    }

    Map<String, dynamic> info = Map<String, dynamic>();
    info['name'] = name;
    info['mobile'] = mobile;
    info['created_at'] = DateTime.now().millisecondsSinceEpoch;

    await _db.collection('merchants').document(user.uid).setData(info, merge: true);
  }

  // Future<void> mergeAuthAndUserInfo(
  //     FirebaseUser user, UKUserInfo userInfo) async {
  //   Map<String, dynamic> info = Map<String, dynamic>();
  //   bool flag = false;
  //   if (userInfo.name == null && user.displayName != null) {
  //     info['name'] = user.displayName;
  //     flag = true;
  //   }
  //   if (userInfo.email == null && user.email != null) {
  //     info['email'] = user.email;
  //     info['isEmailVerified'] = user.isEmailVerified;
  //     flag = true;
  //   }
  //   if (userInfo.mobile == null && user.phoneNumber != null) {
  //     info['mobile'] = user.phoneNumber;
  //     info['isMobileVerified'] =
  //         user.phoneNumber != null && user.phoneNumber.length > 0;
  //     flag = true;
  //   }
  //   if (flag) {
  //     await _db
  //         .collection('users')
  //         .document(user.uid)
  //         .setData(info, merge: true);
  //   }
  // }

  Future<void> updateUserInfo(
      {String name,
      String mobile}) async {
    Map<String, dynamic> userInfoMap = Map();
    if (name != null && name.length > 0) {
      userInfoMap['name'] = name;
    }
    if (mobile != null && mobile.length >= 10) {
      userInfoMap['mobile'] = mobile;
    }
    try {
      await _db
          .collection('users')
          .document(_user.uid)
          .setData(userInfoMap, merge: true);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setDisplayName(String displayName) async {
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = displayName;
    await _user.updateProfile(userUpdateInfo);
    await _user.reload();
    _user = await _auth.currentUser();
    notifyListeners();
  }

}
