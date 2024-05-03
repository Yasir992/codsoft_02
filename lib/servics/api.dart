import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:quotes_motivational_app/model/quotes.dart';

class Api {
  static Future<Quotes?> getQuotes() async {
    Uri url = Uri.parse('http://api.quotable.io/random');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return Quotes.fromJson(jsonDecode(response.body));
    } else {
      Fluttertoast.showToast(
        msg: 'Error in geeting Quote! ',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.red,
        backgroundColor: Colors.cyan,
        fontSize: 16.0,
      );
    }
    return null;
  }
}
