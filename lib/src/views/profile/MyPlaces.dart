import 'package:Instahelp/components/backButtonWhite.dart';
import 'package:Instahelp/components/buttonBlue.dart';
import 'package:Instahelp/components/emptyData.dart';
import 'package:Instahelp/modules/setting/colors.dart';
import 'package:Instahelp/src/providers/request_services/Api+auth.dart';
import 'package:Instahelp/src/views/auth/signin.dart';
import 'package:Instahelp/src/views/profile/AddPlace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:Instahelp/modules/setting/fonts.dart';
import 'package:Instahelp/modules/state/AppState.dart';
import 'package:Instahelp/src/blocs/navigation/NavigationBloc.dart';
import 'package:Instahelp/src/entity/City.dart';
import 'package:Instahelp/src/views/wishlist/controls/CityCell.dart';

class MyPlaces extends StatefulWidget {
  MyPlaces({
    Key key,
  }) : super(key: key);

  @override
  _MyPlacesState createState() {
    return _MyPlacesState();
  }
}

class _MyPlacesState extends State<MyPlaces> {
  bool _loader = false;
  @override
  void initState() {
    super.initState();
    setState((){
      _loader = true;
    });
    ApiAuth.fetchPlaces().then((response) {
      AppState().myPlaces = List<City>.generate(
          response['data'].length, (i) => City.fromJson(response['data'][i]));
       setState((){
      _loader = false;
    });    
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ListView(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        children: <Widget>[
           Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            BackButtonWhite(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
          // ### 1. Header
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 25,
              right: 25,
            ),
            height: 60,
            child: Text(
              "My Places",
              style: TextStyle(
                  fontFamily: GoloFont,
                  fontWeight: FontWeight.w600,
                  fontSize: 32),
            ),
          ),
            _loader ?Center(
                        child:  CircularProgressIndicator(backgroundColor: GoloColors.primary,
                    )
                      ) :AppState().myPlaces!= null&&AppState().myPlaces.length > 0
              ? Column(
                children:<Widget>[
                  Container(
                height:200,
                child: _buildMyPlacesGridView()),
                SizedBox(height:10),
                ButtonBlue(title: 'ADD NEW PLACE', onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddPlace()),
                        );
                      })])
              : Column(children: <Widget>[
                  // #7 padding bottom
                  SizedBox(height: 80),
                  EmptyData(
                      title: 'You have no places currently',
                      isButton: true,
                      buttonText: 'ADD PLACE',
                      buttonFn: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddPlace()),
                        );
                      }),
                ])
        ],
        scrollDirection: Axis.vertical,
      ),
    ));
  }

  // ### City list
  Widget _buildMyPlacesGridView() => new GridView.count(
    
      padding: EdgeInsets.only(top: 5, bottom: 5),
      crossAxisCount: 2,
     // childAspectRatio: 0.715,
      children: List.generate(AppState().myPlaces.length, (index) {
        return _buildMyPlacesCell(index);
      }));

  Widget _buildMyPlacesCell(int imageIndex) => Container(
      child: Container(
          margin: EdgeInsets.only(right: 8, bottom: 8),
          height: 350,
          child: GestureDetector(
            child: CityCell(city: AppState().myPlaces[imageIndex],
            myPlace:true),
            onTap: () {
              HomeNav(context).openCity(AppState().myPlaces[imageIndex]);
            },
          )));
}
