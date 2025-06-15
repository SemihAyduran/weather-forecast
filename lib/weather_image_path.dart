String getWeatherImagePath(String weatherStatus) {
  switch (weatherStatus) {
    case "Clouds":
      return "clouds.jfif";
    case "Clear":
      return "sunny.jfif";
    case "Atmosphere":
      return "atmosphere.jfif";
    case "Snow":
      return "snow.jfif";
    case "Rain":
      return "rain.jfif";
    case "Drizzle":
      return "drizzle.jfif";
    case "Thunderstorm":
      return "flash.jfif";
  }
  return "home.jfif";
}