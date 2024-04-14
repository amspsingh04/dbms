// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

void fetchData() async {
  var url = Uri.parse('https://45bd-115-240-194-54.ngrok-free.app/');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    print('Response data: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
