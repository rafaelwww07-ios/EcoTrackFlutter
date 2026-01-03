import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';

/// Eco rating card with animated progress bar
class EcoRatingCard extends StatefulWidget {
  final int ecoPoints;

  const EcoRatingCard({
    super.key,
    required this.ecoPoints,
  });

  @override
  State<EcoRatingCard> createState() => _EcoRatingCardState();
}

class _EcoRatingCardState extends State<EcoRatingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: EcoLevel.getProgressForPoints(widget.ecoPoints),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(EcoRatingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ecoPoints != widget.ecoPoints) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: EcoLevel.getProgressForPoints(widget.ecoPoints),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = EcoLevel.getLevelForPoints(widget.ecoPoints);
    final nextLevel = AppConstants.ecoLevels.firstWhere(
      (l) => l.minPoints > widget.ecoPoints,
      orElse: () => level,
    );
    final pointsToNextLevel = nextLevel.minPoints - widget.ecoPoints;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: context.colors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eco Rating',
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        level.name,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${widget.ecoPoints}',
                  style: context.textTheme.displaySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Progress bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        minHeight: 12,
                        backgroundColor:
                            context.colors.primary.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.colors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pointsToNextLevel > 0
                          ? '$pointsToNextLevel points to ${nextLevel.name}'
                          : 'Max level reached!',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onBackground.withOpacity(0.7),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

