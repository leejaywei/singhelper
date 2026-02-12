import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/import/import_page.dart';
import '../../presentation/pages/practice/practice_page.dart';
import '../../presentation/pages/score/score_page.dart';
import '../../presentation/pages/settings/settings_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/import',
        name: 'import',
        builder: (context, state) => const ImportPage(),
      ),
      GoRoute(
        path: '/practice/:songId',
        name: 'practice',
        builder: (context, state) {
          final songId = state.pathParameters['songId']!;
          return PracticePage(songId: songId);
        },
      ),
      GoRoute(
        path: '/score/:scoreId',
        name: 'score',
        builder: (context, state) {
          final scoreId = state.pathParameters['scoreId']!;
          return ScorePage(scoreId: scoreId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('页面未找到: ${state.uri}'),
      ),
    ),
  );
});
