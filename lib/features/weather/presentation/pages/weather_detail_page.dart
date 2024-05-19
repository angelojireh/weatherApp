import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/data/models/weather.dart';
import 'package:weather_app/features/weather/presentation/bloc/weather_bloc.dart';

class WeatherDetailPage extends StatefulWidget {
  final Weather argument;

  const WeatherDetailPage({
    super.key,
    required this.argument,
  });

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  // didChangeDependencies runs before build
  // and most importantly, doesn't run on rebuilds
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<WeatherBloc>(context).add(
      GetDeatailedWeather(widget.argument.cityName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Detail'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(context, state.weather);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the Celsius temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        Text(
          // Display the Fahrenheit temperature with 1 decimal place
          "${weather.temperatureFahrenheit?.toStringAsFixed(1)} °F",
          style: const TextStyle(fontSize: 80),
        ),
      ],
    );
  }
}
