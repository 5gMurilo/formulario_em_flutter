import 'package:flutter/cupertino.dart';

@immutable
class User {
  final String nome;
  final String email;
  final String password;

  const User({
    this.nome = '',
    this.email = '',
    this.password = '',
  });

  User copyWith({String? nome, String? email, String? password}) {
    return User(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
