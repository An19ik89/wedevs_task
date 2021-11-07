import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:wedevs_flutter_task/data/model/updated_user_response.dart';



class ProfileApiClient{

  Future<UpdatedUserResponse?> updateProfile ({String? email,String? displayName,String? niceName,String? firstName, String? lastName, String? token}) async
  {

    var url = Uri.parse('https://apptest.dokandemo.com/wp-json/wp/v2/users/me');
    String token1 = token!.replaceFirst(RegExp('"'), '');
    String token2 = token1.replaceFirst(RegExp('"'), '');
    String headerText = "Bearer " + token2;
    try {

      Map data = {
        "name": displayName,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "nickname": niceName,
      };
      var body = json.encode(data);

      var response = await http.post(url,
        headers: {"Content-Type": "application/json",HttpHeaders.authorizationHeader: headerText},
        body: body
      );
      if (response.statusCode == 200)
      {
        final responseJson = json.decode(response.body);
        UpdatedUserResponse userModel = UpdatedUserResponse.fromJson(responseJson);
        return userModel;
      }
      else
      {
        final responseJson = json.decode(response.body);
        String error = responseJson['message'];
        Get.defaultDialog(title: "Oops!", middleText: _parseHtmlString(error));
      }
    } catch (e) {
      e.printError();
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}