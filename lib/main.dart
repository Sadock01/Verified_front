import 'package:doc_authentificator/cubits/switch_page/switch_page_cubit.dart';
import 'package:doc_authentificator/pages/dashboard_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF00FFEF),
  primary: const Color(0xFF00FFEF),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [],
      child: MultiBlocProvider(
          providers: [],
          child: Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {});
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData().copyWith(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFFCFCFC),
                ),
                scaffoldBackgroundColor: const Color(0xFFFCFCFC),
                colorScheme: kColorScheme,
                textTheme: const TextTheme().copyWith(
                  displayLarge: GoogleFonts.montserrat(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  labelLarge: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  displayMedium: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  labelSmall: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  displaySmall: GoogleFonts.montserrat(
                    fontSize: 11,
                    color: Colors.black,
                  ),
                  labelMedium: GoogleFonts.montserrat(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  titleSmall: GoogleFonts.montserrat(
                    fontSize: 8,
                    color: Colors.black,
                  ),
                ),
              ),
              home: BlocProvider(
                  create: (context) => SwitchPageCubit(),
                  child: DashboardHomeScreen()),
            );
          })),
    );
  }
}
