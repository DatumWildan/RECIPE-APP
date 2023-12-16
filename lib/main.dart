import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recepi_app/model.dart';
import 'package:webview_flutter/webview_flutter.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Model> list = <Model>[];
  String? text;
  final url =
      'https://api.edamam.com/search?q=chicken&app_id=500beffb&app_key=6d0a7d16d6538143109b038910691992&from=0&to=100&calories=591-722&health=alcohol-free';
  getApiData() async {
    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      Model model = Model(
          url: e['recipe']['url'],
          image: e['recipe']['image'],
          source: e['recipe']['source'],
          label: e['recipe']['label']);
      setState(() {
        list.add(model);
      });
    });

    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Recipe"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (v) {
                  text = v;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage(
                                      search: text,
                                    )));
                      },
                      icon: Icon(Icons.search),
                    ),
                    hintText: "Search for Recipe",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Colors.green.withOpacity(0.04),
                    filled: true),
              ),
              SizedBox(
                height: 15,
              ),
              GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPage(
                                      url: x.url,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(x.image.toString()))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.black.withOpacity(0.5),
                              child: Center(child: Text(x.label.toString())),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                  child:
                                      Text("Source : " + x.source.toString())),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class WebPage extends StatelessWidget {
  final url;
  WebPage({this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: WebView(
        initialUrl: url,
        // 'https://www.edamam.com/ontologies/edamam.owl#recipe_d81795fb677ba4f12ab1a104e10aac98',
      )),
    );
  }
}

class SearchPage extends StatefulWidget {
  String? search;
  SearchPage({this.search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Model> list = <Model>[];
  String? text;
  getApiData(search) async {
    final url =
        'https://api.edamam.com/search?q=$search&app_id=500beffb&app_key=6d0a7d16d6538143109b038910691992&from=0&to=100&calories=591-722&health=alcohol-free';

    var response = await http.get(Uri.parse(url));
    Map json = jsonDecode(response.body);
    json['hits'].forEach((e) {
      Model model = Model(
          url: e['recipe']['url'],
          image: e['recipe']['image'],
          source: e['recipe']['source'],
          label: e['recipe']['label']);
      setState(() {
        list.add(model);
      });
    });

    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData(widget.search);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Recipe"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  primary: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebPage(
                                      url: x.url,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(x.image.toString()))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.black.withOpacity(0.5),
                              child: Center(child: Text(x.label.toString())),
                            ),
                            Container(
                              padding: EdgeInsets.all(3),
                              height: 40,
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                  child:
                                      Text("Source : " + x.source.toString())),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
