import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dsa_elements_summons_flutter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/locale_provider.dart';
import 'features/home/home_screen.dart';
import 'features/character_edit/character_edit_screen.dart';
import 'features/summoning/summoning_screen.dart';
import 'features/result/result_screen.dart';
import 'features/elemental_templates/elemental_templates_screen.dart';
import 'features/elemental_templates/elemental_template_edit_screen.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class _SnackBarClearingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}

final _router = GoRouter(
  observers: [_SnackBarClearingObserver()],
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
      builder: (context, state) {
        final templateIdStr = state.uri.queryParameters['templateId'];
        final predefinedId = state.uri.queryParameters['predefinedId'];
        return SummoningScreen(
          characterId: int.parse(state.pathParameters['characterId']!),
          initialTemplateId: templateIdStr != null ? int.parse(templateIdStr) : null,
          initialPredefinedId: predefinedId,
        );
      },
    ),
    GoRoute(
      path: '/character/:id/elementals',
      builder: (context, state) => ElementalTemplatesScreen(
        characterId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/character/:id/elementals/new',
      builder: (context, state) => ElementalTemplateEditScreen(
        characterId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/character/:id/elementals/:templateId',
      builder: (context, state) => ElementalTemplateEditScreen(
        characterId: int.parse(state.pathParameters['id']!),
        templateId: int.parse(state.pathParameters['templateId']!),
      ),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
);

class DsaApp extends ConsumerWidget {
  const DsaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
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
      locale: locale,
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
