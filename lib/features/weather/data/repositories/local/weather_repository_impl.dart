import 'dart:math';

import 'package:weather_app/features/weather/data/models/weather.dart';
import 'package:weather_app/features/weather/domain/repositories/local/weather_repository.dart';

class FakeWeatherRepository implements WeatherRepository {
  late double cachedTempCelsius;

  @override
  Future<Weather> fetchDetailedWeather(String cityName) {
    return Future.delayed(const Duration(seconds: 0), () {
      return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
          temperatureFahrenheit: cachedTempCelsius * 1.8 + 32);
    });
  }

  @override
  Future<Weather> fetchWeather(String cityName) {
    // Simulate network delay
    return Future.delayed(const Duration(seconds: 1), () {
      final random = Random();

      // Simulate some network error
      if (random.nextBool()) {
        throw NetworkError();
      }

      // Since we're inside a fake repository, we need to cache the temperature
      // in order to have the same one returned for the detailed weather
      cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

      // Return 'fetched' weather
      return Weather(
        cityName: cityName,
        temperatureCelsius: cachedTempCelsius,
      );
    });
  }
}

class NetworkError extends Error {}
