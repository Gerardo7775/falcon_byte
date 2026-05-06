import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Clase base para todos los casos de uso
// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Parámetros vacíos para casos de uso sin parámetros
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
