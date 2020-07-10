class UserModel {
  String id;
  String chooseType;
  String name;
  String user;
  String password;

  UserModel({this.id, this.chooseType, this.name, this.user, this.password});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['chooseType'];
    name = json['name'];
    user = json['user'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chooseType'] = this.chooseType;
    data['name'] = this.name;
    data['user'] = this.user;
    data['password'] = this.password;
    return data;
  }
}
