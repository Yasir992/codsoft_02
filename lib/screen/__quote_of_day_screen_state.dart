// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:quotes_motivational_app/model/quotes.dart';
import 'package:quotes_motivational_app/screen/home_screen.dart';
import 'package:quotes_motivational_app/servics/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteOfDayScreenState extends State<QuoteOfDayScreen> {
  late String _quote = 'Loading...';
  late String _author = 'Unknown';

  @override
  void initState() {
    _fetchQuoteOfTheDay();
    super.initState();
  }

  Future<void> _fetchQuoteOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (isFirstLaunch) {
      Quotes? quote = await Api.getQuotes();
      if (quote != null) {
        setState(() {
          _quote = quote.content;
          _author = quote.author;
        });

        // store  quote and time
        prefs.setString('quote', _quote);
        prefs.setString('author', _author);
        prefs.setBool('firstLaunch', false);
        prefs.setString('lastFetched', DateTime.now().toString());
      }
    } else {
      DateTime lastFetched =
          DateTime.tryParse(prefs.getString('lastFetched') ?? '') ??
              DateTime.now();

      //  24 hours have passed since last fetch
      if (DateTime.now().difference(lastFetched).inHours >= 24) {
        // new quote from API
        Quotes? quote = await Api.getQuotes();
        if (quote != null) {
          setState(() {
            _quote = quote.content;
            _author = quote.author;
          });

          // Store  quote and time
          prefs.setString('quote', _quote);
          prefs.setString('author', _author);
          prefs.setString('lastFetched', DateTime.now().toString());
        }
      } else {
        setState(() {
          _quote = prefs.getString('quote') ?? 'No quote available';
          _author = prefs.getString('author') ?? 'Unknown';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        // backgroundColor: Colors.cyan.shade100,
        title: Text(
          "Quote of the Day",
          style: TextStyle(fontSize: 35, color: Colors.grey.shade700),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.cyan.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _quote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              Text(
                '- $_author',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
