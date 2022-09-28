import 'package:app_note_sqflite/ui/page/create_note/create_note_view_model.dart';
import 'package:app_note_sqflite/ui/page/detail/detail_view_model.dart';
import 'package:app_note_sqflite/ui/page/home/home_page.dart';
import 'package:app_note_sqflite/ui/page/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider<DetailViewModel>(
          create: (_) => DetailViewModel(),
        ),
        ChangeNotifierProvider<CreateNoteViewModel>(
          create: (_) => CreateNoteViewModel(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
