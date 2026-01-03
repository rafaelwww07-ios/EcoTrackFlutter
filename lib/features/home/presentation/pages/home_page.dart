import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../data/models/challenge_model.dart';
import '../widgets/challenge_card.dart';
import '../widgets/eco_rating_card.dart';
import '../../../../features/calculator/presentation/pages/calculator_page.dart';
import '../../../../features/map/presentation/pages/map_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../../l10n/app_localizations.dart';

/// Home page with eco rating and challenges
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomeTab(),
    const CalculatorPage(),
    const MapPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.calculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: l10n.map,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

/// Home tab content
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  // Get localized challenges
  static List<ChallengeModel> _getChallenges(AppLocalizations l10n) {
    return [
      ChallengeModel(
        id: '1',
        title: l10n.challengeUsePublicTransport,
        description: l10n.challengeUsePublicTransportDesc,
        type: ChallengeType.weekly,
        pointsReward: 100,
        status: ChallengeStatus.active,
        expiresAt: DateTime(2024, 12, 31),
        icon: '🚌',
      ),
      ChallengeModel(
        id: '2',
        title: l10n.challengeReduceMeat,
        description: l10n.challengeReduceMeatDesc,
        type: ChallengeType.weekly,
        pointsReward: 75,
        status: ChallengeStatus.active,
        expiresAt: DateTime(2024, 12, 31),
        icon: '🥗',
      ),
      ChallengeModel(
        id: '3',
        title: l10n.challengeRecycleElectronics,
        description: l10n.challengeRecycleElectronicsDesc,
        type: ChallengeType.monthly,
        pointsReward: 150,
        status: ChallengeStatus.active,
        expiresAt: DateTime(2025, 1, 31),
        icon: '💻',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final challenges = _getChallenges(l10n);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eco Rating Card
            const EcoRatingCard(ecoPoints: 250),
            const SizedBox(height: 24),
            // Quick Calculator Button
            _QuickCalculatorButton(),
            const SizedBox(height: 24),
            // Active Challenges
            Text(
              l10n.activeChallenges,
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Challenges List
            ...challenges.map(
              (challenge) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChallengeCard(challenge: challenge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick calculator button
class _QuickCalculatorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Hero(
      tag: 'calculator_button',
      child: Card(
        child: InkWell(
          onTap: () {
            // Navigate to calculator tab
            // Note: This would need to be handled by parent widget
            // For now, just show a message
            context.showSnackBar('Navigate to Calculator tab');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calculate,
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
                        l10n.calculateCarbonFootprint,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.trackYourImpact,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: context.colors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

