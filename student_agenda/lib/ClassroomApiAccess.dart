import 'package:student_agenda/auth.dart';

final Future<Map<String, String>> _authHeaders = authService.getAuthHeaders();

class ClassroomApiAccess{
  ClassroomApiAccess _instance;
  GoogleHttpClient _httpClient;

  ClassroomApiAccess._();

  ClassroomApiAccess getInstance(){
    if(_instance == null){
      _setUpHttpClient();
      return ClassroomApiAccess._();
    }
    return _instance;
  }
  



  _setUpHttpClient() async {
    _httpClient = new GoogleHttpClient(await _authHeaders);
  }
}
