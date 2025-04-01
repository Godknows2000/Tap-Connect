// ignore_for_file: unnecessary_cast

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapconnect/models/user_model.dart';

Rx<UserModel?> kUser = (null as UserModel?).obs;

keyboardUnFocus() => FocusManager.instance.primaryFocus?.unfocus();
