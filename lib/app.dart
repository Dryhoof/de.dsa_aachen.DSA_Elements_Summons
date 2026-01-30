import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'features/home/home_screen.dart';
import 'features/character_edit/character_edit_screen.dart';
import 'features/summoning/summoning_screen.dart';
import 'features/result/result_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/character/new',
      builder: (context, state) => const CharacterEditScreen(),
    ),
    GoRoute(
      path: '/character/:id',
      builder: (context, state) => CharacterEditScreen(
        characterId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/summon/:characterId',
      builder: (context, state) => SummoningScreen(
        characterId: int.parse(state.pathParameters['characterId']!),
      ),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);

class DsaApp extends StatelessWidget {
  const DsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DSA Elements Summons',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      routerConfig: _router,
    );
  }
}
