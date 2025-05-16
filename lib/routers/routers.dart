import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:mpos/common/side_nav.dart';
import 'package:mpos/modules/user/pages/user.page.dart';
import 'package:mpos/routers/router.name.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter routerConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/users',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SideNavPage(child: child);
      },
      routes: [
        GoRoute(
          name: Routes.users,
          path: "/users",
          builder: (context, state) {
            // context.read<TabCubit>().activeTab(Routes.client);
            return UserPage();
          },
        ),
      ],
    ),

    //update
  ],
);
