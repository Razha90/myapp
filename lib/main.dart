import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import for initializeDateFormatting
import 'auth_service.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import 'student_dashboard_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'schedule_service.dart';

Future<void> main() async { // Change main to async
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('id_ID', null); // Initialize locale data
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ScheduleService()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isLoggedIn;

    final isLoggingIn = state.matchedLocation == '/login';
    final isRegistering = state.matchedLocation == '/register';

    // If not logged in, and not on the login or register page, redirect to login.
    if (!isLoggedIn && !isLoggingIn && !isRegistering) {
      return '/login';
    }
    // If logged in and trying to go to login/register, redirect to main screen.
    if (isLoggedIn && (isLoggingIn || isRegistering)) {
      return '/main';
    }
    // No redirect needed
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/main',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
      routes: [
        GoRoute(
          path: 'student_dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const StudentDashboardScreen();
          },
        ),
        GoRoute(
          path: 'teacher_dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const TeacherDashboardScreen();
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
    );
  }
}


