import 'package:http/http.dart' as http;
import 'package:account/API/login_request.dart';

class ComapalintReminder {
  void comaplintReminder(intTaskId) async {
    final url =
        Uri.parse("https://10.0.2.2:5000/api/complaints/reminder/$intTaskId");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token2'
        },

        // body: json.encode({'key': 'value'}),
      );
      print(response.body);

      if (response.statusCode == 200) {
        print('Task activated successfully.');
      } else {
        print('Failed to activate task. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
