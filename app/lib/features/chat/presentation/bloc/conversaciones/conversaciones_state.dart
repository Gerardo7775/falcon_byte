import 'package:equatable/equatable.dart';
import '../../../domain/entities/conversacion.dart';

abstract class ConversacionesState extends Equatable {
  const ConversacionesState();

  @override
  List<Object> get props => [];
}

class ConversacionesInitial extends ConversacionesState {}

class ConversacionesLoading extends ConversacionesState {}

class ConversacionesLoaded extends ConversacionesState {
  final List<Conversacion> conversaciones;

  const ConversacionesLoaded(this.conversaciones);

  @override
  List<Object> get props => [conversaciones];
}

class ConversacionesError extends ConversacionesState {
  final String mensaje;

  const ConversacionesError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}
