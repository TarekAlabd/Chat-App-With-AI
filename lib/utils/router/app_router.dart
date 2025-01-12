import 'package:chat_app_ai/utils/router/app_routes.dart';
import 'package:chat_app_ai/views/pages/chat_page.dart';
import 'package:flutter/cupertino.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chat:
      default:
        return CupertinoPageRoute(
          builder: (_) => const ChatPage(),
          settings: settings,
        );
    }
  }
}
