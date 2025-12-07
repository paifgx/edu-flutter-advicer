import 'package:equatable/equatable.dart';

abstract class AdviceEvent extends Equatable {
  const AdviceEvent();

  @override
  List<Object?> get props => [];
}

class AdviceRequestedEvent extends AdviceEvent {
  const AdviceRequestedEvent();
}

