import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Razorpayy extends StatefulWidget {
  const Razorpayy({super.key});

  @override
  State<Razorpayy> createState() => _RazorpayyState();
}

class _RazorpayyState extends State<Razorpayy> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    //  event handlers for the Razorpay instance
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all resources
    super.dispose();
  }

  // Function to create an order using Razorpay Orders API
  Future<String> createOrder() async {
    var auth = 'Basic ' + base64Encode(utf8.encode('EE5AfOETTkEgqfXzfHtlMScq'));

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': auth,
    };

    var body = jsonEncode({
      'amount': 50000,
      'currency': 'INR',
      'receipt': 'order_rcptid_11',
      'payment_capture': 1,
    });

    var response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/orders'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['id']; // Return the order_id
    } else {
      throw Exception('Failed to create order');
    }
  }

  // Function to start the payment
  void startPayment(String orderId) {
    var options = {
      'key': 'rzp_live_gbzy3irMcuTeSJ',
      'amount': 500, // Amount in paise
      'name': 'Acme Corp.',
      'order_id': orderId, // Use the order_id from the Orders API
      'description': 'Fine T-Shirt',
      'timeout': 60, // in seconds
      'prefill': {'contact': '9000090000', 'email': 'gaurav.kumar@example.com'},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('Payment successful: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('External wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              String orderId = await createOrder();
              startPayment(orderId);
            } catch (e) {
              print(e.toString());
            }
          },
          child: const Text('Pay with Razorpay'),
        ),
      ),
    );
  }
}
