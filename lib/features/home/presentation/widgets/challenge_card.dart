import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../../../core/utils/extensions.dart';
import '../../data/models/challenge_model.dart';
import '../../../../core/constants/app_constants.dart';

/// Challenge card widget
class ChallengeCard extends StatefulWidget {
  final ChallengeModel challenge;

  const ChallengeCard({
    super.key,
    required this.challenge,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.shortAnimation,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    // Vibrate on completion
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }

    // Animate completion
    await _animationController.forward();
    
    // TODO: Update challenge status in BLoC
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Challenge completed! +${widget.challenge.pointsReward} points',
          ),
          backgroundColor: context.colors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.challenge.isCompleted;
    final isExpired = widget.challenge.isExpired;

    return Card(
      child: InkWell(
        onTap: isCompleted || isExpired ? null : _handleComplete,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? context.colors.primary.withOpacity(0.1)
                      : context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.challenge.icon ?? '🌱',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.challenge.title,
                            style: context.textTheme.titleLarge?.copyWith(
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Icon(
                            Icons.check_circle,
                            color: context.colors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.challenge.description,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colors.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: context.colors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.challenge.pointsReward} points',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isExpired) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Expired',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

