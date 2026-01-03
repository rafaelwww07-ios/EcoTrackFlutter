import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/carbon_footprint_model.dart';
import '../../data/datasources/calculator_remote_datasource.dart';
import '../bloc/calculator_bloc.dart';
import '../widgets/calculator_form.dart';

/// Calculator page for carbon footprint
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.carbonFootprintCalculator),
      ),
      body: BlocProvider(
        create: (context) => CalculatorBloc(
          dataSource: CalculatorRemoteDataSource(),
        )..add(LoadCalculatorEvent()),
        child: const _CalculatorContent(),
      ),
    );
  }
}

/// Calculator content widget
class _CalculatorContent extends StatelessWidget {
  const _CalculatorContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        if (state is CalculatorLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CalculatorResult) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Results card
                _ResultsCard(footprint: state.footprint),
                const SizedBox(height: 24),
                // Chart
                _EmissionsChart(footprint: state.footprint),
                const SizedBox(height: 24),
                // Recommendations
                _RecommendationsCard(footprint: state.footprint),
                const SizedBox(height: 24),
                // Recalculate button
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CalculatorBloc>().add(ResetCalculatorEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.calculateAgain),
                ),
              ],
            ),
          );
        }

        // Show form
        return const CalculatorForm();
      },
    );
  }
}

/// Results card widget
class _ResultsCard extends StatelessWidget {
  final CarbonFootprintModel footprint;

  const _ResultsCard({required this.footprint});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.yourCarbonFootprint,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${footprint.totalEmissions.toStringAsFixed(2)} kg CO₂',
              style: context.textTheme.displayMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${footprint.totalEmissionsInTons.toStringAsFixed(3)} tons CO₂',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.onBackground.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            // Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BreakdownItem(
                  label: AppLocalizations.of(context)!.transport,
                  value: footprint.transportEmissions,
                  color: Colors.blue,
                ),
                _BreakdownItem(
                  label: AppLocalizations.of(context)!.energy,
                  value: footprint.energyEmissions,
                  color: Colors.orange,
                ),
                _BreakdownItem(
                  label: AppLocalizations.of(context)!.diet,
                  value: footprint.dietEmissions,
                  color: Colors.red,
                ),
                _BreakdownItem(
                  label: AppLocalizations.of(context)!.waste,
                  value: footprint.wasteEmissions,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Breakdown item widget
class _BreakdownItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Emissions chart widget
class _EmissionsChart extends StatelessWidget {
  final CarbonFootprintModel footprint;

  const _EmissionsChart({required this.footprint});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final breakdown = footprint.emissionsBreakdown;
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.green,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emissions Breakdown',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: breakdown['transport']!,
                      title: '${breakdown['transport']!.toStringAsFixed(1)}%',
                      color: colors[0],
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: breakdown['energy']!,
                      title: '${breakdown['energy']!.toStringAsFixed(1)}%',
                      color: colors[1],
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: breakdown['diet']!,
                      title: '${breakdown['diet']!.toStringAsFixed(1)}%',
                      color: colors[2],
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: breakdown['waste']!,
                      title: '${breakdown['waste']!.toStringAsFixed(1)}%',
                      color: colors[3],
                      radius: 60,
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _LegendItem(
                  label: 'Transport',
                  color: colors[0],
                ),
                _LegendItem(
                  label: 'Energy',
                  color: colors[1],
                ),
                _LegendItem(
                  label: 'Diet',
                  color: colors[2],
                ),
                _LegendItem(
                  label: 'Waste',
                  color: colors[3],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Legend item widget
class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// Recommendations card widget
class _RecommendationsCard extends StatelessWidget {
  final CarbonFootprintModel footprint;

  const _RecommendationsCard({required this.footprint});

  // Generate AI recommendations based on footprint
  List<String> _getRecommendations() {
    final breakdown = footprint.emissionsBreakdown;
    final recommendations = <String>[];

    if (breakdown['transport']! > 40) {
      recommendations.add(
        'Consider using public transport or cycling more often to reduce transport emissions',
      );
    }
    if (breakdown['energy']! > 30) {
      recommendations.add(
        'Switch to renewable energy sources or reduce electricity consumption',
      );
    }
    if (breakdown['diet']! > 30) {
      recommendations.add(
        'Reduce meat consumption and incorporate more plant-based meals',
      );
    }
    if (breakdown['waste']! > 20) {
      recommendations.add(
        'Improve waste management and recycling practices',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        'Great job! Your carbon footprint is relatively low. Keep up the good work!',
      );
    }

    return recommendations;
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = _getRecommendations();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: context.colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Personalized Recommendations',
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

