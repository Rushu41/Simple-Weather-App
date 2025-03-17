import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  static const String apiKey = "ba1e7915b04db5ad2e688edffe74ca8c"; //API key

  Future<Weather?> getWeather(String cityName) async {
    try {
      final Uri url = Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
      print("Fetching weather from: $url"); // Debugging

      final response = await http.get(url);

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception("City not found. Please try again.");
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }

  Future<String?> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception("Location permission denied");
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemark.isNotEmpty) {
        return placemark[0].locality;
      } else {
        throw Exception("Failed to get city name");
      }
    } catch (e) {
      print("Error fetching location: $e");
      return null;
    }
  }
}
