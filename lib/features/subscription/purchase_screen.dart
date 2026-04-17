import 'package:flutter/material.dart';
import 'package:mythica/services/payment_service.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentService = PaymentService();

    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade Plan")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await paymentService.makePayment(
              amount: 199,
              userId: "demo_user",
            );
          },
          child: const Text("Buy Premium"),
        ),
      ),
    );
  }
}
