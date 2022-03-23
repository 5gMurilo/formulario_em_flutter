import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:testbigclass/model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forms class',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Forms class'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formkey = GlobalKey<FormState>();
  var model = User();
  var passwordCache = '';
  var confirmationPasswordCache = '';
  String nome = '';
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                StyledTextField(
                  label: 'Nome',
                  hintText: 'Insira seu nome',
                  prefix: Icons.person_outline,
                  obscureText: false,
                  validate: (text) => text == null || text.isEmpty
                      ? 'This field can\'t be null'
                      : null,
                  saved: (text) {
                    model = model.copyWith(nome: text);
                  },
                ),
                StyledTextField(
                  label: 'E-mail',
                  hintText: 'Insira seu e-mail',
                  prefix: Icons.email_outlined,
                  obscureText: false,
                  validate: (text) {
                    if (text == null || text.isEmpty) {
                      return 'This field can\'t be null';
                    }
                    if (!validator.isEmail(text)) {
                      return 'value must be e-mail type';
                    }
                  },
                  saved: (text) {
                    model = model.copyWith(email: text);
                  },
                ),
                StyledTextField(
                  label: 'Senha',
                  hintText: 'Insira sua senha',
                  prefix: Icons.vpn_key,
                  obscureText: obscure,
                  validate: (text) {
                    if (text == null || text.isEmpty) {
                      return 'This field can\'t be null';
                    }
                  },
                  saved: (text) {
                    model = model.copyWith(password: text);
                  },
                  onChanged: (text) => passwordCache = text,
                  sufix: IconButton(
                    icon: Icon(obscure
                        ? Icons.visibility
                        : Icons.visibility_off_rounded),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
                ),
                StyledTextField(
                  label: 'Confirme a senha',
                  hintText: 'Confirme sua senha',
                  prefix: Icons.vpn_key,
                  obscureText: obscure,
                  validate: (text) {
                    if (text == null || text.isEmpty) {
                      return 'This field can\'t be null';
                    }
                    if (text.length < 5) {
                      return 'Your password needs at least 5 characters! Add more ${passwordCache.length - 5} characters.';
                    }
                    if (passwordCache != confirmationPasswordCache) {
                      return 'The passwords aren\'t equals, please review the fields';
                    }
                  },
                  saved: (text) {
                    model = model.copyWith(password: text);
                  },
                  onChanged: (text) => confirmationPasswordCache = text,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                          print(
                              '''
                                    FORM

                              Nome: ${model.nome}
                              Email: ${model.email}
                              Password: ${model.password}''');
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        formkey.currentState?.reset();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink.shade600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class StyledTextField extends StatelessWidget {
  const StyledTextField({
    required this.label,
    required this.hintText,
    required this.prefix,
    required this.validate,
    required this.saved,
    required this.obscureText,
    this.onChanged,
    this.sufix,
    Key? key,
  }) : super(key: key);

  final String label;
  final String hintText;
  final IconData? prefix;
  final String? Function(String? text)? validate;
  final void Function(String? text)? saved;
  final void Function(String)? onChanged;
  final bool obscureText;
  final Widget? sufix;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validate,
        onSaved: saved,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          prefixIcon: Icon(prefix),
          suffixIcon: sufix,
        ),
      ),
    );
  }
}
