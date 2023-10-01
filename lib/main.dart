import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_database_example/Providers/ad_providers.dart';
import 'package:sqflite_database_example/page/notes_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await SystemChrome.setPreferredOrientations([]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'NotesApp';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<AdProvider>(
        create: (context) {
          return AdProvider();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.blueGrey.shade900,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          home: NotesPage(),
        ),
      );
}
