import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_box/pages/auth_pages/welcome_page.dart';
import 'package:memory_box/pages/loading_page.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/routes/app_router.dart';
import 'package:memory_box/view_model/navigation.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Navigation()),
        StreamProvider(
          create: (_) => AudioRepositories.instance.audio,
          initialData: null,
        )
      ],
      child: const MemoryBox(),
    ),
  );
}

class MemoryBox extends StatelessWidget {
  const MemoryBox({Key? key}) : super(key: key);

  Widget _checkAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      return const LoadingPage();
    }
    return const WelcomPage();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      home: _checkAuth(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
