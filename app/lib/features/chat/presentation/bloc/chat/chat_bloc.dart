import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/enviar_mensaje_usecase.dart';
import '../../../domain/usecases/marcar_mensajes_leidos_usecase.dart';
import '../../../domain/usecases/obtener_mensajes_stream_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ObtenerMensajesStreamUseCase obtenerMensajesUseCase;
  final EnviarMensajeUseCase enviarMensajeUseCase;
  final MarcarMensajesComoLeidosUseCase marcarMensajesComoLeidosUseCase;

  ChatBloc({
    required this.obtenerMensajesUseCase,
    required this.enviarMensajeUseCase,
    required this.marcarMensajesComoLeidosUseCase,
  }) : super(ChatInitial()) {
    on<IniciarChatStreamEvent>(_onIniciarStream);
    on<ActualizarMensajesEvent>(_onActualizarMensajes);
    on<EnviarMensajeEvent>(_onEnviarMensaje);
    on<MarcarComoLeidosEvent>(_onMarcarComoLeidos);
  }

  Future<void> _onIniciarStream(
      IniciarChatStreamEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    await emit.forEach(
      obtenerMensajesUseCase(event.conversacionId),
      onData: (mensajes) => ChatLoaded(mensajes),
      onError: (error, _) => ChatError(error.toString()),
    );
  }

  void _onActualizarMensajes(
      ActualizarMensajesEvent event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.mensajes));
  }

  Future<void> _onEnviarMensaje(
      EnviarMensajeEvent event, Emitter<ChatState> emit) async {
    try {
      await enviarMensajeUseCase(
        conversacionId: event.conversacionId,
        senderId: event.senderId,
        texto: event.texto,
      );
    } catch (e) {
      // Como RTDB tiene soporte offline por defecto en sus transacciones y Streams locales,
      // un fallo aquí sería grave.
      emit(ChatError('No se pudo enviar el mensaje: $e'));
    }
  }

  Future<void> _onMarcarComoLeidos(
      MarcarComoLeidosEvent event, Emitter<ChatState> emit) async {
    try {
      await marcarMensajesComoLeidosUseCase(event.conversacionId, event.miId);
    } catch (_) {
      // Ignorar errores menores
    }
  }
}
