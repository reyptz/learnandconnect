import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  final String userId;

  LoadUserProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserProfile extends ProfileEvent {
  final User user;

  UpdateUserProfile({required this.user});

  @override
  List<Object> get props => [user];
}
