import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class MerchantInfo {
  final String name;
  final String mobile;
  final List<String> shopMobiles;
  final String email;
  final String aadharNum;
  final String panNum;
  final String gstNum;
  final String shopAddress;
  final String address;
  final List<String> goodsTypes;
  final int staffNum;
  final int deliveryStaffNum;
  final int openTime;
  final int closeTime;
  final List<int> openDays;

  MerchantInfo({
    this.name,
    this.mobile,
    this.shopMobiles,
    this.email,
    this.aadharNum,
    this.panNum,
    this.gstNum,
    this.shopAddress,
    this.address,
    this.goodsTypes,
    this.staffNum,
    this.deliveryStaffNum,
    this.openTime,
    this.closeTime,
    this.openDays,
  });

  Map<String, dynamic> toMapForFirebase() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['name'] = name;
    map['mobile'] = mobile;
    map['shopMobiles'] = shopMobiles;
    map['email'] = email;
    map['aadharNum'] = aadharNum;
    map['panNum'] = panNum;
    map['gstNum'] = gstNum;
    map['shopAddress'] = shopAddress;
    map['address'] = address;
    map['goodsTypes'] = goodsTypes;
    map['staffNum'] = staffNum;
    map['deliveryStaffNum'] = deliveryStaffNum;
    map['openTime'] = openTime;
    map['closeTime'] = closeTime;
    map['openDays'] = openDays;
    return map;
  }

  // factory MerchantInfo.fromFirebaseUser(FirebaseUser user) {
  //   String name = user.displayName;
  //   String email = user.email;
  //   String mobile = user.phoneNumber;

  //   return MerchantInfo(
  //     name: name,
  //     mobile: mobile,
  //   );
  // }
  factory MerchantInfo.fromFirestore(DocumentSnapshot doc) {
    String name;
    String email;
    String mobile;
    List<String> shopMobiles;
    String aadharNum;
    String panNum;
    String gstNum;
    String shopAddress;
    String address;
    List<String> goodsTypes;
    int staffNum;
    int deliveryStaffNum;
    int openTime;
    int closeTime;
    List<int> openDays;
    if (doc.exists) {
      Map data = doc.data;
      name = data['name'];
      mobile = data['mobile'];
      shopMobiles = data['shopMobiles'];
      email = data['email'];
      aadharNum = data['aadharNum'];
      panNum = data['panNum'];
      gstNum = data['gstNum'];
      shopAddress = data['shopAddress'];
      address = data['address'];
      goodsTypes = data['goodsTypes'];
      staffNum = data['staffNum'];
      deliveryStaffNum = data['deliveryStaffNum'];
      openTime = data['openTime'];
      closeTime = data['closeTime'];
      openDays = data['openDays'];
    } else {
      name = null;
      mobile = null;
      shopMobiles = null;
      email = null;
      aadharNum = null;
      panNum = null;
      gstNum = null;
      shopAddress = null;
      address = null;
      goodsTypes = null;
      staffNum = null;
      deliveryStaffNum = null;
      openTime = null;
      closeTime = null;
      openDays = null;
    }
    return MerchantInfo(
        name: name,
        mobile: mobile,
        shopMobiles: shopMobiles,
        email: email,
        aadharNum: aadharNum,
        panNum: panNum,
        gstNum: gstNum,
        shopAddress: shopAddress,
        address: address,
        goodsTypes: goodsTypes,
        staffNum: staffNum,
        deliveryStaffNum: deliveryStaffNum,
        openDays: openDays,
        openTime: openTime,
        closeTime: closeTime);
  }
}
