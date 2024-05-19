import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/features/weather/data/repositories/local/weather_repository_impl.dart';
import 'package:weather_app/features/weather/domain/repositories/local/weather_repository.dart';

import '../../data/models/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      emit(const WeatherLoading());

      if (event is GetWeather) {
        try {
          final weather = await repository.fetchWeather(event.cityName);
          emit(WeatherLoaded(weather));
        } on NetworkError {
          emit(
            const WeatherError(
              'Could not fetch weather. Make sure device is online.',
            ),
          );
        }
      } else if (event is GetDeatailedWeather) {
        // Code duplication ? to keep the code simple for the tutorial...
        try {
          final weather = await repository.fetchDetailedWeather(event.cityName);
          emit(WeatherLoaded(weather));
        } on NetworkError {
          emit(
            const WeatherError(
              'Could not fetch weather. Make sure device is online.',
            ),
          );
        }
      }
    });
  }
}
