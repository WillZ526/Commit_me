//Packages
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

//Other files
import 'authentication/login.dart';
import 'authentication/signup.dart';
import 'firebase/firebase_options.dart';
import 'firebase/AppState.dart';
import 'tabs/shop.dart';
import 'tabs/menu.dart';
import 'tabs/friends.dart';
import 'tabs/profile.dart';

//Initializing Router and other required variables
final state = AppState();
final _rootNavKey = GlobalKey<NavigatorState>();
final _sectionNavKey = GlobalKey<NavigatorState>();

String _checkInitialLocation() {
  if (state.getCurrentFirebaseUser().toString() ==
          state.getCurrentUser().toString() &&
      state.getCurrentFirebaseUser() != null) {
    return '/menu';
  } else if (state.getCurrentFirebaseUser().toString() ==
          state.getCurrentUser().toString() &&
      state.getCurrentFirebaseUser() == null) {
    return '/login';
  } else {
    print('Something has gone wrong');
    return '/login';
  }
}

final _router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: _checkInitialLocation(),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, routerState) => LoginPage(state: state),
        routes: [
          GoRoute(
            path: 'signup',
            builder: (context, routerState) => SignUpPage(state: state),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
          builder: (context, routerState, navigationShell) {
            return ScaffoldWithNavbar(navigationShell);
          },
          branches: [
            StatefulShellBranch(navigatorKey: _sectionNavKey, routes: [
              GoRoute(
                path: '/shop',
                builder: (context, routerState) => ShopPage(),
              ),
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/menu',
                builder: (context, routerState) => MenuPage(state: state),
              ),
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/friends',
                builder: (context, routerState) => FriendsPage(),
              ),
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (context, routerState) => ProfilePage(state: state),
              ),
            ]),
          ]),
    ]);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      print(e);
    }
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    state.resetUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
class ScaffoldWithNavbar extends StatelessWidget {
  const ScaffoldWithNavbar(this.navigationShell, {super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            state.logOut();
            context.go('/login');
          }, //logout button
          child: const Text('Logout'),
        ),
      ]),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        fixedColor: Colors.blueAccent,
        unselectedItemColor: Colors.blue,
        currentIndex: navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Profile'),
        ],
        onTap: _onTap,
      ),
    );
  }

  void _onTap(index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
