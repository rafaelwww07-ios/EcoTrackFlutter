import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../app.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/data/models/user_model.dart';
import '../widgets/statistics_chart.dart';
import '../widgets/theme_selector.dart';

/// Profile page with statistics and settings
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info card
                  _UserInfoCard(user: state.user),
                  const SizedBox(height: 24),
                  // Statistics
                  Text(
                    AppLocalizations.of(context)!.statistics,
                    style: context.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const StatisticsChart(),
                  const SizedBox(height: 24),
                  // Achievements
                  Text(
                    AppLocalizations.of(context)!.achievements,
                    style: context.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const _AchievementsGrid(),
                  const SizedBox(height: 24),
                  // Settings
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: context.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  ThemeSelector(
                    onThemeChanged: () {
                      // Update theme without reloading app
                      final appState = EcoTrackApp.of(context);
                      appState?.reloadThemeSettings();
                    },
                  ),
                  const SizedBox(height: 24),
                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(const LogoutEvent());
                        Navigator.of(context).pushReplacementNamed('/auth');
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(AppLocalizations.of(context)!.logout),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// User info card
class _UserInfoCard extends StatelessWidget {
  final UserModel user;

  const _UserInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: context.colors.primary.withOpacity(0.1),
                  child: user.photoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            user.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                  : Icon(
                      Icons.person,
                      size: 40,
                      color: context.colors.primary,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName ?? 'User',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.eco,
                        size: 16,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${user.ecoPoints} points',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Achievements grid
class _AchievementsGrid extends StatelessWidget {
  const _AchievementsGrid();

  // Mock achievements
  final List<_Achievement> _achievements = const [
    _Achievement(
      title: 'First Steps',
      description: 'Complete your first challenge',
      icon: Icons.flag,
      unlocked: true,
    ),
    _Achievement(
      title: 'Calculator Master',
      description: 'Use calculator 10 times',
      icon: Icons.calculate,
      unlocked: true,
    ),
    _Achievement(
      title: 'Eco Warrior',
      description: 'Reach 500 eco points',
      icon: Icons.emoji_events,
      unlocked: false,
    ),
    _Achievement(
      title: 'Recycling Hero',
      description: 'Visit 5 recycling points',
      icon: Icons.recycling,
      unlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _achievements.length,
      itemBuilder: (context, index) {
        final achievement = _achievements[index];
        return Card(
          color: achievement.unlocked
              ? null
              : context.colors.surface.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  achievement.icon,
                  size: 40,
                  color: achievement.unlocked
                      ? context.colors.primary
                      : context.colors.onBackground.withOpacity(0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  achievement.title,
                  style: context.textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Achievement model
class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });
}

