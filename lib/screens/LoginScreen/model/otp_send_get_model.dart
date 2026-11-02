class OtpDataModel {
  final String verificationId;
  final String? phoneNumber;

  OtpDataModel({
    required this.verificationId,
    this.phoneNumber,
  });

  OtpDataModel copyWith({
    String? verificationId,
    String? phoneNumber,
  }) {
    return OtpDataModel(
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
