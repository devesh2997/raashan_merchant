class Ancestor {
  final String cid;
  final String name;
  final String slug;

  Ancestor({this.cid, this.name, this.slug});

  factory Ancestor.fromMap(Map data) {
    data = data ?? {};
    return Ancestor(
      cid: data['cid'] ?? '',
      name: data['name'] ?? '',
      slug: data['slug'] ?? '',
    );
  }
}
