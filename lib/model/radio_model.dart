import 'package:flutter/widgets.dart';

import 'action_radio.dart';

class RadioModel {
  bool isSelected;
  final IconData icon;
  final ActionRadio action;

  RadioModel(this.isSelected, this.icon, this.action);
}
