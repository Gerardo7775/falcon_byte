import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/obtener_conversaciones_stream_usecase.dart';
import 'conversaciones_event.dart';
import 'conversaciones_state.dart';

class ConversacionesBloc
    extends Bloc<ConversacionesEvent, ConversacionesState> {
  final ObtenerConversacionesStreamUseCase obtenerConversacionesUseCase;

  ConversacionesBloc({
    required this.obtenerConversacionesUseCase,
  }) : super(ConversacionesInitial()) {
    on<IniciarStreamConversaciones>(_onIniciarStream);
    on<ActualizarConversacionesEvent>(_onActualizarConversaciones);
  }

  Future<void> _onIniciarStream(IniciarStreamConversaciones event,
      Emitter<ConversacionesState> emit) async {
    emit(ConversacionesLoading());

    await emit.forEach(
      obtenerConversacionesUseCase(event.usuarioId),
      onData: (conversaciones) => ConversacionesLoaded(conversaciones),
      onError: (error, stackTrace) => ConversacionesError(error.toString()),
    );
  }

  void _onActualizarConversaciones(
      ActualizarConversacionesEvent event, Emitter<ConversacionesState> emit) {
    emit(ConversacionesLoaded(event.conversaciones));
  }
}
