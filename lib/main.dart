import 'package:clean_arch_reso/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arch_reso/injection_container.dart' as di;
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
