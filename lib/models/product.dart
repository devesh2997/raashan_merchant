import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:raashan_merchant/models/category.dart';
import 'package:raashan_merchant/models/product_asset.dart';
import 'package:raashan_merchant/utils/utils.dart';

class ProductAttributes {
  Map<dynamic, dynamic> attributes;
  ProductAttributes({@foundation.required this.attributes});

  factory ProductAttributes.fromMap(Map data) {
    data = data ?? {};
    return ProductAttributes(attributes: data);
  }

  Map<dynamic, dynamic> toMapForOrder() {
    return attributes;
  }
}

class Product {
  final String pid;
  final String title;
  final int listPrice;
  final int discount;
  final Category category;
  final List<dynamic> description;
  final List<ProductAssetCombination> assets;
  final ProductAttributes attributes;

  Product({
    @foundation.required this.pid,
    @foundation.required this.title,
    @foundation.required this.listPrice,
    @foundation.required this.discount,
    @foundation.required this.category,
    @foundation.required this.description,
    @foundation.required this.assets,
    @foundation.required this.attributes,
  });

  Map<String, dynamic> toMapForOrder() {
    Map<String, String> asset = Map();
    asset['url'] = getThumbnailSizedURL(assets[0]);
    asset['contentType'] = assets[0].original.contentType ?? "";

    Map<String, dynamic> productMap = Map<String, dynamic>();
    productMap['pid'] = pid;
    productMap['title'] = title;
    productMap['listPrice'] = listPrice;
    productMap['discount'] = discount;
    productMap['category'] = category.toMapForOrder();
    productMap['asset'] = asset;
    productMap['attributes'] = attributes.toMapForOrder();
    return productMap;
  }

  factory Product.fromFirestore(
      DocumentSnapshot doc, List<String> wishlistedProductIDs) {
    Map data = doc.data;
    data['pid'] = doc.documentID;

    List<ProductAssetCombination> assets = [];

    Map assetsDoc = data['assets'];

    List<ProductAsset> originalAssets = [];
    List<ProductAsset> notOriginalAssetsList = [];
    assetsDoc.forEach(
      (name, asset) {
        List<String> nameParts = name.toString().split('.');
        if (nameParts.length <= 2)
          originalAssets.add(ProductAsset.fromMap(asset));
        else
          notOriginalAssetsList.add(ProductAsset.fromMap(asset));
      },
    );

    originalAssets.sort((a, b) {
      int anum = getSingleDigitIntegerInString(a.name);
      int bnum = getSingleDigitIntegerInString(b.name);
      return anum > bnum ? 1 : 0;
    });

    for (int i = 0; i < originalAssets.length; i++) {
      ProductAssetCombination productAssetCombination;
      ProductAsset original = originalAssets[i];
      ProductAsset preview;
      ProductAsset thumbnail;
      ProductAsset originalWebp;
      ProductAsset previewWebp;
      ProductAsset thumbnailWebp;
      ProductAsset placeholder;
      ProductAsset placeholderWebp;
      String originalName = original.name.split('.')[0];
      for (int j = 0; j < notOriginalAssetsList.length; j++) {
        String notOriginalAssetName = notOriginalAssetsList[j].name;
        String notOriginalAssetNameFirstPart =
            notOriginalAssetsList[j].name.split('.')[0];
        if (notOriginalAssetNameFirstPart != originalName) continue;
        if (notOriginalAssetName.contains('thumbnail')) {
          if (notOriginalAssetName.contains('webp')) {
            thumbnailWebp = notOriginalAssetsList[j];
          } else {
            thumbnail = notOriginalAssetsList[j];
          }
        } else if (notOriginalAssetName.contains('preview')) {
          if (notOriginalAssetName.contains('webp')) {
            previewWebp = notOriginalAssetsList[j];
          } else {
            preview = notOriginalAssetsList[j];
          }
        } else if (notOriginalAssetName.contains('placeholder')) {
          if (notOriginalAssetName.contains('webp')) {
            placeholderWebp = notOriginalAssetsList[j];
          } else {
            placeholder = notOriginalAssetsList[j];
          }
        } else if (notOriginalAssetName.contains('webp')) {
          originalWebp = notOriginalAssetsList[j];
        }
      }
      productAssetCombination = ProductAssetCombination(
        original,
        preview,
        thumbnail,
        placeholder,
        originalWebp,
        previewWebp,
        thumbnailWebp,
        placeholderWebp,
      );
      assets.add(productAssetCombination);
    }

    Category category = Category.fromMap(data['category']);

    int discount = data['discount'] ?? 0;
    int listPrice = data['listPrice'] ?? 0;

    return Product(
      pid: data['pid'] ?? '',
      title: data['title'] ?? '',
      listPrice: listPrice,
      discount: discount,
      category: category,
      description: data['description'] ?? List(),
      assets: assets,
      attributes: ProductAttributes.fromMap(data['attributes']),
    );
  }
}
