class City {
  final String name;
  final String code;

  City({required this.name, required this.code});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['site_names'].first,
      code: json['site_codes'].first,
    );
  }
}

class Province {
  final String name;
  final String iso2;
  final List<City> cities;

  Province({required this.name, required this.iso2, required this.cities});

  factory Province.fromJson(Map<String, dynamic> json) {
    var cityList = <City>[];
    json['cities'].forEach((key, value) {
      cityList.add(City.fromJson(value));
    });

    return Province(
      name: json['name'],
      iso2: json['iso2'],
      cities: cityList,
    );
  }
}

class Country {
  final String name;
  final String iso2;
  final List<Province> provinces;

  Country({required this.name, required this.iso2, required this.provinces});

  factory Country.fromJson(Map<String, dynamic> json) {
    var provinceList = <Province>[];
    json['provinces'].forEach((item) {
      provinceList.add(Province.fromJson(item));
    });

    return Country(
      name: json['name'],
      iso2: json['iso2'],
      provinces: provinceList,
    );
  }
}
