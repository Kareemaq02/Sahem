import 'package:account/Repository/urls.dart';
import 'package:account/main.dart';
import 'package:http/http.dart' as http;

class CreateTaskRequest {
  final userToken = prefs!.getString('token');
  Future<int> insertTask(
    String decCost,
    DateTime scheduledDate,
    DateTime deadlineDate,
    int intTeamId,
    int intTaskType,
    String strComment,
    List<int> lstComplaintIds,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppUrl.baseURL}tasks"),
      );

      request.headers.addAll({"Authorization": "Bearer $userToken"});
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['decCost'] = decCost.toString();
      request.fields['scheduledDate'] = scheduledDate.toString();
      request.fields['deadlineDate'] = deadlineDate.toString();
      request.fields['intTeamId'] = intTeamId.toString();
      request.fields['intTaskType'] = intTaskType.toString();
      request.fields['strComment'] = strComment;

      for (var index = 0; index < lstComplaintIds.length; index++) {
        var complaintId = lstComplaintIds[index];
        request.fields['lstComplaintIds[$index]'] = complaintId.toString();
      }
      final response = await request.send();
      return response.statusCode;
    } catch (e) {
      return 400;
    }
  }
}
