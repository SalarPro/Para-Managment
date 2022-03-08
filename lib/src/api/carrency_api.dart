import 'dart:convert';

import 'package:http/http.dart' as http;

class Currency {
  Future<double?> oneUSDToIQD() async {
    try {
      var apiKey =
          'ENTER_YOUR_API_KEY_HERE'; //GET YOUR KEY https://freecurrencyapi.net/
      String theUrl =
          "https://freecurrencyapi.net/api/v2/latest?apikey=$apiKey";

      http.Response response = await http.get(Uri.parse(theUrl));

      // decode the json body to a list<dynamic>

      if (jsonDecode(response.body)["data"]["IQD"] is double)
        return jsonDecode(response.body)["data"]["IQD"] as double;
      else
        return null;
    } catch (e) {
      return 1450.0;
    }
  }
}
