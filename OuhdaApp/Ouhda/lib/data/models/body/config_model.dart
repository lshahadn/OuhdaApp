class ConfigModel {
  String? name;
  String? image;
  String? address;
  String? phone;
  String? email;
  
  DefaultLocation? defaultLocation;
  
  ConfigModel(
      {this.name,
        this.image,
        this.address,
        this.phone,
        this.email,
     
        this.defaultLocation,
       
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    name = json['business_name'];
    image = json['image'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];

    defaultLocation = json['default_location'] != null ? DefaultLocation.fromJson(json['default_location']) : null;
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.name;
    data['image'] = this.image;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
  
    if (this.defaultLocation != null) {
      data['default_location'] = this.defaultLocation!.toJson();
    }
  
    return data;
  }
}

class DefaultLocation {
  String? lat;
  String? lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
