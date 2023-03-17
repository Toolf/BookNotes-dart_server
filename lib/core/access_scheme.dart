import 'package:book_notes/core/access.dart';
import 'package:book_notes/core/schema/schema.dart';

import 'schema/basic_shema.dart';
import 'schema/multi_type_schema.dart';

final loggedSchema = Schema<Logged>(
  "Logged",
  {},
  (obj) => Logged.fromJson(obj),
);

final publicSchema = Schema<Public>(
  "Public",
  {},
  (obj) => Public.fromJson(obj),
);

final groupSchema = Schema<Group>(
  "Group",
  {
    "name": BasicSchema(type: "string"),
  },
  (obj) => Group.fromJson(obj),
);

final loginSchema = Schema<Login>(
  "Login",
  {
    "name": BasicSchema(type: "string"),
  },
  (obj) => Login.fromJson(obj),
);

final accessSchema = MultiTypeSchema<Access>(
  "Access",
  {
    "logged": loggedSchema,
    "public": publicSchema,
    "group": groupSchema,
    "login": loginSchema,
  },
);
