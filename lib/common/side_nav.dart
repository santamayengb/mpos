import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mpos/core/config/cubit/tab_cubit.dart';
import 'package:mpos/core/config/web_socket/web_socket_cubit.dart';
import 'package:mpos/routers/router.name.dart';

class SideNavPage extends StatelessWidget {
  const SideNavPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var activeTab = context.watch<TabCubit>().state.tabName;
    return Scaffold(
      body: Row(
        children: [
          if (w > 1100)
            Container(
              height: double.infinity,
              width: 250,
              color: const Color(0xff13141f),
              child: Column(
                children: [
                  sideNavLogo(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: Routes.routeNames.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color:
                                activeTab == Routes.routeNames[index]
                                    ? const Color(0xff262626)
                                    : null,
                            border: Border(
                              left:
                                  activeTab == Routes.routeNames[index]
                                      ? const BorderSide(
                                        width: 5,
                                        color: Colors.red,
                                      )
                                      : const BorderSide(),
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              context
                                  .read<TabCubit>()
                                  .activeTab(Routes.routeNames[index])
                                  .then((value) {
                                    context.goNamed(Routes.routeNames[index]);
                                  });
                            },
                            // leading: SvgPicture.asset(
                            //   KASSETS.grayTabs[index],
                            //   color: activeTab == Routes.routeNames[index]
                            //       ? Colors.white
                            //       : Colors.grey,
                            // ),
                            title: Text(
                              Routes.routeNames[index],
                              style: TextStyle(
                                color:
                                    activeTab == Routes.routeNames[index]
                                        ? Colors.white
                                        : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   width: 100,
                  //   child: Text(
                  //     activeTab,
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  WEBBtn(),
                ],
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget sideNavLogo() {
    return SizedBox(
      height: 200,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            // child: Image.asset(KASSETS.brand, fit: BoxFit.contain, scale: 1),
            child: CircleAvatar(),
          ),

          const Text(
            "The Simple POS",
            style: TextStyle(color: Color(0xffE6E2C3), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class WEBBtn extends StatelessWidget {
  const WEBBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WebSocketCubit>().state;
    return Column(
      children: [
        InkWell(
          onTap: () => context.read<WebSocketCubit>().startServer(),
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor:
                    state.status == Status.running ? Colors.green : Colors.red,
                radius: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  state.status == Status.running
                      ? "Running"
                      : "Click to Start server",
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        if (state.status == Status.running)
          Text(
            state.serverAddress.toString(),
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.copyWith(color: Colors.white),
          ),
        SizedBox(height: 10),
      ],
    );
  }
}
