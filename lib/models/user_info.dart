import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';


class UKUserInfo {
  final String name;
  final String mobile;
  UKUserInfo({
    this.name,
    this.mobile,
  });

  Map<String, dynamic> toMapForFirebase() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['name'] = name;
    map['mobile'] = mobile;
    return map;
  }

  factory UKUserInfo.fromFirebaseUser(FirebaseUser user) {
    String name = user.displayName;
    String email = user.email;
    String mobile = user.phoneNumber;

    return UKUserInfo(
      name: name,
      mobile: mobile,
    );
  }
  factory UKUserInfo.fromFirestore(DocumentSnapshot doc) {
    DateTime dob;
    String name;
    String email;
    String mobile;
    bool isEmailVerified;
    bool isMobileVerified;
    if (doc.exists) {
      Map data = doc.data;
      name = data['name'];
      mobile = data['mobile'];
    } else {
      name = null;
      mobile = null;
    }
    return UKUserInfo(
      name: name,
      mobile: mobile,
    );
  }
}
