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
  String? prod;
  String? fedralTax;
  String? stateTax;
  String? cost;
  String? freight;
  String? other;
  String? basePrice;
  String? fet;
  String? pft;
  String? pct;
  String? local;
  String? fuelPrice;
  String? salesTax;
  String? intaxPrice;
  String? qst;
  String? totalCost;
  String? retailPrice;
  String? savings;

  Sites(
      {this.siteName,
      this.siteCode,
      this.yourPrice,
      this.effectiveDate,
      this.createdAt,
      this.prod,
      this.fedralTax,
      this.stateTax,
      this.cost,
      this.freight,
      this.other,
      this.basePrice,
      this.fet,
      this.pft,
      this.pct,
      this.local,
      this.fuelPrice,
      this.salesTax,
      this.intaxPrice,
      this.qst,
      this.totalCost,
      this.retailPrice,
      this.savings});

  Sites.fromJson(Map<String, dynamic> json) {
    siteName = json['site_name'];
    siteCode = json['site_code'];
    yourPrice = json['your_price'];
    effectiveDate = json['effective_date'];
    createdAt = json['created_at'];
    prod = json['prod'];
    fedralTax = json['fedral_tax'];
    stateTax = json['state_tax'];
    cost = json['cost'];
    freight = json['freight'];
    other = json['other'];
    basePrice = json['base_price'];
    fet = json['fet'];
    pft = json['pft'];
    pct = json['pct'];
    local = json['local'];
    fuelPrice = json['fuel_price'];
    salesTax = json['sales_tax'];
    intaxPrice = json['intax_price'];
    qst = json['qst'];
    totalCost = json['total_cost'];
    retailPrice = json['retail_price'];
    savings = json['savings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['site_name'] = this.siteName;
    data['site_code'] = this.siteCode;
    data['your_price'] = this.yourPrice;
    data['effective_date'] = this.effectiveDate;
    data['created_at'] = this.createdAt;
    data['prod'] = this.prod;
    data['fedral_tax'] = this.fedralTax;
    data['state_tax'] = this.stateTax;
    data['cost'] = this.cost;
    data['freight'] = this.freight;
    data['other'] = this.other;
    data['base_price'] = this.basePrice;
    data['fet'] = this.fet;
    data['pft'] = this.pft;
    data['pct'] = this.pct;
    data['local'] = this.local;
    data['fuel_price'] = this.fuelPrice;
    data['sales_tax'] = this.salesTax;
    data['intax_price'] = this.intaxPrice;
    data['qst'] = this.qst;
    data['total_cost'] = this.totalCost;
    data['retail_price'] = this.retailPrice;
    data['savings'] = this.savings;
    return data;
  }
}


