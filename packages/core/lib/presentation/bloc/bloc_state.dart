import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  const BlocState();

  @override
  List<Object?> get props => [];
}

class BlocEmpty extends BlocState {}

class BlocLoading extends BlocState {}

class BlocError extends BlocState {
  final String message;

  const BlocError(this.message);

  @override
  List<Object> get props => [message];
}

class BlocHasData<T extends Object?> extends BlocState {
  final T result;

  const BlocHasData(this.result);

  @override
  List<T> get props => [result];
}
