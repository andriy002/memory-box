import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_box/controlers/navigation.dart';
import 'package:memory_box/services/auth_services.dart';
import 'package:memory_box/services/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthServices()),
      ChangeNotifierProvider(create: (_) => NavigationController()),
    ],
    child: const MemoryBox(),
  ));
}

class MemoryBox extends StatelessWidget {
  const MemoryBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color(0xff8C84E2)),
      routes: Routes.routes,
      initialRoute: context.watch<AuthServices>().chechAuth(),
      debugShowCheckedModeBanner: false,
    );
  }
}
