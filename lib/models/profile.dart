class Profile {
  String? image;
  String? username;
  String? email;
  String? mobile;

  Profile({this.image, this.username, this.email, this.mobile});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    image: json['Image']?.toString(),
    username: json['username']?.toString(),
    email: json['email']?.toString(),
    mobile: json['mobile']?.toString(),
  );
}
