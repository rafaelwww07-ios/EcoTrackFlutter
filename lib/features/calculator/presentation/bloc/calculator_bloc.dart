import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/carbon_footprint_model.dart';
import '../../data/datasources/calculator_remote_datasource.dart';
import '../../../../core/constants/app_constants.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

/// Calculator BLoC
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final CalculatorRemoteDataSource? _dataSource;

  CalculatorBloc({CalculatorRemoteDataSource? dataSource})
      : _dataSource = dataSource,
        super(CalculatorInitial()) {
    on<LoadCalculatorEvent>(_onLoadCalculator);
    on<CalculateFootprintEvent>(_onCalculateFootprint);
    on<ResetCalculatorEvent>(_onResetCalculator);
    on<SaveFootprintEvent>(_onSaveFootprint);
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onLoadCalculator(
    LoadCalculatorEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    emit(CalculatorInitial());
  }

  Future<void> _onCalculateFootprint(
    CalculateFootprintEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    emit(CalculatorLoading());

    try {
      // Calculate emissions
      final transportEmissions = _calculateTransportEmissions(event.input);
      final energyEmissions = _calculateEnergyEmissions(event.input);
      final dietEmissions = _calculateDietEmissions(event.input);
      final wasteEmissions = _calculateWasteEmissions(event.input);

      final footprint = CarbonFootprintModel(
        transportEmissions: transportEmissions,
        energyEmissions: energyEmissions,
        dietEmissions: dietEmissions,
        wasteEmissions: wasteEmissions,
        calculatedAt: DateTime.now(),
      );

      emit(CalculatorResult(footprint: footprint));
      
      // Auto-save to Firestore if data source is available
      if (_dataSource != null && event.autoSave) {
        try {
          await _dataSource!.saveCarbonFootprint(footprint);
        } catch (e) {
          // Silently fail - calculation is still successful
          print('Failed to auto-save footprint: $e');
        }
      }
    } catch (e) {
      emit(CalculatorError(message: e.toString()));
    }
  }

  Future<void> _onSaveFootprint(
    SaveFootprintEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    if (_dataSource == null) {
      emit(CalculatorError(message: 'Firestore not available'));
      return;
    }

    try {
      await _dataSource!.saveCarbonFootprint(event.footprint);
      emit(CalculatorSaved());
    } catch (e) {
      emit(CalculatorError(message: e.toString()));
    }
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    if (_dataSource == null) {
      return;
    }

    emit(CalculatorLoading());
    try {
      final history = await _dataSource!.getUserFootprintHistory(
        startDate: event.startDate,
        endDate: event.endDate,
        limit: event.limit,
      );
      emit(CalculatorHistoryLoaded(history: history));
    } catch (e) {
      emit(CalculatorError(message: e.toString()));
    }
  }

  Future<void> _onResetCalculator(
    ResetCalculatorEvent event,
    Emitter<CalculatorState> emit,
  ) async {
    emit(CalculatorInitial());
  }

  /// Calculate transport emissions
  double _calculateTransportEmissions(CalculatorInputModel input) {
    return (input.carKm * AppConstants.carEmissionPerKm) +
        (input.busKm * AppConstants.busEmissionPerKm) +
        (input.trainKm * AppConstants.trainEmissionPerKm) +
        (input.planeKm * AppConstants.planeEmissionPerKm);
  }

  /// Calculate energy emissions
  double _calculateEnergyEmissions(CalculatorInputModel input) {
    return input.electricityKwh * AppConstants.electricityEmissionPerKwh;
  }

  /// Calculate diet emissions
  double _calculateDietEmissions(CalculatorInputModel input) {
    return (input.meatKg * AppConstants.meatEmissionPerKg) +
        (input.dairyKg * AppConstants.dairyEmissionPerKg);
  }

  /// Calculate waste emissions
  double _calculateWasteEmissions(CalculatorInputModel input) {
    return input.wasteKg * AppConstants.wasteEmissionPerKg;
  }
}

