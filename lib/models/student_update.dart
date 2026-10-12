import 'student_model.dart';

class StudentUpdate {
  int? id;
  String? name;
  String? mobile;
  String? address;
  String? fatherName;
  String? fatherMobile;
  String? batchTime;

  StudentUpdate({
    this.id,
    this.name,
    this.mobile,
    this.address,
    this.fatherName,
    this.fatherMobile,
    this.batchTime,
  });

  StudentUpdate.fromStudent(Student student) {
    id = student.id;
    name = student.name;
    mobile = student.mobile;
    address = student.address;
    fatherName = student.fatherName;
    fatherMobile = student.fatherMobile;
    batchTime = student.batchTime;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mobile != null) 'mobile': mobile,
      if (address != null) 'address': address,
      if (fatherName != null) 'fatherName': fatherName,
      if (fatherMobile != null) 'fatherMobile': fatherMobile,
      if (batchTime != null) 'batchTime': batchTime,
    };
  }
}
