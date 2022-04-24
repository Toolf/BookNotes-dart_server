abstract class Access {}

class Logged implements Access {
  const Logged();
}

class Public implements Access {
  const Public();
}

class Group implements Access {
  final String name;

  const Group({required this.name});
}

class Login implements Access {
  final String name;

  const Login({required this.name});
}
