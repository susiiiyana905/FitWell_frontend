class UploadUser {
  String? email;
  String? password;
  String? confirmPassword;
  String? profileName;

  UploadUser({
    this.email,
    this.password,
    this.confirmPassword,
    this.profileName,
  });
}

class UploadGoogleUser {
  String? email;
  String? profileName;
  String? profilePicture;

  UploadGoogleUser({
    this.email,
    this.profileName,
    this.profilePicture,
  });
}
