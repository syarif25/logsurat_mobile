class UserModel {
  final String name;
  final String jabatan;

  UserModel({
    required this.name,
    required this.jabatan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name']?.toString() ?? '',
      jabatan: json['jabatan']?['nama_jabatan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'jabatan': {
        'nama_jabatan': jabatan,
      },
    };
  }
}
