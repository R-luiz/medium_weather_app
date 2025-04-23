class WeatherData {
  final double temperature;
  final String description;
  final String icon;
  final String cityName;
  final int humidity;
  final double windSpeed;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.cityName,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      cityName: json['name'] as String,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
    );
  }
}
