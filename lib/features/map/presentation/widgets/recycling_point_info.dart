import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/extensions.dart';
import '../../data/models/recycling_point_model.dart';

/// Recycling point info card
class RecyclingPointInfo extends StatelessWidget {
  final RecyclingPointModel point;
  final VoidCallback onClose;

  const RecyclingPointInfo({
    super.key,
    required this.point,
    required this.onClose,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.name,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        point.address,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colors.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Accepted types
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: point.acceptedTypes.map((type) {
                return Chip(
                  label: Text(type.displayName),
                  avatar: Text(type.iconName),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Details
            if (point.hours != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: context.colors.onBackground.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    point.hours!,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (point.phone != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: context.colors.onBackground.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _callPhone(point.phone!),
                    child: Text(point.phone!),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (point.website != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 16,
                    color: context.colors.onBackground.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _launchUrl(point.website!),
                    child: const Text('Visit Website'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            // Directions button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Open in maps app
                },
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

