import 'package:ecommerce/components/my_drawer.dart';
import 'package:ecommerce/components/my_product_tile.dart';
import 'package:ecommerce/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  Future<List<Product>> fetchData() async {
    final response = await http.get(
        Uri.parse("https://ecommercebackend-x2kr.onrender.com/user/result"));
    if (response.statusCode == 200) {
      final List<dynamic> rawData = json.decode(response.body)['result'][0];
      return rawData.map((product) => Product.fromJson(product)).toList();
    } else {
      throw Exception("Failed to Load Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Shop"),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              icon: const Icon(Icons.light_mode)),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/cart_page'),
              icon: const Icon(Icons.shopping_cart_outlined))
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<List<Product>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            List<Product> products = snapshot.data!;
            return ListView(
              children: [
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "W E L C O M E    T O    M I N I M A L",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                SizedBox(
                  height: 550,
                  child: ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return MyProductTile(product: product);
                      }),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text(
                    "P R O D U C T S",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return MyProductTile(product: product);
                      }),
                ),
                Center(
                  child: Text(
                    "P R E M I U M   P R O D U C T S",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return MyProductTile(product: product);
                      }),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
