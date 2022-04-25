import 'dart:convert';
import 'dart:io';

dynamic fixture(String name) =>
    jsonDecode(File('test/fixture/$name').readAsStringSync());
