import 'package:ecommerce/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // drawer header : logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.shopping_bag,
                    size: 72,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // profile
              MyListTile(
                text: "PROFILE",
                icon: Icons.account_circle_rounded,
                onTap: () => Navigator.pushNamed(context, '/profile_page'),
              ),

              // shop
              MyListTile(
                text: "SHOP",
                icon: Icons.home,
                onTap: () => Navigator.pushNamed(context, '/shop_page'),
              ),

              MyListTile(
                text: "CATEGORY",
                icon: Icons.category,
                onTap: () {
                  // pop drawer frist
                  Navigator.pop(context);

                  // go to cart page
                  Navigator.pushNamed(context, '/category_page');
                },
              ),

              // cart
              MyListTile(
                text: "CART",
                icon: Icons.shopping_cart,
                onTap: () {
                  // pop drawer frist
                  Navigator.pop(context);

                  // go to cart page
                  Navigator.pushNamed(context, '/cart_page');
                },
              ),

              // contact us
              MyListTile(
                text: "CONTACT US",
                icon: Icons.call,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),

          // Exit
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: "Exit",
              icon: Icons.logout,
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/intro_page'),
            ),
          ),
        ],
      ),
    );
  }
}
