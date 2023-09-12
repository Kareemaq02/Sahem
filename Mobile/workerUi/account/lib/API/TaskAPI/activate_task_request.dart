import 'package:account/API/login_request.dart';
import 'package:http/http.dart' as http;

class TaskActivation {
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
