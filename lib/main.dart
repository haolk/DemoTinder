import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tenderapp/model/action_radio.dart';
import 'package:tenderapp/model/radio_model.dart';
import 'package:tenderapp/widget/radio_item_widget.dart';

import 'package:http/http.dart' as http;
import 'database/database_hepler.dart';
import 'model/profile.dart';
import 'model/result.dart';
import 'model/results.dart';
import 'model/user.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _index = 0;
  final double borderRadius = 5.0;
  Color activeIconColor = Colors.green;
  Color inActiveIconColor = Colors.grey;

  List<RadioModel> _radioModels = List();
  Profile _profile;
  String _description = '';
  String _value = '';
  DatabaseHelper _db;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectivityResult;
  List<Profile> _profiles;

  @override
  void initState() {
    super.initState();
    _db = new DatabaseHelper();
    _radioModels.add(RadioModel(false, Icons.public, ActionRadio.public));
    _radioModels
        .add(RadioModel(false, Icons.date_range, ActionRadio.date_range));
    _radioModels.add(RadioModel(true, Icons.place, ActionRadio.place));
    _radioModels.add(RadioModel(false, Icons.call, ActionRadio.call));
    _radioModels.add(RadioModel(false, Icons.lock, ActionRadio.lock));
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: Dismissible(
          resizeDuration: null,
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              saveDataAnCallNewUser();
            } else {
              fetchNewData();
            }
          },
          key: new ValueKey(_counter),
          child: _profile != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 320,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 70.0,
                                  color: Color(0xFF263238),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 70.0,
                                    color: Color(0xFFE0E0E0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE0E0E0),
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(borderRadius),
                                              topRight:
                                                  Radius.circular(borderRadius),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 180.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(borderRadius),
                                              bottomRight:
                                                  Radius.circular(borderRadius),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                _description,
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                _value,
                                                style: TextStyle(
                                                  fontSize: 28.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12.0,
                                              ),
                                              Container(
                                                  alignment: Alignment.center,
                                                  height: 50,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount:
                                                          _radioModels.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          child:
                                                              RadioItemWidget(
                                                                  _radioModels[
                                                                      index]),
                                                          onTap: () {
                                                            onSelect(index);
                                                          },
                                                        );
                                                      }))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Container(
                                        height: 130,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Color(0xFFBDBDBD),
                                              width: 1.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _profile.picture), //TODO:
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container()),
    ));
  }

  void onSelect(index) {
    setState(() {
      _radioModels.forEach((element) => element.isSelected = false);
      _radioModels[index].isSelected = true;
      switch (_radioModels[index].action) {
        case ActionRadio.public:
          _description = 'My public is';
          _value = _profile.public;
          break;
        case ActionRadio.date_range:
          _description = 'My birthday is';
          final df = new DateFormat('dd-MM-yyyy');
          _value = df.format(new DateTime.fromMillisecondsSinceEpoch(
              int.parse(_profile.birthday) * 1000));
          break;
        case ActionRadio.place:
          _description = 'My address is';
          _value = _profile.address;
          break;
        case ActionRadio.call:
          _description = 'My phone is';
          _value = _profile.phone;
          break;
        case ActionRadio.lock:
          _description = 'My email is';
          _value = _profile.email;
          break;
        default:
          _description = 'My address is';
          _value = _profile.address;
          break;
      }
    });
  }

  void getDataLocal() {
    _db.getProfile().then((value) {
      _profiles = value;
      if (_profiles != null && _profiles.length > 0) {
        setState(() {
          _profile = _profiles[_index];
          _description = 'My address is';
          _value = _profile.address;
        });
      }
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          fetchUser();
        });
        break;
      case ConnectivityResult.none:
      default:
        setState(() {
          getDataLocal();
        });
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  fetchUser() async {
    final response = await http.get('https://randomuser.me/api/0.4/?randomapi');
    if (response.statusCode == 200) {
      print('response: ${response.body}');
      setState(() {
        Result _result =
            Results.fromJson(json.decode(response.body)).results[0];
        User user = _result.user;
        _profile = Profile(
            user.sha1,
            user.name.first + user.name.last,
            user.dob,
            user.location.street,
            user.phone,
            user.email,
            user.picture);
        _description = 'My address is';
        _value = _profile.address;
      });
    }
  }

  void saveDataAnCallNewUser() {
    setState(() {
      _counter += 1;
      if (_connectivityResult != ConnectivityResult.none) {
        _db.saveProfile(_profile);
        fetchUser();
      }
    });
  }

  void fetchNewData() {
    setState(() {
      _counter += -1;
      if (_connectivityResult != ConnectivityResult.none) {
        fetchUser();
      } else {
        if (_index == _profiles.length - 1) {
          _index--;
        } else {
          _index++;
        }
        _profile = _profiles[_index];
      }
    });
  }
}
