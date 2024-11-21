import 'package:flutter/material.dart';
import 'package:omdb_app/service/omdb_service.dart';

class MoviePage extends StatefulWidget {
  MoviePage(this.movieID);
  final String movieID;


  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  
  @override
  void initState(){
    super.initState();
    print("Received movie: ${widget.movieID}");
    searchById(widget.movieID).then((map)=> print(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white
        ),   
        backgroundColor: Colors.black,
        title: Image.asset("assets/imgs/logo.png"),
        
      ),
      
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: searchById(widget.movieID), 
              builder: (context, snapshot){
                if(snapshot.connectionState != ConnectionState.done){
                  return Center(
                    child: Container(
                      width: 300.0,
                      height: 300.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5.0,
                      ),
                    ),
                  );
                }
                else{
                  return _createMoviePage(context, snapshot);
                }
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMoviePage(BuildContext context, AsyncSnapshot snapshot) {
  final Map movie = snapshot.data;
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[
          // Título do filme
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: double.infinity,
              height: 70.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 206, 169, 211),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                movie["Title"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Pôster
          Center(
            child: Image.network(
              movie["Poster"],
              width: 250.0, 
              height: 350.0, 
              fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/imgs/poster-placeholder.png', fit: BoxFit.contain);
              },
            ),
          ),

          const SizedBox(height: 20.0), 
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 239, 239),
              borderRadius: BorderRadius.circular(15.0)
            ),
            child: Padding(padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              _buildInfoRow('Ano de Lançamento:', movie["Year"]),
              _buildInfoRow('Id IMDB:', movie["imdbID"]),
              _buildInfoRow('Type:', movie["Type"]),
              _buildInfoRow('Rated:', movie["Rated"]),
              _buildInfoRow('Released date:', movie["Released"]),
              _buildInfoRow('Runtime:', movie["Runtime"]),
              _buildInfoRow('Genre:', movie["Genre"]),
              _buildInfoRow('Director:', movie["Director"]),
              _buildInfoRow('Writer:', movie["Writer"]),
              _buildInfoRow('Actors:', movie["Actors"]),
              _buildInfoRow('Languages:', movie["Language"]),
              _buildInfoRow('Country:', movie["Country"]),
              _buildInfoRow('Awards:', movie["Awards"]),
              _buildInfoRow('Metascore:', movie["MetaScore"]),
              _buildInfoRow('imdbRating:', movie["imdbRating"]),
              _buildInfoRow('imdbVotes:', movie["imdbVotes"]),
              _buildInfoRow('DVD:', movie["DVD"]),
              _buildInfoRow('BoxOffice:', movie["BoxOffice"]),
              _buildInfoRow('Production:', movie["Production"]),
              _buildInfoRow('Website:', movie["Website"]),
              ],
            ),),
          ),
          SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15.0), 
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), 
                  child: ExpansionTile(
                    collapsedBackgroundColor: const Color.fromARGB(255, 222, 179, 230),
                    backgroundColor: const Color.fromARGB(255, 231, 218, 233),
                    title: Text(
                      "Plot:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          movie["Plot"],
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15.0), 
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), 
                    child: ExpansionTile(
                      collapsedBackgroundColor: const Color.fromARGB(255, 194, 178, 228),
                      backgroundColor: const Color.fromARGB(255, 236, 222, 248),
                      title: Text(
                        "Ratings:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ), 
                        children: [
                          for(var rating in movie["Ratings"])
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: _buildInfoRow(rating["Source"], rating["Value"])
                            ),
                        ],
                    ),
                  ),
                ),
              SizedBox(height: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5.0), 
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

}