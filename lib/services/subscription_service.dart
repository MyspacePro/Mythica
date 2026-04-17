enum SubscriptionType { free, premium, writer }

class SubscriptionService {
  SubscriptionType getUserPlan(String userId) {
    
    return SubscriptionType.free;
  }

  bool canDownloadBook(SubscriptionType plan) {
    return plan != SubscriptionType.free;
  }
}
