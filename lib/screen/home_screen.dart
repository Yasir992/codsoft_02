// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:quotes_motivational_app/model/quotes.dart';
import 'package:quotes_motivational_app/servics/api.dart';
import 'package:share_plus/share_plus.dart';

import '__quote_of_day_screen_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Quotes? data;

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

void _shareQuote(BuildContext context) {
  final RenderBox box = context.findRenderObject() as RenderBox;
  Share.share('${data?.content ?? ""} - ${data?.author ?? ""}',
      subject: "Check out this quote!",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

class _HomeScreenState extends State<HomeScreen> {
  var size;
  var height;
  var width;
  Quotes? data;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: const ui.Color.fromARGB(255, 234, 232, 212),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        centerTitle: true,
        title: const Text(
          " Motivational Quotes",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_outlined,
            ),
            iconSize: 30,
            onPressed: () {
              getQuotes();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        //  backgroundColor: Colors.grey,
        onRefresh: getQuotes,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                "Pull down to Refresh",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 80),

            ///here main view of  quote
            MainViewForQuotes(width: width, data: data)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade600,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 5), // Add spacing between icon and text
                    Text(
                      'Share',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                color: Colors.black,
                onPressed: () {
                  _shareQuote(context);
                },
              ),
              IconButton(
                icon: const Row(
                  children: [
                    Icon(Icons.today),
                    SizedBox(width: 5), // Add spacing between icon and text
                    Text(
                      'Quote of the Day',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QuoteOfDayScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> getQuotes() async {
    data = await Api.getQuotes();
    setState(() {});
  }
}

class MainViewForQuotes extends StatelessWidget {
  const MainViewForQuotes({
    super.key,
    required this.width,
    required this.data,
  });

  final width;
  final Quotes? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      width: width / 2,
      child: Card(
        margin: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.cyan.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data?.content ?? "Don't talk about what you have done or what you are going to do."}',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 22),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    data?.author ?? "Thomas Jefferson",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

///
///
class QuoteOfDayScreen extends StatefulWidget {
  const QuoteOfDayScreen({super.key});

  @override
  QuoteOfDayScreenState createState() => QuoteOfDayScreenState();
}
