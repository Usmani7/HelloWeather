import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

final defaultcity = "Gujrat";
final appID = "503e1981fe9c7a466df6c7edf341b8ff";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _cityentered;
  Future _gotosearch(BuildContext context) async {
    Map results = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ChangeCity()),
    );
    if (results != null && results.containsKey('enter')){
      _cityentered = results['enter'];
    }    
  }
  void gettingData() async{
    Map data = await getData(defaultcity, appID);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Weather"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
               icon: Icon(Icons.search),
               onPressed: () {
                 _gotosearch(context);
               },
            ),
          ],
        ),
        body: Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            'umbrella.png',
            height: 1200,
            width: 500,
            fit: BoxFit.fill,
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 21.0, 0.0),
            child: Text(_cityentered==null ? defaultcity: _cityentered,
            style: cityname(),),
          ),
          Container(
            child: Center(
            child: Image.asset(
              'rain.png'
            ),
          ),
          ),
          Container(
            child: tempBuilder(_cityentered),
          ),
        ],
      ),
    ),
    );

  }


  Future<Map> getData(String city, String appID) async{
    String apiurl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appID&units=metric';
    http.Response response = await http.get(apiurl);
    return json.decode(response.body);
  }

  Widget tempBuilder (String city) {
    return FutureBuilder(
      future: getData(city == null ? defaultcity :  city , appID),
      builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
         Map content = snapshot.data;
         return new Container(
           margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               ListTile(
                 title: Text(content['main']['temp'].toString() + " C",
                 style: temptext(),),
                 subtitle: ListTile(
                   title: Text(
                     "Humidity: ${content['main']['humidity'].toString()}\n"
                     "Min: ${content['main']['temp_min'].toString()} C\n"
                     "Max: ${content['main']['temp_max'].toString()} C",
                     style: extratext(),
                   ),
                 ),
               ),
             ],
           ),
         );
        }
        else return new Container(
          child: Text("Not Found"),
        );
      }
    );
  }

}

  TextStyle cityname () {
    return TextStyle(
      fontSize: 26.0,
      color: Colors.white,
    );
  }

  TextStyle temptext () {
    return TextStyle(
      fontSize: 50.0,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle extratext () {
    return TextStyle(
      fontSize: 20.0,
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w300,
    );
  }

  class ChangeCity extends StatelessWidget {
    var citycontroller = new TextEditingController();
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Change City"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                'snow.png',
                height: 1200,
                width: 490,
                fit: BoxFit.fill,
              ),
            ),
            ListView(
              children: <Widget>[
                ListTile(
                  title: TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      hintText: 'e.g Gujrat',
                    ),
                    controller: citycontroller,
                    keyboardType: TextInputType.text,
                  ),
                ),
                ListTile(
                  title: FlatButton(
                    child: Text("Get Weather"),
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': citycontroller.text
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        )
      );
    }
  }