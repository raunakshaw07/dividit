class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? dob;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.dob,
  });

  User.fromMap(Map<String, dynamic> user) {
    id = user['id'];
    name = user['name'];
    email = user['email'];
    phone = user['phone'];
    imageUrl = user['image_url'];
    createdAt =
        user['created_at'] != null ? DateTime.parse(user['created_at']) : null;
    updatedAt =
        user['updated_at'] != null ? DateTime.parse(user['updated_at']) : null;
    dob =
        user['dob'] != null && user['dob'].toString().isNotEmpty
            ? DateTime.parse(user['dob'])
            : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mappedUser = {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "dob": dob,
    };

    return mappedUser;
  }
}
