import 'package:Instahelp/modules/setting/colors.dart';
import 'package:flutter/material.dart';
import 'package:Instahelp/components/headerText.dart';
import 'package:Instahelp/helpers/sizeCalculator.dart';
import 'package:Instahelp/components/buttonBlue.dart';
import 'package:Instahelp/src/views/main/DashboardTabs.dart';

class AddPlaceSuccess extends StatefulWidget {
  AddPlaceSuccess({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddPlaceSuccessState createState() => _AddPlaceSuccessState();
}

class _AddPlaceSuccessState extends State<AddPlaceSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(padding: EdgeInsets.only(top: sizer(false, 176, context),
          bottom: sizer(false, 134, context), left: sizer(true,25,context), right: sizer(true,25,context)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset('assets/app/launch/logo.png', width: 140, height: 140,
              fit:BoxFit.contain),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 57),
                  child: Text('You’ve successfully created a new place',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: GoloColors.secondary1, fontSize: sizer(true,16.0,context))),
                ),
              ),
        ButtonBlue(onPressed: () {Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => DashboardTabs()),
                                      );}, title: 'CONTINUE'),

            ],
          ))
        ));
  }
}
