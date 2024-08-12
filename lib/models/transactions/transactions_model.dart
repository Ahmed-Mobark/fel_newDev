class MyTransactionsModel {
  List<TransactionsModel>? transactions;
  int? count;

  MyTransactionsModel({this.transactions, this.count});

  MyTransactionsModel.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <TransactionsModel>[];
      json['transactions'].forEach((v) {
        transactions!.add(TransactionsModel.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    return data;
  }
}

class TransactionsModel {
  String? id;
  int? coinPurchased;
  String? purchaseAmount;
  String? purchasedAt;
  String? paymentGateway;
  String? userId;
  String? status;

  TransactionsModel({
    this.id,
    this.coinPurchased,
    this.purchaseAmount,
    this.purchasedAt,
    this.paymentGateway,
    this.userId,
    this.status,
  });

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coinPurchased = json['coinPurchased'];
    purchaseAmount = json['purchaseAmount'];
    purchasedAt = json['purchasedAt'];
    paymentGateway = json['paymentGateway'];
    userId = json['userId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['coinPurchased'] = coinPurchased;
    data['purchaseAmount'] = purchaseAmount;
    data['purchasedAt'] = purchasedAt;
    data['paymentGateway'] = paymentGateway;
    data['userId'] = userId;
    data['status'] = status;
    return data;
  }
}
