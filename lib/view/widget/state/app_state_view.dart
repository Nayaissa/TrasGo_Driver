import 'package:flutter/material.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/view/widget/state/app_loading_widget.dart';
import 'package:transport_project/view/widget/state/app_state_message.dart';

class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.statusRequest,
    required this.child,
    this.isEmpty = false,
    this.onRetry,
    this.loadingMessage = "Loading...",
    this.emptyTitle = "No Data Found",
    this.emptySubtitle = "There is no data to display right now.",
    this.errorTitle = "Something went wrong",
    this.errorSubtitle = "Please try again later.",
    this.serverErrorTitle = "Server Error",
    this.serverErrorSubtitle = "We could not connect to the server.",
    this.emptyImagePath,
  });

  final StatusRequest? statusRequest;
  final Widget child;

  final bool isEmpty;
  final VoidCallback? onRetry;

  final String loadingMessage;

  final String emptyTitle;
  final String emptySubtitle;

  final String errorTitle;
  final String errorSubtitle;

  final String serverErrorTitle;
  final String serverErrorSubtitle;

  final String? emptyImagePath;

  @override
  Widget build(BuildContext context) {
    if (statusRequest == StatusRequest.loading) {
      return AppLoadingWidget(
        message: loadingMessage,
      );
    }

    if (statusRequest == StatusRequest.serverfailure) {
      return AppStateMessage(
        title: serverErrorTitle,
        subtitle: serverErrorSubtitle,
        icon: Icons.cloud_off_outlined,
        buttonText: onRetry == null ? null : "Try Again",
        onPressed: onRetry,
      );
    }

    if (statusRequest == StatusRequest.failure) {
      return AppStateMessage(
        title: errorTitle,
        subtitle: errorSubtitle,
        icon: Icons.error_outline_rounded,
        buttonText: onRetry == null ? null : "Try Again",
        onPressed: onRetry,
      );
    }

    if (statusRequest == StatusRequest.success && isEmpty) {
      return AppStateMessage(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: Icons.inbox_outlined,
        imagePath: emptyImagePath,
      );
    }

    return child;
  }
}