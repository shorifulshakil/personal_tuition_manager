class Student {
  final int id;
  final String name;
  final String mobile;
  final DateTime createdAt;
  final String? address;
  final String? fatherName;
  final String? fatherMobile;
  final String? batchTime;

  Student({
    required this.id,
    required this.name,
    required this.mobile,
    required this.createdAt,
    this.address,
    this.fatherName,
    this.fatherMobile,
    this.batchTime,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      address: json['address'],
      fatherName: json['fatherName'],
      fatherMobile: json['fatherMobile'],
      batchTime: json['batchTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'createdAt': createdAt.toIso8601String(),
      'address': address,
      'fatherName': fatherName,
      'fatherMobile': fatherMobile,
      'batchTime': batchTime,
    };
  }

  Student copy({
    int? id,
    String? name,
    String? mobile,
    DateTime? createdAt,
    String? address,
    String? fatherName,
    String? fatherMobile,
    String? batchTime,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      fatherName: fatherName ?? this.fatherName,
      fatherMobile: fatherMobile ?? this.fatherMobile,
      batchTime: batchTime ?? this.batchTime,
    );
  }
}
