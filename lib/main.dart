// import 'dart:js';

import 'package:create_hash_ui/providers/hash_provider.dart';
import 'package:create_hash_ui/providers/hasher_provider.dart';
import 'package:create_hash_ui/view/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:create_hash_ui/providers/user_provider.dart';
import 'package:create_hash_ui/services/dio_client.dart';
import 'package:create_hash_ui/services/shared_prefernce_help.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/hasher_model.dart';

GetIt getIt = GetIt.instance;

Future<void> setup() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  getIt.registerSingleton<SharedPreferenceHelper>(
      SharedPreferenceHelper(prefs: pref));

  getIt.registerSingleton<DioClient>(DioClient());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HasherProvider()),
        ChangeNotifierProvider(create: (_) => HashProvider()),
        FutureProvider(
            create: (_) => HashProvider().loadHashes(), initialData: []),
        FutureProvider(
            create: (_) => HasherProvider().loadHashers(), initialData: []),

        // FutureProvider<List<Hasher>>(
        //   create: (context) => HasherProvider().loadHashers,
        //   initialData: [],
        // ),
      ],
      child: const HashApp(),
    ),
  );
}

class HashApp extends StatelessWidget {
  const HashApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mishap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: LoginUi(),
    );
  }
}
