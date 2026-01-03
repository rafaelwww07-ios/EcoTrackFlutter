import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:eco_track_flutter/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:eco_track_flutter/features/calculator/data/models/carbon_footprint_model.dart';

void main() {
  group('CalculatorBloc', () {
    late CalculatorBloc calculatorBloc;

    setUp(() {
      calculatorBloc = CalculatorBloc();
    });

    tearDown(() {
      calculatorBloc.close();
    });

    test('initial state is CalculatorInitial', () {
      expect(calculatorBloc.state, isA<CalculatorInitial>());
    });

    blocTest<CalculatorBloc, CalculatorState>(
      'emits CalculatorLoading then CalculatorResult when CalculateFootprintEvent is added',
      build: () => calculatorBloc,
      act: (bloc) => bloc.add(
        CalculateFootprintEvent(
          input: const CalculatorInputModel(
            carKm: 100,
            electricityKwh: 200,
            meatKg: 10,
            wasteKg: 20,
          ),
        ),
      ),
      expect: () => [
        isA<CalculatorLoading>(),
        isA<CalculatorResult>(),
      ],
      verify: (bloc) {
        final state = bloc.state;
        expect(state, isA<CalculatorResult>());
        if (state is CalculatorResult) {
          expect(state.footprint.totalEmissions, greaterThan(0));
          expect(state.footprint.transportEmissions, greaterThan(0));
          expect(state.footprint.energyEmissions, greaterThan(0));
          expect(state.footprint.dietEmissions, greaterThan(0));
          expect(state.footprint.wasteEmissions, greaterThan(0));
        }
      },
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits CalculatorInitial when ResetCalculatorEvent is added',
      build: () => calculatorBloc,
      seed: () => CalculatorResult(
        footprint: CarbonFootprintModel(
          transportEmissions: 10,
          energyEmissions: 20,
          dietEmissions: 30,
          wasteEmissions: 40,
          calculatedAt: DateTime.now(),
        ),
      ),
      act: (bloc) => bloc.add(const ResetCalculatorEvent()),
      expect: () => [
        isA<CalculatorInitial>(),
      ],
    );
  });
}


