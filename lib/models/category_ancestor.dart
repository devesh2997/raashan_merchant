class Ancestor {
  final String cid;
  final String name;

  Ancestor({this.cid, this.name});

  factory Ancestor.fromMap(Map data) {
    data = data ?? {};
    return Ancestor(
      cid: data['cid'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
