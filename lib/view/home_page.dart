import 'package:flutter/material.dart';
import 'package:omdb_app/service/omdb_service.dart';
import 'package:omdb_app/view/movie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = " ";
  int _movies = 1;

  int getCount(List data){
   return data.length; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset("assets/imgs/logo.png"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding:EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pesquise um filme",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 20.0),
              textAlign: TextAlign.start,
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _movies = 1;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: getAPI(_search, _movies),
              builder: (context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 300.0,
                      height: 300.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError){
                      print("error");
                      return Container();
                    }

                    if (_search == " " && snapshot.data?['Search'] == null) {
                      return Center(
                        child: Container(
                          height: 300.0,
                          width: 300.0,
                          child: Image.asset("assets/imgs/Play.png"),
                        ),
                      );
                    }

                    if (snapshot.data?["Response"] == "False" && _search.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Nenhum resultado encontrado.",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Icon(Icons.sentiment_dissatisfied_rounded,
                            size: 50.0,)
                          ],
                        )
                      );
                    }
                    if(snapshot.hasData){
                      if(snapshot.data?['Search'] != null){
                        return Column(
                          children: [
                            Expanded(
                              child: _createList(context, snapshot),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if(_movies > 1)
                                  FilledButton(
                                    onPressed: () {
                                    setState(() {
                                      _movies -= 1;
                                    });
                                  }, 
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,  
                                      children: [
                                        Icon(Icons.arrow_back),  
                                        SizedBox(width: 8),  
                                        Text('Anterior '),  
                                      ],  
                                    ),
                                  ),
                                SizedBox(width: 10.0),
                                if(getCount(snapshot.data!["Search"]) >= 10)
                                  FilledButton.tonal(
                                    onPressed: () {
                                      setState(() {
                                        _movies += 1;
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, 
                                      children: [
                                        Text('Próximo '),  
                                        SizedBox(width: 8), 
                                        Icon(Icons.arrow_forward), 
                                          
                                      ],
                                    ),  
                                  ),
                              ],
                            ),
                          ],
                        );
                      } 
                    }
                  }
                return Center(
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    child: Image.asset("assets/imgs/Play.png"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

    Widget _createList(BuildContext context, AsyncSnapshot snapshot) {
    print(snapshot.data); 

    return ListView.separated(
      itemCount: getCount(snapshot.data['Search']), 
      itemBuilder: (context, index) {
        final movie = snapshot.data["Search"][index];

        return Column(
          children: <Widget>[
            ListTile(
              leading: Image.network(
                movie['Poster'] != "N/A" ? movie['Poster'] : "", 
                width: 50.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/imgs/poster-placeholder.png',
                    width: 50.0,
                    fit: BoxFit.cover,
                  );
                },
              ),
              title: Text(movie['Title']),
              subtitle: Text(movie['Year']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoviePage(movie['imdbID'])),
                );
              },
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.0),
    );
  }

}