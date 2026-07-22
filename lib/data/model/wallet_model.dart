class WalletModel {
  final bool success;
  final String message;
  final WalletData? wallet;
  final List<WalletTransactionModel> transactions;

  WalletModel({
    required this.success,
    required this.message,
    this.wallet,
    required this.transactions,
  });

  factory WalletModel.fromWalletJson(Map<String, dynamic> json) {
    final data = json["data"];
    final walletJson = data is Map ? data["wallet"] : null;
    final recentTransactions =
        walletJson is Map ? walletJson["recent_transactions"] : [];

    return WalletModel(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      wallet: walletJson is Map
          ? WalletData.fromJson(Map<String, dynamic>.from(walletJson))
          : null,
      transactions: recentTransactions is List
          ? recentTransactions
              .map(
                (item) => WalletTransactionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }

  factory WalletModel.fromTransactionsJson(Map<String, dynamic> json) {
    final data = json["data"];
    final list = data is Map ? data["data"] : [];

    return WalletModel(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      wallet: null,
      transactions: list is List
          ? list
              .map(
                (item) => WalletTransactionModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }
}

class WalletData {
  final int walletId;
  final double currentBalance;
  final int recentTransactionsCount;

  WalletData({
    required this.walletId,
    required this.currentBalance,
    required this.recentTransactionsCount,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      walletId: _toInt(json["wallet_id"]),
      currentBalance: _toDouble(json["current_balance"]),
      recentTransactionsCount: _toInt(json["recent_transactions_count"]),
    );
  }

  String get balanceText {
    return currentBalance.toStringAsFixed(2);
  }

  String get walletIdText {
    return "#$walletId";
  }
}

class WalletTransactionModel {
  final int transactionId;
  final String title;
  final String formattedAmount;
  final String statusLabel;
  final String actorName;
  final String reason;
  final int receiptId;
  final String detailsEndpoint;
  final String createdAt;

  WalletTransactionModel({
    required this.transactionId,
    required this.title,
    required this.formattedAmount,
    required this.statusLabel,
    required this.actorName,
    required this.reason,
    required this.receiptId,
    required this.detailsEndpoint,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      transactionId: _toInt(json["transaction_id"]),
      title: json["title"]?.toString() ?? "",
      formattedAmount: json["formatted_amount"]?.toString() ?? "",
      statusLabel: json["status_label"]?.toString() ?? "",
      actorName: json["actor_name"]?.toString() ?? "",
      reason: json["reason"]?.toString() ?? "",
      receiptId: _toInt(json["receipt_id"]),
      detailsEndpoint: json["details_endpoint"]?.toString() ?? "",
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }

  bool get isNegative {
    return formattedAmount.trim().startsWith("-");
  }

  String get receiptText {
    return "Receipt: #$receiptId";
  }

  String get dateText {
    if (createdAt.isEmpty) return "";

    try {
      final date = DateTime.parse(createdAt);

      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");
      final hour = date.hour.toString().padLeft(2, "0");
      final minute = date.minute.toString().padLeft(2, "0");

      return "$year-$month-$day  $hour:$minute";
    } catch (_) {
      return createdAt;
    }
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}