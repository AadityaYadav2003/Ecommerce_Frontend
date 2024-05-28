import 'package:ecommerce/models/shop.dart';
import 'package:ecommerce/pages/cart_page.dart';
import 'package:ecommerce/pages/category_page.dart';
import 'package:ecommerce/pages/forgotpassword_page.dart';
import 'package:ecommerce/pages/profile_page.dart';
import 'package:ecommerce/pages/register_page.dart';
import 'package:ecommerce/pages/shop_page.dart';
import 'package:ecommerce/pages/intro_page.dart';
import 'package:ecommerce/pages/login_page.dart';
import 'package:ecommerce/pages/sub_category.dart';
import 'package:ecommerce/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Shop(),
        ),
        ChangeNotifierProvider(create: (_) => SelectedCategory()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        )
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

/// To run app run command in terminal - flutter run -d chrome --web-renderer html

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: isLoggedIn ? '/shop_page' : '/intro_page',
      routes: {
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(),
        '/forgotpassword_page': (context) => const ForgotpasswordPage(),
        '/profile_page': (context) => const ProfilePage(),
        '/intro_page': (context) => const IntroPage(),
        '/shop_page': (context) => const ShopPage(),
        '/cart_page': (context) => const CartPage(),
        '/category_page': (context) => const CategoryPage(),
        '/sub_category': (context) => const SubCategory(),
      },
    );
  }
}
