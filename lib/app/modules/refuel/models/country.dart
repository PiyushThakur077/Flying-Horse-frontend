class Province {
  int? id;
  String? name;
  String? iso2;
  String? countryCode;
  List<Cities>? cities;

  Province({this.id, this.name, this.iso2, this.countryCode, this.cities});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso2 = json['iso2'];
    countryCode = json['country_code'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso2'] = this.iso2;
    data['country_code'] = this.countryCode;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? name;
  List<String>? siteNames;
  List<String>? siteCodes;

  Cities({this.name, this.siteNames, this.siteCodes});

  Cities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    siteNames = json['site_names'].cast<String>();
    siteCodes = json['site_codes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['site_names'] = this.siteNames;
    data['site_codes'] = this.siteCodes;
    return data;
  }
}