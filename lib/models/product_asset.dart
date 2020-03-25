class ProductAssetCombination {
  final ProductAsset original;
  final ProductAsset preview;
  final ProductAsset thumbnail;
  final ProductAsset placeholder;
  final ProductAsset originalWebp;
  final ProductAsset previewWebp;
  final ProductAsset thumbnailWebp;
  final ProductAsset placeholderWebp;

  ProductAssetCombination(
    this.original,
    this.preview,
    this.thumbnail,
    this.placeholder,
    this.originalWebp,
    this.previewWebp,
    this.thumbnailWebp,
    this.placeholderWebp,
  );
}

class ProductAsset {
  final String contentType;
  final String downloadURL;
  final String name;
  final int size;

  ProductAsset({this.contentType, this.downloadURL, this.name, this.size});

  Map<String, String> toMapForOrder() {
    Map<String, String> assetMap = Map<String, String>();
    //TODO
    // assetMap['url'] = thumbnail??preview??downloadURL??"";
    assetMap['url'] = downloadURL ?? "";
    assetMap['contentType'] = contentType;
    return assetMap;
  }

  factory ProductAsset.fromMap(Map data) {
    data = data ?? {};

    return ProductAsset(
      contentType: data['contentType'] ?? '',
      downloadURL: data['downloadURL'] ?? '',
      name: data['name'] ?? '',
      size: data['size'],
    );
  }
}
