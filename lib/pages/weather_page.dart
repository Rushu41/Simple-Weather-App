import 'package:flutter/material.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _cityController = TextEditingController();
  String? _cityName;

  _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_cityName != null && _cityName!.isNotEmpty) {
      Weather? weather = await _weatherService.getWeather(_cityName!);
      setState(() {
        if (weather != null) {
          _weather = weather;
        } else {
          _errorMessage = "Failed to load weather";
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter a city name";
      });
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            hintText: 'Enter City Name',
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            setState(() {
                              _cityName = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchWeather,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 40,
                            ),
                          ),
                          child: const Text(
                            'Get Weather',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : _errorMessage != null
                      ? Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                      : _weather != null
                      ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          "http://openweathermap.org/img/wn/${_weather!.iconCode}@2x.png",
                          width: 100,
                        ),
                        Text(
                          '${_weather!.temperature.round()}°C',
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _weather!.mainCondition,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Humidity: ${_weather!.humidity}%',
                          style: const TextStyle(fontSize: 20, color: Colors.white70),
                        ),
                        Text(
                          'Wind Speed: ${_weather!.windSpeed} m/s',
                          style: const TextStyle(fontSize: 20, color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
