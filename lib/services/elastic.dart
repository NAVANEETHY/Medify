import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static String elasticApiKey = dotenv.env['MAIL_KEY']!;
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
