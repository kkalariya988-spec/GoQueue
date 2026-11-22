import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/app_router.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../core/services/navigation_service.dart';
import '../core/providers/queue_provider.dart';

class GoQueueApp extends StatelessWidget {
  const GoQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QueueProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: RouteNames.initial,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
