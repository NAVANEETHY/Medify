import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static const String elasticApiKey =
      '952EDB3D63653CCAE6A337C12E0DE6EE8105C10CD04B35917A78B152DC245024BC5D2C4320E17AE66C61C8F87F21C8EE';
  static Future<bool> sendEmail(
      String fromEmail, String toEmail, String subject, String body) async {
    final Uri uri = Uri.parse('https://api.elasticemail.com/v2/email/send');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final Map<String, String> bodyData = {
      'apikey': elasticApiKey,
      'from': fromEmail,
      'to': toEmail,
      'subject': subject,
      'bodyHtml': body,
    };
    final http.Response response =
        await http.post(uri, headers: headers, body: bodyData);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
