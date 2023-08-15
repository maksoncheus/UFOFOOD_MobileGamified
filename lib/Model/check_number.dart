class CheckResponsePhone {
  String code;
  CheckResponsePhone({
    required this.code,
  });

  factory CheckResponsePhone.fromJson(Map<String, dynamic> json) =>
      CheckResponsePhone(code: json['code']);
}

class CheckResponsePhoneNumber {
  int id;
  String firstName;
  String lastName;
  String phone;
  CheckResponsePhoneNumber({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });
}

class CheckResponseCode {
  String code;
  CheckResponseCode({
    required this.code,
  });
}
