import 'package:deep_links/second_screen.dart';
import 'package:flutter/material.dart';

import 'app_links.dart';

// تعريف GlobalKey للتحكم في التنقل من أي مكان
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DeepLinkHandler().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // 2. Listen for incoming links
    DeepLinkHandler().linkStream.listen((data) {
      if (navigatorKey.currentState != null) {
        // Handle specifically based on Type
        if (data.type == DeepLinkType.promo) {
          // Logic: "Take me to first screen"
          navigatorKey.currentState!.popUntil((route) => route.isFirst);

          // Optionally show feedback
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(content: Text(data.data), backgroundColor: Colors.green),
          );
        } else {
          // Default Logic for other links (Product, Search, etc) -> Second Screen
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => SecondScreen(data: data.data),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(navigatorKey: navigatorKey, home: const HomeScreen());
  }

  @override
  void dispose() {
    DeepLinkHandler().dispose();
    super.dispose();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Deep Link Test")));
  }
}
