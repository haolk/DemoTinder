import 'package:flutter/material.dart';
import 'package:tenderapp/model/radio_model.dart';

class RadioItemWidget extends StatelessWidget {
  RadioModel _item;

  RadioItemWidget(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      child: Icon(
        _item.icon,
        size: 30.0,
        color: _item.isSelected ? Colors.green : Colors.grey,
      ),
    );
  }
}
