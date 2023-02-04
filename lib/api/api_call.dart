import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/screen/not_found.dart';
import 'package:http/http.dart' as http;

class IPinfo {
  final String ip;
  final String continent;
  final String country;
  final String region;
  final String city;
  final double latitude;
  final double longitude;
  final String flag;

  IPinfo(
      {required this.ip,
      required this.continent,
      required this.country,
      required this.region,
      required this.city,
      required this.latitude,
      required this.longitude,
      required this.flag});
  factory IPinfo.fromJson(Map<String, dynamic> json) {
    return IPinfo(
        ip: json['ip'],
        continent: json['continent'],
        country: json['country'],
        region: json['region'],
        city: json['city'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        flag: json['flag']['img']);
  }
}

parseDetails(String responseBody) {
  final parsed = IPinfo.fromJson(json.decode(responseBody));
  return parsed;
}

fetchDetails(ip, context) async {
  final response = await http.get(Uri.parse('https://ipwho.is/$ip'));

  if (response.statusCode == 200) {
    Navigator.pop(context);
    return parseDetails(response.body);
  } else {
    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NotFoundScreen()));
  }
}
