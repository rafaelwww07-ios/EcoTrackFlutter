part of 'calculator_bloc.dart';

/// Calculator states
abstract class CalculatorState extends Equatable {
  const CalculatorState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CalculatorInitial extends CalculatorState {}

/// Loading state
class CalculatorLoading extends CalculatorState {}

/// Result state
class CalculatorResult extends CalculatorState {
  final CarbonFootprintModel footprint;

  const CalculatorResult({required this.footprint});

  @override
  List<Object?> get props => [footprint];
}

/// Error state
class CalculatorError extends CalculatorState {
  final String message;

  const CalculatorError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Saved state
class CalculatorSaved extends CalculatorState {}

/// History loaded state
class CalculatorHistoryLoaded extends CalculatorState {
  final List<CarbonFootprintModel> history;

  const CalculatorHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

