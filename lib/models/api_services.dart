import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  Future<String> getResponse(String query, String API) async {
    final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/recipe?query=$query'),
        headers: {'X-Api-Key': '$API'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    } else {
      return 'Failed to load data!';
    }
  }
}
