class Contacts{
  final int? id;
  final String name;
  final String phone;

  Contacts(this.id, this.name, this.phone);

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      json['name'] as String,
      json['phone'] as String,
    );
  }
}