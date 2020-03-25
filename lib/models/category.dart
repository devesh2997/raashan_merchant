import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raashan_merchant/models/category_ancestor.dart';

class Category {
  final String cid;
  final String name;
  final String parent;
  final String sku;
  final String slug;
  final List<Ancestor> ancestors;

  Category(
      {this.cid, this.name, this.parent, this.sku, this.slug, this.ancestors});

  Map<String, dynamic> toMapForOrder(){
    Map<String, dynamic> categoryMap = Map<String, dynamic>();
    categoryMap['cid'] = cid;
    categoryMap['name'] = name;
    categoryMap['slug'] = slug;
    return categoryMap;
  }

  factory Category.fromMap(Map data) {
    data = data ?? {};

    List ancestorsData = data['ancestors'] ?? [];
    List<Ancestor> ancestors = [];

    ancestorsData
        .forEach((ancestor) => (ancestors.add(Ancestor.fromMap(ancestor))));

    return Category(
      cid: data['cid'],
      name: data['name'] ?? '',
      parent: data['parent'] ?? '',
      sku: data['sku'] ?? '',
      slug: data['slug'] ?? '',
      ancestors: ancestors,
    );
  }

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    List ancestorsData = data['ancestors'] ?? [];
    List<Ancestor> ancestors = [];

    ancestorsData
        .forEach((ancestor) => (ancestors.add(Ancestor.fromMap(ancestor))));

    return Category(
      cid: doc.documentID,
      name: data['name'] ?? '',
      parent: data['parent'] ?? '',
      sku: data['sku'] ?? '',
      slug: data['slug'] ?? '',
      ancestors: ancestors,
    );
  }
}
