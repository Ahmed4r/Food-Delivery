import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/models/payment_card.dart';
import 'package:food_delivery/services/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSystemScreen extends StatefulWidget {
  static const String routeName ='payment-system';

  const PaymentSystemScreen({super.key});
  @override
  _PaymentSystemScreenState createState() => _PaymentSystemScreenState();
}

class _PaymentSystemScreenState extends State<PaymentSystemScreen> {
  int currentScreenIndex = 0;
  List<PaymentCard> savedCards = [];
  PaymentCard? selectedCard;
  bool isProcessing = false;

  final TextEditingController cardholderNameController = TextEditingController(text: 'Vishal Khadok');
  final TextEditingController cardNumberController = TextEditingController(text: '2134');
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSavedCards();
  }
  

  Future<void> loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getStringList('saved_cards') ?? [];
    setState(() {
      savedCards = cardsJson.map((cardJson) => PaymentCard.fromJson(json.decode(cardJson))).toList();
    });
  }

  Future<void> saveSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = savedCards.map((card) => json.encode(card.toJson())).toList();
    await prefs.setStringList('saved_cards', cardsJson);
  }
  //simulate test

  // Future<void> processPayment() async {
  //   setState(() {
  //     isProcessing = true;
  //   });

  //   try {
  //     // Authenticate with Paymob
  //     final authToken = await PaymobService.authenticate();
      
  //     // Create order
  //     final orderId = await PaymobService.createOrder(authToken, 1);
      
  //     // Get payment key
  //     final paymentKey = await PaymobService.getPaymentKey(
  //       authToken, 
  //       orderId, 
  //       1, 
  //       cardholderNameController.text
  //     );
      
  //     // Here you would typically open a WebView with the payment URL
  //     // For demo purposes, we'll simulate success
  //     await Future.delayed(Duration(seconds: 2));
      
  //     setState(() {
  //       isProcessing = false;
  //       currentScreenIndex = 0;
  //     });
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Payment processed successfully!')),
  //     );
      
  //   } catch (error) {
  //     setState(() {
  //       isProcessing = false;
  //     });
      
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Payment failed. Please try again.')),
  //     );
  //   }
  // }
  Future<void> processPayment() async {
  setState(() {
    isProcessing = true;
  });

  try {
    final authToken = await PaymobService.authenticate();
    final orderId = await PaymobService.createOrder(authToken, 1);
    final paymentKey = await PaymobService.getPaymentKey(
      authToken,
      orderId,
      1,
      cardholderNameController.text,
    );

     final String paymentUrl = 'https://accept.paymob.com/api/acceptance/iframes/896802?payment_token=$paymentKey';

    // Open the payment page in a WebView and wait for result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymobWebViewScreen(paymentUrl: paymentUrl),
      ),
    );

    setState(() {
      isProcessing = false;
      currentScreenIndex = 0;
    });

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processed successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  } catch (error) {
    setState(() {
      isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed. Please try again.')),
    );
  }
}

  void addNewCard() {
    final newCard = PaymentCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'mastercard',
      last4: cardNumberController.text.replaceAll(' ', '').substring(
        cardNumberController.text.replaceAll(' ', '').length - 4
      ),
      cardholderName: cardholderNameController.text,
    );
    
    setState(() {
      savedCards.add(newCard);
      selectedCard = newCard;
      currentScreenIndex = 1;
    });
    
    saveSavedCards();
  }

  String formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    switch (currentScreenIndex) {
      case 0:
        return _buildNoCardScreen();
      case 1:
        return _buildPaymentMethodScreen();
      case 2:
        return _buildAddCardScreen();
      default:
        return _buildNoCardScreen();
    }
  }

  Widget _buildNoCardScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymobTester()),
    );
  },
  child: Icon(Icons.bug_report),
)

        ],
        title: Text('Payment Method_No Mastercard', style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Payment methods grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentMethodIcon('💰', 'Cash', false),
                _buildPaymentMethodIcon('💳', 'Visa', false),
                _buildPaymentMethodIcon('💳', 'Mastercard', true),
                _buildPaymentMethodIcon('🅿️', 'PayPal', false),
              ],
            ),
            SizedBox(height: 40),
            
            // No card illustration
            Container(
              height: 150,
              width: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: 40,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            Text(
              'No master card added',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'You can add a mastercard and\nsave it for later',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            
            SizedBox(height: 40),
            
            // Add new button
            TextButton.icon(
              onPressed: () => setState(() => currentScreenIndex = 2),
              icon: Icon(Icons.add, color: Colors.orange),
              label: Text('ADD NEW', style: TextStyle(color: Colors.orange)),
            ),
            
            Spacer(),
            
            // Total and pay button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('\$1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: savedCards.isNotEmpty ? processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'PAY & CONFIRM',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => currentScreenIndex = 0),
        ),
        title: Text('Payment Method', style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Payment methods grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentMethodIcon('💰', 'Cash', false),
                _buildPaymentMethodIcon('💳', 'Visa', false),
                _buildPaymentMethodIcon('💳', 'Mastercard', true),
                _buildPaymentMethodIcon('🅿️', 'PayPal', false),
              ],
            ),
            SizedBox(height: 40),
            
            // Selected card dropdown
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        'MC',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('••••••••••••436', style: TextStyle(fontSize: 16)),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Add new button
            TextButton.icon(
              onPressed: () => setState(() => currentScreenIndex = 2),
              icon: Icon(Icons.add, color: Colors.orange),
              label: Text('ADD NEW', style: TextStyle(color: Colors.orange)),
            ),
            
            Spacer(),
            
            // Total and pay button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('\$96', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'PAY & CONFIRM',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCardScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => setState(() => currentScreenIndex = savedCards.isEmpty ? 0 : 1),
        ),
        title: Text('Add Card', style: TextStyle(color: Colors.black, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => setState(() => currentScreenIndex = savedCards.isEmpty ? 0 : 1),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CARD HOLDER NAME', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            SizedBox(height: 8),
            TextField(
              controller: cardholderNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Text('CARD NUMBER', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            SizedBox(height: 8),
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              onChanged: (value) {
                final formatted = formatCardNumber(value);
                if (formatted != cardNumberController.text) {
                  cardNumberController.value = TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: '2134 ____ ____ ____',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EXPIRE DATE', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      SizedBox(height: 8),
                      TextField(
                        controller: expiryDateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        onChanged: (value) {
                          if (value.length == 2 && !value.contains('/')) {
                            expiryDateController.text = '$value/';
                            expiryDateController.selection = TextSelection.fromPosition(
                              TextPosition(offset: expiryDateController.text.length),
                            );
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'mm/yyyy',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVC', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      SizedBox(height: 8),
                      TextField(
                        controller: cvcController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '•••',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (cardholderNameController.text.isNotEmpty &&
                      cardNumberController.text.length >= 4 &&
                      expiryDateController.text.isNotEmpty &&
                      cvcController.text.isNotEmpty) {
                    addNewCard();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'ADD & MAKE PAYMENT',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon(String icon, String label, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(icon, style: TextStyle(fontSize: 24)),
          ),
        ),
        if (isSelected)
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: Colors.white, size: 12),
          ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class PaymobTester extends StatefulWidget {
  const PaymobTester({super.key});

  @override
  _PaymobTesterState createState() => _PaymobTesterState();
}

class _PaymobTesterState extends State<PaymobTester> {
  String authToken = '';
  int orderId = 0;
  String paymentToken = '';
  List<String> logs = [];

  void addLog(String message) {
    setState(() {
      logs.add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
  }

  Future<void> testAuth() async {
    addLog('🔐 Testing Authentication...');
    try {
      authToken = await PaymobService.authenticate();
      addLog('✅ Auth Success: ${authToken.substring(0, 20)}...');
    } catch (e) {
      addLog('❌ Auth Failed: $e');
    }
  }

  Future<void> testOrder() async {
    if (authToken.isEmpty) {
      addLog('⚠️ Need to authenticate first');
      return;
    }
    
    addLog('📦 Testing Order Creation...');
    try {
      orderId = await PaymobService.createOrder(authToken, 96.0);
      addLog('✅ Order Success: $orderId');
    } catch (e) {
      addLog('❌ Order Failed: $e');
    }
  }

  Future<void> testPaymentKey() async {
    if (orderId == 0) {
      addLog('⚠️ Need to create order first');
      return;
    }
    
    addLog('🔑 Testing Payment Key...');
    try {
      paymentToken = await PaymobService.getPaymentKey(authToken, orderId, 96.0, 'John Doe');
      addLog('✅ Payment Key Success: ${paymentToken.substring(0, 20)}...');
    } catch (e) {
      addLog('❌ Payment Key Failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paymob Tester')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: testAuth, child: Text('1. Auth'))),
              Expanded(child: ElevatedButton(onPressed: testOrder, child: Text('2. Order'))),
              Expanded(child: ElevatedButton(onPressed: testPaymentKey, child: Text('3. Payment'))),
            ],
          ),
          ElevatedButton(
            onPressed: () => setState(() => logs.clear()),
            child: Text('Clear Logs'),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Text(
                    logs[index],
                    style: TextStyle(
                      color: logs[index].contains('❌') ? Colors.red :
                             logs[index].contains('✅') ? Colors.green :
                             Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PaymobWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymobWebViewScreen({required this.paymentUrl, super.key});

  @override
  State<PaymobWebViewScreen> createState() => _PaymobWebViewScreenState();
}

class _PaymobWebViewScreenState extends State<PaymobWebViewScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            print('🌐 Page started: $url');
          },
          onPageFinished: (String url) {
            print('✅ Page finished: $url');
            _checkPaymentStatus(url);
          },
          onHttpError: (HttpResponseError error) {
            print('❌ HTTP Error: ${error.response?.statusCode}');
          },
          onWebResourceError: (WebResourceError error) {
            print('❌ Web Resource Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            print('🔄 Navigation to: ${request.url}');
            
            // Check for success/failure in the URL
            if (_isPaymentCompleted(request.url)) {
              _handlePaymentResult(request.url);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isPaymentCompleted(String url) {
    // Check for common Paymob success/failure patterns
    return url.contains('success=true') || 
           url.contains('success=false') ||
           url.contains('txn_response_code') ||
           url.contains('payment_status') ||
           url.contains('callback') ||
           url.contains('return_url') ||
           // Check if redirected to a completion page
           (!url.contains('accept.paymob.com') && !url.contains('iframe'));
  }

  void _checkPaymentStatus(String url) {
    // Additional check when page finishes loading
    if (_isPaymentCompleted(url)) {
      _handlePaymentResult(url);
    }
  }

  void _handlePaymentResult(String url) {
    print('🔍 Checking payment result from URL: $url');
    
    bool isSuccess = false;
    
    // Parse URL parameters to determine success
    final uri = Uri.parse(url);
    final queryParams = uri.queryParameters;
    
    // Check various success indicators
    if (queryParams['success'] == 'true' ||
        queryParams['payment_status'] == 'success' ||
        queryParams['txn_response_code'] == 'APPROVED' ||
        url.contains('success')) {
      isSuccess = true;
    } else if (queryParams['success'] == 'false' ||
               queryParams['payment_status'] == 'failed' ||
               url.contains('failed') ||
               url.contains('error')) {
      isSuccess = false;
    } else {
      // If unclear, show dialog to let user confirm
      _showPaymentConfirmationDialog();
      return;
    }
    
    _returnResult(isSuccess);
  }

  void _showPaymentConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text('Did your payment complete successfully?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _returnResult(false);
              },
              child: Text('No, Failed'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _returnResult(true);
              },
              child: Text('Yes, Success'),
            ),
          ],
        );
      },
    );
  }

  void _returnResult(bool isSuccess) {
    print('💰 Payment result: ${isSuccess ? 'SUCCESS' : 'FAILED'}');
    Navigator.of(context).pop(isSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Payment'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => _returnResult(false), // Treat close as failed payment
        ),
        actions: [
          if (isLoading)
            Container(
              margin: EdgeInsets.all(16),
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text('Loading payment page...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}