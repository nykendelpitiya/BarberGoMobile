import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // PayPal credentials for toymingle11@gmail.com
  static const String _clientId = 'AdKYzf0s6konk1GLp2t7AeDS1hka34DabVR84tEVyszmJf_7HAI4a4KmycX5HyDeqgpVe9hAz42Izl2-';
  static const String _secretKey = 'EN41rsZ4dImqpyCrYQ4Aoxqv_-dn_pTm5H9v232MTR0lmjh7S-DtfPoV0AWG98VvNKw4ltk9wv4e4i34';
  static const bool _sandbox = true;

  static String get _baseUrl => _sandbox
      ? 'https://api-m.sandbox.paypal.com'
      : 'https://api-m.paypal.com';

  static Future<String> createPaypalPayment(
    BuildContext context,
    double amount,
    String currency,
  ) async {
    try {
      // Get access token
      final tokenResponse = await http.post(
        Uri.parse('$_baseUrl/v1/oauth2/token'),
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'en_US',
          'Authorization': 'Basic ${base64.encode(utf8.encode('$_clientId:$_secretKey'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'grant_type=client_credentials',
      );

      if (tokenResponse.statusCode != 200) {
        debugPrint('Token Error: ${tokenResponse.body}');
        return 'error';
      }

      final tokenData = json.decode(tokenResponse.body);
      final accessToken = tokenData['access_token'];

      // Create order
      final orderResponse = await http.post(
        Uri.parse('$_baseUrl/v2/checkout/orders'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'PayPal-Request-Id': DateTime.now().millisecondsSinceEpoch.toString(),
        },
        body: json.encode({
          'intent': 'CAPTURE',
          'purchase_units': [
            {
              'amount': {
                'currency_code': currency,
                'value': amount.toStringAsFixed(2),
              },
              'description': 'ToyMingle Purchase'
            }
          ],
          'application_context': {
            'brand_name': 'ToyMingle',
            'landing_page': 'LOGIN',
            'user_action': 'PAY_NOW',
            'return_url': 'https://toymingle.com/success',
            'cancel_url': 'https://toymingle.com/cancel',
            'shipping_preference': 'NO_SHIPPING',
            'billing_preference': 'NO_BILLING',
            'payment_method': {
              'payer_selected': 'PAYPAL',
              'payee_preferred': 'IMMEDIATE_PAYMENT_REQUIRED'
            }
          }
        }),
      );

      if (orderResponse.statusCode != 201) {
        debugPrint('Order Error: ${orderResponse.body}');
        return 'error';
      }

      final orderData = json.decode(orderResponse.body);
      String? approvalUrl;

      for (var link in orderData['links']) {
        if (link['rel'] == 'approve') {
          approvalUrl = link['href'];
          break;
        }
      }

      if (approvalUrl == null) {
        debugPrint('Order response: ${orderResponse.body}');
        return 'error';
      }

      debugPrint('Opening PayPal URL: $approvalUrl');

      // Show PayPal WebView
      if (context.mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => PayPalWebViewScreen(
              url: approvalUrl!,
              orderId: orderData['id'],
              accessToken: accessToken,
            ),
          ),
        );

        if (result == 'success') {
          // Capture the payment
          final captureResponse = await http.post(
            Uri.parse('$_baseUrl/v2/checkout/orders/${orderData['id']}/capture'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'PayPal-Request-Id': '${DateTime.now().millisecondsSinceEpoch}_capture',
            },
          );

          if (captureResponse.statusCode == 201) {
            return 'success';
          } else {
            debugPrint('Capture Error: ${captureResponse.body}');
            return 'error';
          }
        }
        return result ?? 'cancelled';
      }
      return 'cancelled';
    } catch (e) {
      debugPrint('PayPal Error: $e');
      return 'error';
    }
  }
}

class PayPalWebViewScreen extends StatefulWidget {
  final String url;
  final String orderId;
  final String accessToken;

  const PayPalWebViewScreen({
    Key? key,
    required this.url,
    required this.orderId,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<PayPalWebViewScreen> createState() => _PayPalWebViewScreenState();
}

class _PayPalWebViewScreenState extends State<PayPalWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation to: ${request.url}');
            if (request.url.contains('toymingle.com/success')) {
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            if (request.url.contains('toymingle.com/cancel')) {
              Navigator.pop(context, 'cancelled');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('Loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, 'cancelled'),
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
