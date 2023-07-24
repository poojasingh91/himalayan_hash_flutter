import 'package:create_hash_ui/services/shared_prefernce_help.dart';
import 'package:create_hash_ui/view/hash/list_of_hash.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/user_model.dart';

import '../../repository/user_repository.dart';
import '../home.dart';

// void getHttp() async {
//   try {
//     var response =
//         await Dio().get('https://jsonplaceholder.typicode.com/todos/1');
//     print(response);
//   } catch (e) {
//     print(e);
//   }
// }

class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final _formKey = GlobalKey<FormState>();
  UserRepository ur = UserRepository();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _prefsLocator = GetIt.I<SharedPreferenceHelper>();

  @override
  void initState() {
    super.initState();
    _usernameController.text = "superadmin";
    _passwordController.text = "password";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipPath(
                clipper: CustomClipPath(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: 428,
                  decoration: BoxDecoration(
                    color: const Color(0XFF0C3B2E),
                    borderRadius: BorderRadius.vertical(
                      bottom:
                          Radius.circular(MediaQuery.of(context).size.width),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 24),
                  child: const Text(
                    'MisApp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48.0,
                      letterSpacing: 1.5,
                      color: Color(0XFFFFBA00),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Start your',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0XFF006B60),
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Image(
                          image: AssetImage(
                            'assets/images/login1.png',
                          ),
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'Hash',
                    style: TextStyle(
                        color: Color(0XFF006B60),
                        fontWeight: FontWeight.bold,
                        fontSize: 70),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  controller: _usernameController,
                  // initialValue: "superadmin",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Username cannot be empty";
                    } else if (value.length < 3) {
                      return "Username length must be greater than 3";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                    suffixIconColor: Colors.grey.withOpacity(0.5),
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(
                      Icons.perm_identity,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: TextFormField(
                  controller: _passwordController,
                  // initialValue: "password",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    } else if (value.length < 5) {
                      return "Password length must be greater than 5";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 28),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 30, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserVerification uv = await ur.userLogin(
                            userName: _usernameController.text,
                            password: _passwordController.text);

                        if (uv.success == true) {
                          _prefsLocator.setUserToken(userToken: uv.token!);
                          // String? tokenVal = _prefsLocator.getUserToken();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                // builder: (context) => const HashList()),
                                builder: (context) => const MyHome()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Login failed: Invalid username-password')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid Data')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      primary: const Color(0XFF006B60),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0XFF006B60),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

Widget _header() {
  return const Text(
    'Start your Hash',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // int curveHeight = 200;
    // Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    // Offset endPoint = Offset(size.width, size.height - curveHeight);
    Path path = Path()
      ..relativeLineTo(0, size.height)
      ..quadraticBezierTo(size.height, 250, size.width, size.height)
      ..relativeLineTo(0, -size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
