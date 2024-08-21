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
  List<Sites>? sites;

  Cities({this.name, this.sites});

  Cities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['sites'] != null) {
      sites = <Sites>[];
      json['sites'].forEach((v) {
        sites!.add(new Sites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.sites != null) {
      data['sites'] = this.sites!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sites {
  String? siteName;
  String? siteCode;
  String? yourPrice;
  String? effectiveDate;
  String? createdAt;

  Sites(
      {this.siteName,
      this.siteCode,
      this.yourPrice,
      this.effectiveDate,
      this.createdAt});

  Sites.fromJson(Map<String, dynamic> json) {
    siteName = json['site_name'];
    siteCode = json['site_code'];
    yourPrice = json['your_price'];
    effectiveDate = json['effective_date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_name'] = this.siteName;
    data['site_code'] = this.siteCode;
    data['your_price'] = this.yourPrice;
    data['effective_date'] = this.effectiveDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}
