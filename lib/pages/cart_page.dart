import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:ecommerce/components/my_button.dart';
import 'package:ecommerce/components/my_drawer.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String environmentValue = "PRODUCTION";
  String appId = "";
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;

  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";

  String body = "";
  String callback = "https://example.com/callback"; // Provide a valid callback URL
  String checksum = "";
  String packageName = "com.example.app"; // Your package name
  String apiEndPoint = "/pg/v1/pay";

  Object? result;

  @override
 void initState() {
  super.initState();
  initPayment();
  body = getChecksum().toString();
}


  void initPayment() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
    });
  }

  void handleError(error) {
    setState(() {
      result = error;
    });
    print("Error: $error");
  }

  
void startTransaction() {
  print("Starting transaction with body: $body, callback: $callback, checksum: $checksum, packageName: $packageName");
  PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
      .then((response) {
    print("Transaction response: $response");
    setState(() {
      if (response != null) {
        String status = response['status'].toString();
        String error = response['error'].toString();
        if (status == 'SUCCESS') {
          result = "Flow Completed - Status: Success!";
        } else {
          result = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        result = "Flow Incomplete";
      }
    });
  }).catchError((error) {
    print("Error during transaction: $error");
    handleError(error);
  });
}


  String getChecksum() {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "t_52554",
      "merchantUserId": "MUID123",
      "amount": 10000,
      "callbackUrl": callback,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64body = base64.encode(utf8.encode(json.encode(reqData)));

    checksum = '${sha256.convert(utf8.encode(base64body + apiEndPoint + saltKey))}###$saltIndex';

    return base64body;
  }

  // remove item from cart method
  void removeItemFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Remove this item from your cart?"),
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

              // remove from cart
              context.read<Shop>().removeFromCart(product);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get access to the cart
    final cart = context.watch<Shop>().cart;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Cart Page'),
        ),
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            // cart list
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text("Your cart is empty..."))
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        // Get individual item in cart
                        final item = cart[index];

                        // Return as a cart tile UI
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "http://ecommerce.raviva.in/productimage/${item.image!}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item.productName!),
                          subtitle: Text(item.price!),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => removeItemFromCart(context, item),
                          ),
                        );
                      },
                    ),
            ),

            // pay button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                  text: "PAY NOW",
                  onTap: () {
                    startTransaction();
                  },
                  child: const Text("PAY NOW")),
            ),
            // Display result
            if (result != null) Text(result.toString())
          ],
        ));
  }
}
