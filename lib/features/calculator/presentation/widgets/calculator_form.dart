import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/calculator_bloc.dart';
import '../../data/models/carbon_footprint_model.dart';

/// Calculator form widget
class CalculatorForm extends StatefulWidget {
  const CalculatorForm({super.key});

  @override
  State<CalculatorForm> createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  final _formKey = GlobalKey<FormState>();
  final _carKmController = TextEditingController();
  final _busKmController = TextEditingController();
  final _trainKmController = TextEditingController();
  final _planeKmController = TextEditingController();
  final _electricityController = TextEditingController();
  final _meatController = TextEditingController();
  final _dairyController = TextEditingController();
  final _wasteController = TextEditingController();

  @override
  void dispose() {
    _carKmController.dispose();
    _busKmController.dispose();
    _trainKmController.dispose();
    _planeKmController.dispose();
    _electricityController.dispose();
    _meatController.dispose();
    _dairyController.dispose();
    _wasteController.dispose();
    super.dispose();
  }

  void _handleCalculate() {
    if (_formKey.currentState!.validate()) {
      final input = CalculatorInputModel(
        carKm: double.tryParse(_carKmController.text) ?? 0,
        busKm: double.tryParse(_busKmController.text) ?? 0,
        trainKm: double.tryParse(_trainKmController.text) ?? 0,
        planeKm: double.tryParse(_planeKmController.text) ?? 0,
        electricityKwh: double.tryParse(_electricityController.text) ?? 0,
        meatKg: double.tryParse(_meatController.text) ?? 0,
        dairyKg: double.tryParse(_dairyController.text) ?? 0,
        wasteKg: double.tryParse(_wasteController.text) ?? 0,
      );

      context.read<CalculatorBloc>().add(
            CalculateFootprintEvent(input: input),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transport section
            _SectionHeader(
              icon: Icons.directions_car,
              title: l10n.transport,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _carKmController,
              label: l10n.car,
              icon: Icons.directions_car,
            ),
            const SizedBox(height: 12),
            _InputField(
              controller: _busKmController,
              label: l10n.bus,
              icon: Icons.directions_bus,
            ),
            const SizedBox(height: 12),
            _InputField(
              controller: _trainKmController,
              label: l10n.train,
              icon: Icons.train,
            ),
            const SizedBox(height: 12),
            _InputField(
              controller: _planeKmController,
              label: l10n.plane,
              icon: Icons.flight,
            ),
            const SizedBox(height: 24),
            // Energy section
            _SectionHeader(
              icon: Icons.bolt,
              title: l10n.energy,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _electricityController,
              label: l10n.electricity,
              icon: Icons.bolt,
            ),
            const SizedBox(height: 24),
            // Diet section
            _SectionHeader(
              icon: Icons.restaurant,
              title: l10n.diet,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _meatController,
              label: l10n.meat,
              icon: Icons.set_meal,
            ),
            const SizedBox(height: 12),
            _InputField(
              controller: _dairyController,
              label: l10n.dairy,
              icon: Icons.local_drink,
            ),
            const SizedBox(height: 24),
            // Waste section
            _SectionHeader(
              icon: Icons.delete,
              title: l10n.waste,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _wasteController,
              label: l10n.waste,
              icon: Icons.delete,
            ),
            const SizedBox(height: 32),
            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleCalculate,
                child: Text(l10n.calculateCarbonFootprint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: context.textTheme.titleLarge,
        ),
      ],
    );
  }
}

/// Input field widget
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixText: 'per month',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final num = double.tryParse(value);
          if (num == null || num < 0) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }
}

