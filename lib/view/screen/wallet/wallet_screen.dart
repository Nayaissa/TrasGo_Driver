import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/wallet/wallet_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/state/app_state_view.dart';
import 'package:transport_project/view/widget/wallet/wallet_action_buttons.dart';
import 'package:transport_project/view/widget/wallet/wallet_balance_card.dart';
import 'package:transport_project/view/widget/wallet/wallet_transaction_card.dart';
import 'package:transport_project/view/widget/wallet/wallet_transactions_header.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletControllerImp>(
      init: WalletControllerImp(),
      builder: (controller) {
        final wallet = controller.wallet;

        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Wallet",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(
            //       Icons.notifications_none,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {},
            //   ),
            // ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primaryColor,
                  AppColor.secondaryColor,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppStateView(
                statusRequest: controller.statusRequest,
                isEmpty: controller.statusRequest == StatusRequest.success &&
                    wallet == null,
                loadingMessage: "Loading wallet...",
                emptyTitle: "No Wallet Data",
                emptySubtitle: "Could not find wallet information.",
                errorTitle: "Failed to load wallet",
                errorSubtitle: "Please try again.",
                serverErrorTitle: "Server Error",
                serverErrorSubtitle: "Could not connect to the server.",
                onRetry: () => controller.getWallet(),
                child: RefreshIndicator(
                  color: AppColor.thirdColor,
                  backgroundColor: AppColor.fifthColor,
                  onRefresh: controller.refreshWallet,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (wallet != null) ...[
                        WalletBalanceCard(wallet: wallet),
                        const SizedBox(height: 20),
                        WalletActionButtons(
                          onTopUp: controller.goToTopUp,
                          onTransactions: controller.getAllTransactions,
                        ),
                        const SizedBox(height: 28),
                        WalletTransactionsHeader(
                          isShowingAll: controller.isShowingAllTransactions,
                          isLoading: controller.isLoadingAllTransactions,
                          onViewAll: controller.getAllTransactions,
                        ),
                        const SizedBox(height: 12),
                        if (controller.transactions.isEmpty)
                          _emptyTransactions()
                        else
                          ...controller.transactions.map((transaction) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: WalletTransactionCard(
                                transaction: transaction,
                              ),
                            );
                          }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emptyTransactions() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Text(
        "No transactions",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.55),
          fontSize: 14,
        ),
      ),
    );
  }
}