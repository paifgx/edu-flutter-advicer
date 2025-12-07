import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/advice_entity.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

class AddFavoriteEvent extends FavoritesEvent {
  final AdviceEntity advice;
  const AddFavoriteEvent({required this.advice});

  @override
  List<Object?> get props => [advice];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int id;
  const RemoveFavoriteEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

