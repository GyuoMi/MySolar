import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GoogleMapsGeocoding {
  final String apiKey; // Your Google Maps Geocoding API key

  GoogleMapsGeocoding(this.apiKey);

  Future<Map<String, dynamic>> getLocationInfo(String address) async {
    final String apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json';

    final response = await http.get(
      Uri.parse('$apiUrl?address=$address&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];
        final location = result['geometry']['location'];
        final addressComponents = result['address_components'];

        final double latitude = location['lat'];
        final double longitude = location['lng'];
        String province = '';
        String country = '';
        String city = '';
        String street = '';
        String postalCode = '';

        for (final component in addressComponents) {
          final types = component['types'] as List<String>;

          if (types.contains('administrative_area_level_1')) {
            province = component['long_name'];
          } else if (types.contains('country')) {
            country = component['long_name'];
          } else if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('route')) {
            street = component['long_name'];
          } else if (types.contains('postal_code')) {
            postalCode = component['long_name'];
          }
        }

        final Map<String, dynamic> locationInfo = {
          'Latitude': latitude,
          'Longitude': longitude,
          'Province': province,
          'Country': country,
          'City': city,
          'Street': street,
          'PostalCode': postalCode,
        };

        return locationInfo;
      } else {
        throw Exception('No location data found for the provided address.');
      }
    } else {
      throw Exception('Failed to fetch location data');
    }
  }
}
