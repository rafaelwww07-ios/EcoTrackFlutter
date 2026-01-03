part of 'calculator_bloc.dart';

/// Calculator events
abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

/// Load calculator event
class LoadCalculatorEvent extends CalculatorEvent {
  const LoadCalculatorEvent();
}

/// Calculate footprint event
class CalculateFootprintEvent extends CalculatorEvent {
  final CalculatorInputModel input;
  final bool autoSave;

  const CalculateFootprintEvent({
    required this.input,
    this.autoSave = true,
  });

  @override
  List<Object?> get props => [input, autoSave];
}

/// Reset calculator event
class ResetCalculatorEvent extends CalculatorEvent {
  const ResetCalculatorEvent();
}

/// Save footprint event
class SaveFootprintEvent extends CalculatorEvent {
  final CarbonFootprintModel footprint;

  const SaveFootprintEvent({required this.footprint});

  @override
  List<Object?> get props => [footprint];
}

/// Load history event
class LoadHistoryEvent extends CalculatorEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final int limit;

  const LoadHistoryEvent({
    this.startDate,
    this.endDate,
    this.limit = 30,
  });

  @override
  List<Object?> get props => [startDate, endDate, limit];
}

