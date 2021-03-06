

import '../../modules/services/platform/Platform.dart';
import '../../modules/services/platform/lara/lara.dart';
import 'Base.dart';
import 'Place.dart';

class City extends Base{
  int count;
  String name;
  String description;
  // Get from other request
  String featuredImage; // media?slug=$slug
  String country;
  String intro;
  double lat;
  double lng;
  String address;
  String visitTime;
  String currency;
  String language;
  int status;
  int id;
  int state_id;

  City(Map<String, dynamic> json) : super(json){
    print(json);
    print('json');
    count = json["translations"].length;
    name = json["name"];
    description = json["description"];
    country = json["country"] != null ? json["country"]["name"] : "";
    intro = json["intro"];
    lat = json["lat"];
    lng = json["lng"];
    featuredImage = "${Lara.baseUrlImage}${json["thumb"] ?? ""}";
    status = json["status"];
    visitTime = json["best_time_to_visit"];
    currency = json["currency"];
    language = json["language"];
    id = json['id'];
    state_id = json['state_id'];
  }
  
  factory City.fromJson(Map<String, dynamic> json) {
    return City(json);
  }

}