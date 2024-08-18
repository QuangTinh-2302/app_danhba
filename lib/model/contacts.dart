  class Contacts{
    final int id;
    final String name;
    final String phone;
    final bool status;

    Contacts(this.id, this.name, this.phone, this.status);

    factory Contacts.fromJson(Map<String, dynamic> json) {
      return Contacts(
        json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        json['name'] as String,
        json['phone'] as String,
        json['status'] is bool
            ? json['status']
            : (json['status'] is int
            ? json['status'] == 1
            : json['status'].toString().toLowerCase() == 'true'|| json['status'].toString() == '1'),
      );
    }
  }