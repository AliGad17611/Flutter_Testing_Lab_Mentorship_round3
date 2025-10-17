import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('Unit Tests - Temperature Conversion', () {
    test('celsiusToFahrenheit should return 32 when given 0°C', () {
      expect(WeatherDisplay.celsiusToFahrenheit(0), 32);
    });

    test('celsiusToFahrenheit should return 212 when given 100°C', () {
      expect(WeatherDisplay.celsiusToFahrenheit(100), 212);
    });

    test('celsiusToFahrenheit should return 72.5 when given 22.5°C', () {
      expect(WeatherDisplay.celsiusToFahrenheit(22.5), 72.5);
    });

    test('celsiusToFahrenheit should handle negative temperatures', () {
      expect(WeatherDisplay.celsiusToFahrenheit(-40), -40);
    });

    test('fahrenheitToCelsius should return 0 when given 32°F', () {
      expect(WeatherDisplay.fahrenheitToCelsius(32), 0);
    });

    test('fahrenheitToCelsius should return 100 when given 212°F', () {
      expect(WeatherDisplay.fahrenheitToCelsius(212), 100);
    });

    test(
      'fahrenheitToCelsius should return approximately 22.5 when given 72.5°F',
      () {
        expect(WeatherDisplay.fahrenheitToCelsius(72.5), closeTo(22.5, 0.1));
      },
    );

    test('fahrenheitToCelsius should handle negative temperatures', () {
      expect(WeatherDisplay.fahrenheitToCelsius(-40), -40);
    });
  });

  group('Unit Tests - WeatherData Model', () {
    test('fromJson should create WeatherData with all fields', () {
      final json = {
        'city': 'London',
        'temperature': 15.0,
        'description': 'Rainy',
        'humidity': 85,
        'windSpeed': 8.5,
        'icon': '🌧️',
      };

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'London');
      expect(weatherData.temperatureCelsius, 15.0);
      expect(weatherData.description, 'Rainy');
      expect(weatherData.humidity, 85);
      expect(weatherData.windSpeed, 8.5);
      expect(weatherData.icon, '🌧️');
    });

    test('fromJson should handle minimal required fields only', () {
      final json = {'city': 'Tokyo', 'temperature': 25.0};

      final weatherData = WeatherData.fromJson(json);

      expect(weatherData.city, 'Tokyo');
      expect(weatherData.temperatureCelsius, 25.0);
      expect(weatherData.description, 'Unknown');
      expect(weatherData.humidity, 0);
      expect(weatherData.windSpeed, 0.0);
      expect(weatherData.icon, '🌤️');
    });

    test('fromJson should throw ArgumentError when json is null', () {
      expect(() => WeatherData.fromJson(null), throwsA(isA<ArgumentError>()));
    });

    test('fromJson should throw ArgumentError when city is missing', () {
      final json = {'temperature': 20.0};

      expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
    });

    test('fromJson should throw ArgumentError when temperature is missing', () {
      final json = {'city': 'New York'};

      expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
    });

    test('fromJson should throw ArgumentError when city is empty', () {
      final json = {'city': '', 'temperature': 20.0};

      expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
    });

    test('fromJson should throw ArgumentError when city is not a string', () {
      final json = {'city': 123, 'temperature': 20.0};

      expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
    });

    test(
      'fromJson should throw ArgumentError when temperature is not a number',
      () {
        final json = {'city': 'Tokyo', 'temperature': 'twenty'};

        expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
      },
    );

    test('fromJson should handle integer temperature', () {
      final json = {'city': 'Tokyo', 'temperature': 25};

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.temperatureCelsius, 25.0);
    });

    test('fromJson should handle integer humidity', () {
      final json = {'city': 'Tokyo', 'temperature': 25.0, 'humidity': 70};

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.humidity, 70);
    });

    test('fromJson should handle double humidity', () {
      final json = {'city': 'Tokyo', 'temperature': 25.0, 'humidity': 70.5};

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.humidity, 70);
    });

    test(
      'fromJson should throw ArgumentError when humidity is not a number',
      () {
        final json = {'city': 'Tokyo', 'temperature': 25.0, 'humidity': 'high'};

        expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
      },
    );

    test(
      'fromJson should throw ArgumentError when windSpeed is not a number',
      () {
        final json = {
          'city': 'Tokyo',
          'temperature': 25.0,
          'windSpeed': 'fast',
        };

        expect(() => WeatherData.fromJson(json), throwsA(isA<ArgumentError>()));
      },
    );

    test('fromJson should convert non-string description to string', () {
      final json = {'city': 'Tokyo', 'temperature': 25.0, 'description': 123};

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.description, '123');
    });

    test('fromJson should convert non-string icon to string', () {
      final json = {'city': 'Tokyo', 'temperature': 25.0, 'icon': 123};

      final weatherData = WeatherData.fromJson(json);
      expect(weatherData.icon, '123');
    });
  });

  group('Widget Tests - UI Components', () {
    testWidgets('should display city dropdown with all cities', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();

      // Check if the City label and dropdown exist
      expect(find.text('City: '), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Wait for async operation to complete to avoid pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('should display Refresh button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();

      expect(find.widgetWithText(ElevatedButton, 'Refresh'), findsOneWidget);

      // Wait for async operation to complete to avoid pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('should display temperature unit toggle', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();

      expect(find.text('Temperature Unit:'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Celsius'), findsOneWidget);

      // Wait for async operation to complete to avoid pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('should show loading indicator initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Initial pump shows loading
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async operation to complete to avoid pending timer
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('should display weather data after loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async operation to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should no longer show loading
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Should show either weather data or error
      final hasWeatherCard = find.byType(Card).evaluate().isNotEmpty;
      expect(hasWeatherCard, isTrue);
    });

    testWidgets('should toggle between Celsius and Fahrenheit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Initially should show Celsius
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Fahrenheit'), findsOneWidget);

      // Toggle back to Celsius
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Celsius'), findsOneWidget);
    });

    testWidgets('should display temperature in Celsius by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for temperature display with °C symbol
      final tempFinder = find.textContaining('°C');

      // Should find at least one temperature in Celsius
      expect(tempFinder, findsWidgets);
    });

    testWidgets('should display temperature in Fahrenheit when toggled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Look for temperature display with °F symbol
      final tempFinder = find.textContaining('°F');

      // Should find at least one temperature in Fahrenheit
      expect(tempFinder, findsWidgets);
    });

    testWidgets('should display weather details (humidity and wind speed)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check for humidity and wind speed labels
      expect(find.text('Humidity'), findsWidgets);
      expect(find.text('Wind Speed'), findsWidgets);
    });

    testWidgets('should display weather icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Weather icons should be displayed (emoji characters)
      // We can check for common weather emojis
      final hasIcon =
          find.textContaining('☀️', findRichText: true).evaluate().isNotEmpty ||
          find
              .textContaining('🌧️', findRichText: true)
              .evaluate()
              .isNotEmpty ||
          find.textContaining('☁️', findRichText: true).evaluate().isNotEmpty ||
          find.textContaining('🌤️', findRichText: true).evaluate().isNotEmpty;

      expect(hasIcon, isTrue);
    });

    testWidgets('should reload weather when Refresh button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap refresh button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for reload
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show weather data again
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should change city when dropdown selection changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select a different city (London)
      await tester.tap(find.text('London').last);
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for reload
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show weather data again
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should display error when invalid city is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select "Invalid City"
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      // Wait for load attempt
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show error message
      expect(
        find.text('Failed to fetch weather data: No data received'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display error card with red color scheme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Select Invalid City to trigger error
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Check for error icon
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Verify the icon widget has red color
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(iconWidget.color, Colors.red);
    });

    testWidgets('should display city name in weather card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Default city is "New York"
      expect(find.text('New York'), findsWidgets);
    });

    testWidgets('should display weather description', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display one of the weather descriptions
      final hasSunny = find.text('Sunny').evaluate().isNotEmpty;
      final hasRainy = find.text('Rainy').evaluate().isNotEmpty;
      final hasCloudy = find.text('Cloudy').evaluate().isNotEmpty;

      expect(hasSunny || hasRainy || hasCloudy, isTrue);
    });

    testWidgets('should display humidity percentage', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for humidity value with % symbol
      expect(find.textContaining('%'), findsWidgets);
    });

    testWidgets('should display wind speed with unit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Look for wind speed value with km/h unit
      expect(find.textContaining('km/h'), findsWidgets);
    });

    testWidgets(
      'should display weather icons (Icons.water_drop and Icons.air)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: WeatherDisplay())),
        );

        await tester.pump();
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Check for humidity and wind speed icons
        expect(find.byIcon(Icons.water_drop), findsOneWidget);
        expect(find.byIcon(Icons.air), findsOneWidget);
      },
    );

    testWidgets('temperature conversion should be accurate in UI', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Get the Celsius temperature
      final celsiusText = find.textContaining('°C');
      expect(celsiusText, findsWidgets);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should now show Fahrenheit
      final fahrenheitText = find.textContaining('°F');
      expect(fahrenheitText, findsWidgets);
    });
  });

  group('Widget Tests - Integration', () {
    testWidgets('complete weather display flow for New York', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Initial state - loading
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for data to load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify weather data is displayed
      expect(find.text('New York'), findsWidgets);
      expect(find.text('Celsius'), findsOneWidget);

      // Toggle to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.text('Fahrenheit'), findsOneWidget);

      // Refresh weather
      await tester.tap(find.widgetWithText(ElevatedButton, 'Refresh'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('complete weather display flow for London', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to London
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('London').last);
      await tester.pump();

      // Wait for London data
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify London is displayed
      expect(find.text('London'), findsWidgets);
    });

    testWidgets('complete weather display flow for Tokyo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Tokyo
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pump();

      // Wait for Tokyo data
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify Tokyo is displayed
      expect(find.text('Tokyo'), findsWidgets);
    });

    testWidgets('error handling flow for Invalid City', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Change to Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      // Wait for error
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify error is displayed
      expect(
        find.text('Failed to fetch weather data: No data received'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Change back to valid city
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New York').last);
      await tester.pump();

      // Wait for valid data
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify error is gone and data is shown
      expect(find.byIcon(Icons.error_outline), findsNothing);
    });
  });
}
