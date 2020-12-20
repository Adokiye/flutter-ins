import 'package:Instahelp/components/emptyData.dart';
import 'package:Instahelp/modules/setting/colors.dart';
import 'package:Instahelp/src/providers/request_services/Api+auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Instahelp/components/headerText.dart';
import 'package:Instahelp/components/subText.dart';
import 'package:Instahelp/helpers/sizeCalculator.dart';
import 'package:Instahelp/components/plusButton.dart';
import 'package:Instahelp/components/backButtonWhite.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:intl/intl.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class Subscription extends StatefulWidget {
  Subscription({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentMethod _paymentMethod;
  bool _loading = false;
  bool _loadingBig =false;
  String _error;
  var dataJson;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
        print('ddkdfdgdgdkd');

    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51GwZ2qGH4DIiGLsSch3FLpZiT0vCn0eXUDEOB9MawVeUrf0bzdAduVD0O31NtTU8f1xd4xY0UNHjUZhD9kPoFITg00l67dFYSf",
        //  merchantId: "Test",
        androidPayMode: 'test'));
        print('ddkdkd');
     getPlans();
  }

Future getPlans() async{
   await ApiAuth.getPlans().then((response) {
      print(response);
      setState((){
        dataJson = response;
        _loading = false;
      });
      
    });
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _loading = false;
      _error = error.toString();
    });
  }

  Future<dynamic> addCard(String subscribeId) async {
    setState(() {
      _loadingBig = true;
    });
    print(subscribeId);
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) async{
         
       Map<String, dynamic> body = {
      'payment_method': paymentMethod.id,
    };
    Map<String, dynamic> subscribeBody = {
      'id': subscribeId,
    };
    print(body);
    await ApiAuth.addCard(body).then((response) async{
      print('addaca');
      print(response);  
       _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Card added successfully')));
      // _scaffoldKey.currentState
      //   .showSnackBar(SnackBar(content: Text(response['message'])));
     
      await ApiAuth.subscribe(subscribeBody).then((response) {
         setState(() {
        _loadingBig = false;
      });
       _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(response['message'])));
        print(response);
        return getPlans();
      });
    });
    }).catchError((error){
        setState(() {
        _loadingBig = false;
      });
      return setError(error);});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: LoadingOverlay(
          color: GoloColors.primary,
          child:SafeArea(
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
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: sizer(false, 15, context)),
                          HeaderText(title: 'Billing Details'),
                          SizedBox(height: 28),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Subscriptions',
                                style: TextStyle(
                                    color: Color(0xff8E919C),
                                    fontSize: sizer(true, 20, context)),
                              ),
                              // PlusButton(onPressed: () {
                              //   return addCard();
                              //   //                             Navigator.of(context).push(
                              //   //   MaterialPageRoute(builder: (_) => AddCard(title: ''))
                              //   // );
                              // }),
                            ],
                          ),
                          SizedBox(height: 5),
                      _loading ?Center(
                        child:  CircularProgressIndicator(backgroundColor: GoloColors.primary,
                    )
                      ) : Column(
                         children: <Widget>[
dataJson != null &&
                                  dataJson['subscriptions'].length > 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: dataJson['subscriptions'].length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return card(
                                        dataJson['subscriptions'][index]['name'], '');
                                  })
                              : EmptyData(
                                  title:
                                      'You have no subscriptions, subscribe below',
                                  isButton: false,
                                ),
                          dataJson != null && dataJson['subscriptions'].length <= 0 &&
                                      dataJson['plans'].length > 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: dataJson['plans'].length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return Material(
                                        color: Color(0xffF3F4F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: InkWell(
                                            onTap: () => addCard(
                                                dataJson['plans'][index]['id']),
                                            child: card(
                                                dataJson['plans'][index]['product'].substring(0,8),
                                                '\$'+oCcy.format(dataJson['plans'][index]['unit_amount']))));
                                  })
                              : Container()
                         ],
                       )   
                        ]),
                  ))) ),   isLoading: _loadingBig,));
  }

  Widget card(String type, String lastDigits) {
    return Container(
      margin: EdgeInsets.only(bottom: sizer(false, 10, context)),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GoloColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: GoloColors.secondary3,
            spreadRadius: 3,
            //   blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         
          Text(type,
              style: TextStyle(
                  color: Colors.white, fontSize: sizer(true, 20, context))),
          SizedBox(width: 6),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
          ),
          SizedBox(width: 6),
          Text(lastDigits,
              style: TextStyle(
                  color: Colors.white, fontSize: sizer(true, 20, context))),
          Spacer(),
          Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                // side: BorderSide(color: Colors.red)
              ),
              color: GoloColors.secondary1,
              child: InkWell(
                  onTap: () {},
                  child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: GoloColors.secondary1,

                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.white,
                      ))))
        ],
      ),
    );
  }
}
