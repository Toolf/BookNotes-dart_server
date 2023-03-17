abstract class Access {
  get accessName;

  Access();

  Map<String, dynamic> toJson();
}

class Logged implements Access {
  Logged() : super();

  @override
  get accessName => "logged";

  @override
  Map<String, dynamic> toJson() {
    return {
      "accessName": accessName,
    };
  }

  static Logged fromJson(Map<String, dynamic> json) {
    return Logged();
  }
}

class Public extends Access {
  Public() : super();

  @override
  get accessName => "public";

  @override
  Map<String, dynamic> toJson() {
    return {
      "accessName": accessName,
    };
  }

  static Public fromJson(Map<String, dynamic> json) {
    return Public();
  }
}

class Group extends Access {
  final String name;

  Group({required this.name});

  @override
  get accessName => "group";

  @override
  Map<String, dynamic> toJson() {
    return {
      "accessName": accessName,
      "name": name,
    };
  }

  static Group fromJson(Map<String, dynamic> json) {
    return Group(name: json['name']);
  }
}

class Login extends Access {
  final int userId;

  Login({required this.userId});

  @override
  get accessName => "login";

  @override
  Map<String, dynamic> toJson() {
    return {
      "accessName": accessName,
      "userId": userId,
    };
  }

  static Login fromJson(Map<String, dynamic> json) {
    return Login(userId: json['userId']);
  }
}
