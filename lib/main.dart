import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission/data/api/api_service.dart';
import 'package:submission/provider/auth_provider.dart';
import 'package:submission/provider/pick_image_provideer.dart';
import 'package:submission/provider/story_provider.dart';
import 'package:submission/provider/upload_provider.dart';
import 'package:submission/routes/route_information_parser.dart';

import 'data/db/auth_repository.dart';
import 'routes/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;
  late MyRouteInformationParser myRouteInformationParser;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();

    authProvider = AuthProvider(ApiService(), authRepository);

    myRouterDelegate = MyRouterDelegate(authRepository);

    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(ApiService(), AuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => PickImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(ApiService()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: myRouterDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
