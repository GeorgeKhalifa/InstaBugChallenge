import 'dart:convert';
import 'package:http/http.dart' as http;
 
 class MovieData {
      List<dynamic> movies;
      int statusCode;
      String errorMessage;
      int total;
      int nItems;

      MovieData.fromResponse(http.Response response) {
        this.statusCode = response.statusCode;
        final jsonData = json.decode(response.body);
        movies = jsonData['results'];
        total = jsonData['total_pages'];
        nItems = 10000;




      }
      MovieData.withError(String errorMessage) {
        this.errorMessage = errorMessage;
      }
    }