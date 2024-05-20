import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/features/weather/data/models/weather.dart';
import 'package:weather_app/features/weather/data/repositories/local/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/local/weather_repository.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  MockWeatherRepository mockWeatherRepository;

  group('GetWeather', () {
    const weather = Weather(cityName: 'New York', temperatureCelsius: 8.5);
    mockWeatherRepository = MockWeatherRepository();

    blocTest(
      'emits [WeatherLoading, WeatherLoaded] when successful',
      build: () {
        when(mockWeatherRepository.fetchWeather('London'))
            .thenAnswer((_) async => weather);
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(const GetWeather('London')),
      expect: () => const [
        WeatherInitial(),
        WeatherLoading(),
        WeatherLoaded(weather),
      ],
    );

    blocTest(
      'emits [WeatherLoading, WeatherError] when unsuccessful',
      build: () {
        when(mockWeatherRepository.fetchWeather('London'))
            .thenThrow(NetworkError());
        return WeatherBloc(mockWeatherRepository);
      },
      act: (bloc) => bloc.add(GetWeather('London')),
      expect: () => const [
        WeatherInitial(),
        WeatherLoading(),
        WeatherError("Couldn't fetch weather. Is the device online?"),
      ],
    );
  });
}
