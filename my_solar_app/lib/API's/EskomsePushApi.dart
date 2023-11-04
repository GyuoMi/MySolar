import 'package:http/http.dart' as http;
import 'dart:convert';

class EskomSePushApiService {
  final String baseUrl = 'https://developer.sepush.co.za/business/2.0';
  Future<Map<String, dynamic>> getAreaInfoBySearchText(String searchText) async {
  try {
    print(searchText);
    final areas = await searchAreasByText(searchText);
    print(4);  
      if (areas.isNotEmpty) {
      // Use the ID of the first area in the search results
      String areaId = areas.first['id'];
      
      // Fetch area information using the obtained areaId and set test parameter to 'current'
      return await getAreaInformation(areaId, 'current');
    } else {
      throw Exception('No areas found for the given search text');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

  Future<Map<String, dynamic>> getAreaInformation(String areaId, String test) async {
    String url = '$baseUrl/area?id=$areaId&test=$test';
    print(url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'token': '3E9C48D4-9B194FBB-9D41738D-A69DADE3', // Replace 'YOUR_LICENSE_KEY' with your actual license key
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load area information');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
    Future<List<Map<String, dynamic>>> searchAreasByText(String searchText) async {
     
    String url = '$baseUrl/areas_search?text=$searchText';
     print (url);
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'token': '3E9C48D4-9B194FBB-9D41738D-A69DADE3', // Replace 'YOUR_API_KEY' with your actual API key
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<Map<String, dynamic>> areas = responseData['areas'].cast<Map<String, dynamic>>();
        return areas;
      } else {
        throw Exception('Failed to search areas');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}