class PaymentService {
  Future<bool> makePayment({
    required double amount,
    required String userId,
  }) async {

    await Future.delayed(const Duration(seconds: 1));
    return true; // payment success
  }
}
