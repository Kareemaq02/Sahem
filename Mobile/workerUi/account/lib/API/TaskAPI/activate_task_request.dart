import 'package:account/main.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: empty_catches


class TaskActivation {
    final userToken = prefs!.getString('token');
  void activateTask(intTaskId) async {
    final url =
        Uri.parse("https://10.0.2.2:5000/api/tasks/activate/$intTaskId");

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken'
        },

        // body: json.encode({'key': 'value'}),
      );

      if (response.statusCode == 200) {
      } else {
      }
    } catch (error) {
    }
  }
}
