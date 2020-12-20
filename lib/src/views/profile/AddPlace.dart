import 'dart:io';
import 'package:Instahelp/modules/setting/colors.dart';
import 'package:Instahelp/src/entity/City.dart';
import 'package:Instahelp/src/entity/PlaceCategory.dart';
import 'package:Instahelp/src/views/main/DashboardTabs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Instahelp/components/headerText.dart';
import 'package:Instahelp/components/subText.dart';
import 'package:Instahelp/helpers/sizeCalculator.dart';
import 'package:Instahelp/components/buttonBlue.dart';
import 'package:Instahelp/components/backButtonWhite.dart';
import 'package:Instahelp/components/authTextInput.dart';
import 'package:Instahelp/components/authSelectInput.dart';
import 'package:Instahelp/components/authEmailInput.dart';
import 'package:Instahelp/components/authPhoneInput.dart';
import 'package:Instahelp/modules/state/AppState.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import './AddPlaceSuccess.dart';

const kGoogleApiKey = "AIzaSyBRWIXQCbRpusFNiQitxMJy_89gguGk66w";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddPlace extends StatefulWidget {
  AddPlace({
    Key key,
  }) : super(key: key);

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String name;
  String description;
  String priceRange;
  String email;
  String phone;
  String website;
  String youtube;
  String facebook;
  String mondayDays;
  String tuesdayDays;
  String wednesdayDays;
  String thursdayDays;
  String fridayDays;
  String saturdayDays;
  String sundayDays;
  int stateId;
  int cityId;
  PlaceCategory _value;
  City __value;
  double latitude;
  double longitude;
  String address;
  final GlobalKey<ScaffoldState> homeScaffoldKey = new GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  String gallery;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

       void preAddPlace() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to our variables
      _formKey.currentState.save();
      addPlaceFn();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

    Future<dynamic> addPlaceFn() async {
     
    setState(() {
      _loading = true;
    }); var thumbData = await MultipartFile.fromFile(
            _imageFile.path,
          );
          print(thumbData);
    FormData body = FormData.fromMap({ 
    "en": {
        "name": name,
        "description": description
    },
    "price_range": priceRange,
    "category": [ _value.id.toString()],
    "place_type": [ "1" ],
    "country_id": 1,
    "state_id": __value.state_id,
    "city_id":  __value.id,
    "address": address,
    "lat": latitude,
    "lng": longitude,
    "email": email,
    "phone_number": phone,
    "website": website,
    "social": [
        {
            "name": "Youtube",
            "url": youtube
        },
        {
            "name": "Facebook",
            "url": facebook
        }
    ],
    "opening_hour": [
        {
            "title": "Monday",
            "value": mondayDays
        },
        {
            "title": "Tuesday",
            "value": tuesdayDays
        },
        {
            "title": "Wednesday",
            "value": wednesdayDays
        },
        {
            "title": "Thursday",
            "value": thursdayDays
        },
        {
            "title": "Friday",
            "value": fridayDays
        },
        {
            "title": "Saturday",
            "value": saturdayDays
        },
        {
            "title": "Sunday",
            "value": sundayDays
        }
    ],
    // "gallery": [
    //     gallery, // Upload images async using the image uplaod endpoint to store on s3 and get the file key returned
    // ],
     "thumb": thumbData,
  //  "video": "http://asdada.asdas"}
});
    String _baseUrl = "https://nsta-hlp.com/api/app/places";
    var responseJson;
    Response response;
    Dio dio = new Dio();
    print(body);
    response = await dio
        .post(
      _baseUrl,
      data: body,
      options: Options(
          // followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          },
          headers: {
          //  "Content-Type": "application/json",
          //  "Connection": 'keep-alive',
            "Authorization": "Bearer " + AppState().token
          }),
    )
        .catchError((e) {
      setState(() {
        _loading = false;
      });
      print(e.response);
      var message = '';
     //   message = e.response.data.toString();
      homeScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
      ));
    });
    // setState(() {
    //   _loading = false;
    // });
 setState(() {
        _loading = false;
      });
    if (response.statusCode != 201) {
      print('sksksk');
      var message = '';
      print(response.statusCode);
        message = response.data.toString();
     homeScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
              //   fontWeight: FontWeight.w300,
            )),
        // duration: Duration(seconds: 3),
      ));
    }else{
       homeScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(name+' created sucessfully',
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            )),
      ));
    return Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => AddPlaceSuccess()),
                                            );
    

    }

  }

  void _onImageButtonPressed({BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      setState(() {
        _imageFile = pickedFile;
      });
      // var filename = pickedFile.path.split('/').last;
      // try {
      //   Response response;
      //   Dio dio = new Dio();
      //   FormData data = FormData.fromMap({
      //     "image": await MultipartFile.fromFile(
      //       pickedFile.path,
      //       filename:filename
      //     ),
      //   });
      //   response = await dio.post(
      //     "https://nsta-hlp.com/api/upload-image",
      //     data: data,
      //   );
      //   print(response.data.toString() + "dgdg");
      //   if (response.statusCode == 200) {
      //     setState(() {
      //       gallery = response.data['file_name'];
      //     });
      //   }
      // } on DioError catch (e) {
      //   print(e.response.data);
      //   print(e.response.headers);
      //   print(e.response.request);
      // }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      // if (kIsWeb) {
      //   // Why network?
      //   // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
      //   return Image.network(_imageFile.path);
      // } else {
      return Semantics(
          child: Image.file(File(_imageFile.path)), label: 'image1');
      // }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "us")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      print(p);
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      final address_ = detail.result.formattedAddress;
      return setState(() {
        latitude = lat;
        longitude = lng;
        address = address_;
      });
      // scaffold.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeScaffoldKey,
        body: LoadingOverlay(
          color: GoloColors.primary,
          child: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: new SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: sizer(false, 77, context),
                      left: sizer(true, 25, context),
                      right: sizer(true, 25, context)),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            BackButtonWhite(
                              onPressed: () {
                                return Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: sizer(false, 15, context)),
                        HeaderText(title: 'Add Place'),
                        SizedBox(
                          height: 8,
                        ),
                        SubText(
                            isCenter: false,
                            title: 'Fill in information to add place'),
                        SizedBox(height: sizer(false, 15, context)),
                        new Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: customForm(),
                        ),
                      ]),
                )))),   isLoading: _loading,));
  }

  Widget customForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Name',
              onChanged: (text) {
                setState(() {
                  name = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthEmailInput(
              hintText: 'Email',
              onChanged: (text) {
                setState(() {
                  email = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Description',
              onChanged: (text) {
                setState(() {
                  description = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
      child: AuthPhoneInput(
              hintText: 'Price',
              onChanged: (text) {
                setState(() {
                  priceRange = text;
                });
              }),
        ),
        // Container(
        //   margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
        //   child: AuthEmailInput(
        //       hintText: 'Email',
        //       onChanged: (text) {
        //         setState(() {
        //           email = text;
        //         });
        //       }),
        // ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthPhoneInput(
              hintText: 'Phone',
              onChanged: (text) {
                setState(() {
                  phone = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Website',
              onChanged: (text) {
                setState(() {
                  website = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthSelectInput(
              hintText: address != null ? address : 'Address',
              onPressed: () => _handlePressButton()),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthSelectInput(
              hintText: 'Upload Images',
              onPressed: () => _onImageButtonPressed()),
        ),
        defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _previewImage();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : (_previewImage()),
        Container(
            margin: EdgeInsets.only(bottom: sizer(false, 16, context),
            top:sizer(false,16,context)),
            child: new DropdownButton(
                 isExpanded: true,
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                          color: Color(0xff828A95),
                          fontSize: sizer(true, 16.0, context)),
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sizer(true, 16.0, context)),
                    value: _value,
                    items: AppState()
                        .categories
                        .map<DropdownMenuItem<PlaceCategory>>(
                            (PlaceCategory value) {
                      return DropdownMenuItem<PlaceCategory>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (PlaceCategory value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
            ),
              Container(
            margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
            child:  new DropdownButton(
              isExpanded: true,
                    hint: Text(
                      'Select City',
                      style: TextStyle(
                          color: Color(0xff828A95),
                          fontSize: sizer(true, 16.0, context)),
                    ),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: sizer(true, 16.0, context)),
                    value: __value,
                    items: AppState()
                        .cities
                        .map<DropdownMenuItem<City>>((City value) {
                      return DropdownMenuItem<City>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (City value) {
                      setState(() {
                        __value = value;
                      });
                    },
                
                )
            ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Monday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  mondayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Tuesday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  tuesdayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Wednesday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  wednesdayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Thursday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  thursdayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Friday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  fridayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Saturday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  saturdayDays = text;
                });
              }),
        ),
        Container(
          margin: EdgeInsets.only(bottom: sizer(false, 16, context)),
          child: AuthTextInput(
              hintText: 'Sunday Opening Hours(i.e 15:00-14:00)',
              onChanged: (text) {
                setState(() {
                  sundayDays = text;
                });
              }),
        ),
        ButtonBlue(onPressed: () {
          return preAddPlace();
        }, title: 'NEXT'),
        SizedBox(height: sizer(false, 32, context)),
      ],
    );
  }
}
