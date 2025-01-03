import 'dart:convert';
import 'package:http/http.dart' as http;

class Reportservice {
  Future<dynamic> getMarbleReport({
    required String fromDate,
    required String toDate,
    required List family,
    required List application,
    required List finish,
  }) async {
    final String url = 'https://crm.quarry.asia/api/marblereport';

    final Map<String, dynamic> body = {
      'fromdate': fromDate,
      'todate': toDate,
      'family': family,
      'application': application,
      'finish': finish,
    };
    print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
  
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        print(data);
        // if (data['status'] == "success") {
        //   return data['data'];
        // } else {
        //   throw Exception('Failed to retrieve report: ${data['message']}');
        // }
        return data;
      } else {
        throw Exception('Failed to retrieve report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to retrieve report: $e');
    }
  }
}
