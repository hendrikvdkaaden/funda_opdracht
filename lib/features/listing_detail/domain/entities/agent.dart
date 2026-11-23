import 'package:equatable/equatable.dart';

class Agent extends Equatable {
  const Agent({required this.name, this.phone});

  final String name;
  final String? phone;

  @override
  List<Object?> get props => [name, phone];
}
