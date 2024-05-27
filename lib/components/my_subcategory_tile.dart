import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/models/shop.dart';

class MySubProductTile extends StatefulWidget {
  final Product product;

  const MySubProductTile({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<MySubProductTile> createState() => _MySubProductTileState();
}

class _MySubProductTileState extends State<MySubProductTile> {
  void addToCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Add this item to your cart?"),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // yes button
          MaterialButton(
            onPressed: () {
              // pop dialog box
              Navigator.pop(context);
              // add to cart
              context.read<Shop>().addToCart(widget.product);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.2; // Adjust this value as needed
    double imageHeight = tileHeight * 0.6; // Adjust this value as needed

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: widget.product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        width: 100, // Adjust the width as needed
        height: tileHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: imageHeight, // Set a fixed height for the image
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12), // Rounded corners for the image
                image: DecorationImage(
                  image: NetworkImage("http://ecommerce.raviva.in/categoryimage/${widget.product.image!}"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 4), // Space between image and text
            // Product name
            Text(
              widget.product.productName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12, // Adjust the font size as needed
              ),
              maxLines: 1, // Limit the text to a single line to avoid overflow
              overflow: TextOverflow.ellipsis, // Use ellipsis for overflow text
            ),
            const SizedBox(height: 4), // Space between name and description
            // Product description
            Text(
              widget.product.description!,
              style: const TextStyle(
                fontSize: 10, // Adjust the font size as needed
              ),
              maxLines: 1, // Limit the text to a single line to avoid overflow
              overflow: TextOverflow.ellipsis, // Use ellipsis for overflow text
            ),
            const SizedBox(height: 4), // Space between name and description
            // Product description
            Text(
              '₹${widget.product.price!}',
              style: const TextStyle(
                fontSize: 10, // Adjust the font size as needed
              ),
              maxLines: 1, // Limit the text to a single line to avoid overflow
              overflow: TextOverflow.ellipsis, // Use ellipsis for overflow text
            ),
          ],
        ),
      ),
    );
  }
}
