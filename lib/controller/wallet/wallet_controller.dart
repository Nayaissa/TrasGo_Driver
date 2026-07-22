import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/data/model/wallet_model.dart';
import 'package:transport_project/view/screen/home/profile_page.dart';

abstract class WalletController extends GetxController {
  Future<void> getWallet({bool showLoading = true});
  Future<void> getAllTransactions();
  Future<void> refreshWallet();
  void goToTopUp();
}

class WalletControllerImp extends WalletController {
  StatusRequest statusRequest = StatusRequest.loading;

  WalletModel? walletModel;
  WalletData? wallet;
  List<WalletTransactionModel> transactions = [];

  bool isShowingAllTransactions = false;
  bool isLoadingAllTransactions = false;

  @override
  void onInit() {
    super.onInit();
    getWallet();
  }

  @override
  Future<void> getWallet({bool showLoading = true}) async {
    if (showLoading) {
      statusRequest = StatusRequest.loading;
      update();
    }

    try {
      final response = await DioHelper.getDataa(url: "v1/driver/wallet");

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          walletModel = WalletModel.fromWalletJson(
            Map<String, dynamic>.from(body),
          );

          wallet = walletModel?.wallet;
          transactions = walletModel?.transactions ?? [];
          isShowingAllTransactions = false;
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (response != null && response.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;
        App.logout();
        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error) {
      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  @override
  Future<void> getAllTransactions() async {
    if (isLoadingAllTransactions) return;

    isLoadingAllTransactions = true;
    update();

    try {
      final response = await DioHelper.getDataa(
        url: "v1/driver/wallet/transactions",
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          final transactionsModel = WalletModel.fromTransactionsJson(
            Map<String, dynamic>.from(body),
          );

          transactions = transactionsModel.transactions;
          isShowingAllTransactions = true;
          statusRequest = StatusRequest.success;
        //  App.logout();
        } else {
          Get.snackbar(
            "Wallet",
            "فشل تحميل العمليات المالية",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response != null && response.statusCode == 401) {
        App.logout();
      } else {
        Get.snackbar(
          "Wallet",
          "فشل تحميل العمليات المالية",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Wallet",
        "حدث خطأ أثناء تحميل العمليات المالية",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isLoadingAllTransactions = false;
    update();
  }

  @override
  Future<void> refreshWallet() async {
    if (isShowingAllTransactions) {
      await getAllTransactions();
    } else {
      await getWallet(showLoading: false);
    }
  }

  @override
  void goToTopUp() {
    Get.toNamed("/walletTopUp");
  }
}
