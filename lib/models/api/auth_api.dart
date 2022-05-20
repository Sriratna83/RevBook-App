// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:dio/dio.dart';
import 'package:revbook_app/models/http_exception.dart';

const String _apiKey = "AIzaSyB_ZGv8ml6vCADr5s4pNtm-xNuVqV34wFg";

Future<dynamic> _auth(String data, String urlSegment) async {
  try {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=${_apiKey}";
    final uri = Uri.parse(url);
    final response = await Dio().postUri(uri, data: data);
    return response;
  } on DioError catch (e) {
    String errorData = e.response!.data.toString();

    String message = "Unknown error.";

    if (errorData.contains("CREDENTIAL_TOO_OLD_LOGIN_AGAIN")) {
      message = "credential too old login again.";
    } else if (errorData.contains("TOKEN_EXPIRED")) {
      message = "token expired.";
    } else if (errorData.contains("INVALID_REFRESH_TOKEN")) {
      message = "invalid refresh token.";
    } else if (errorData.contains("EMAIL_EXISTS")) {
      message = "The email address is already in use by another account.";
    } else if (errorData.contains("EMAIL_NOT_FOUND")) {
      message =
          "There is no user record corresponding to this identifier. The user may have been deleted.";
    } else if (errorData.contains("INVALID_PASSWORD")) {
      message = "The password is invalid or the user does not have a password.";
    } else if (errorData.contains("INVALID_EMAIL")) {
      message = "The email address is badly formatted.";
    }

    throw HttpException(message: message);
  } catch (e) {
    rethrow;
  }
}

Future<dynamic> signUp(String data) async {
  return _auth(data, "signUp");
}

Future<dynamic> signIn(String data) async {
  return _auth(data, "signInWithPassword");
}
