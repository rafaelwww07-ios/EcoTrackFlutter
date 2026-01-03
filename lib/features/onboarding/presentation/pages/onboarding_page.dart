import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';

/// Onboarding page with 3 screens
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingScreen> _screens = [
    OnboardingScreen(
      title: 'Track Your Carbon Footprint',
      description:
          'Calculate and monitor your environmental impact with our easy-to-use calculator',
      icon: Icons.eco,
      color: AppTheme.ecoPrimary,
    ),
    OnboardingScreen(
      title: 'Find Recycling Points',
      description:
          'Discover nearby recycling centers and waste collection points on an interactive map',
      icon: Icons.location_on,
      color: AppTheme.ecoSecondary,
    ),
    OnboardingScreen(
      title: 'Complete Eco Challenges',
      description:
          'Earn points and achievements by completing daily environmental challenges',
      icon: Icons.emoji_events,
      color: AppTheme.ecoAccent,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingCompleted, true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Skip'),
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  return _OnboardingScreenWidget(
                    screen: _screens[index],
                  );
                },
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _screens.length,
                (index) => _PageIndicator(
                  isActive: index == _currentPage,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _currentPage == _screens.length - 1
                      ? _completeOnboarding
                      : () {
                          _pageController.nextPage(
                            duration: AppConstants.mediumAnimation,
                            curve: Curves.easeInOut,
                          );
                        },
                  child: Text(
                    _currentPage == _screens.length - 1
                        ? 'Get Started'
                        : 'Next',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Individual onboarding screen widget
class _OnboardingScreenWidget extends StatelessWidget {
  final OnboardingScreen screen;

  const _OnboardingScreenWidget({required this.screen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: AppConstants.longAnimation,
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: screen.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    screen.icon,
                    size: 100,
                    color: screen.color,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            screen.title,
            style: context.textTheme.displaySmall?.copyWith(
              color: screen.color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            screen.description,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Page indicator widget
class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.primary
            : context.colors.primary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Onboarding screen data model
class OnboardingScreen {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingScreen({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

