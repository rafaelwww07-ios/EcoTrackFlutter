import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/extensions.dart';

/// Empty state widget with optional Lottie animation
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? message;
  final String? lottieAsset;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.lottieAsset,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null)
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  lottieAsset!,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: context.colors.primary.withOpacity(0.5),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: context.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onBackground.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

