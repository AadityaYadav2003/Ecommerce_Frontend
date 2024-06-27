import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePayement extends StatefulWidget {
  const PhonePayement({super.key});

  @override
  State<PhonePayement> createState() => _PhonePayementState();
}

class _PhonePayementState extends State<PhonePayement> {
  String environmentValue = "SANDBOX";
  String appId = "";
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;

  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  Object? result;

  String body = "";
  String callback = "";
  String checksum = "";
  String packageName = "";
  String apiEndPoint = "/pg/v1/pay";

  @override
  void initState() {
    super.initState();
    initPayment();
  }

  void initPayment() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) {
      setState(() {
        result = 'PhonePe SDK Initialized - $val';
        body = getCheckSum();
        // Ensure callback and packageName are set
        callback = "https://webhook.site/callback-url";
        packageName = "com.example.ecommerce"; // replace with your app's package name
      });
    }).catchError((error) {
      handleError(error);
    });
  }

  void startTranscation() {
    PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName).then((response) {
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
      handleError(error);
    });
  }

  void handleError(error) {
    setState(() {
      result = error.toString();
    });
  }

  String getCheckSum() {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "t_52554",
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "9999999999",
      "callbackUrl": "https://webhook.site/callback-url",
      "paymentInstrument": {
        "type": "UPI_INTENT",
        "targetApp": "com.phonepe.app"
      },
      "deviceContext": {
        "deviceOS": "ANDROID"
      }
    };

    String base64Body = base64.encode(utf8.encode(json.encode(reqData)));
    checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey))}###$saltIndex';

    return base64Body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              startTranscation();
            },
            child: Text("Pay Now"),
          ),
          Text('$result'),
        ],
      ),
    );
  }
}
