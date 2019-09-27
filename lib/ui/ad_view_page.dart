import 'package:flutter/material.dart';

class AdViewPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:
        /*Text(ads[index].name ?? "",
            style: TextStyle(fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),*/
        Text("Titulo Aqui"),
        centerTitle: true,
      ),

      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //launch("tel:${ads[index].phone}");
        },
        tooltip: 'Ligar',
        child: Icon(Icons.call),
        elevation: 4.0,
        backgroundColor: Colors.teal,
      ),

      /* body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Text("helloo"),
          ],
        ),
      ),*/

      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          //itemCount: ads.length,
          itemBuilder: (context, index) {
            return _adCard(context, index); //--------- card a ser exibido
          }

      ),
    );
  }


  Widget _adCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  /*image: DecorationImage(
                      image: ads[index].img != null
                          ? FileImage(File(ads[index].img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover),*/
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("nome"
                      /*ads[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),*/
                    ),
                    Text("email"
                      /*ads[index].email ?? "",
                      style: TextStyle(fontSize: 22.0),*/
                    ),
                    Text("telefone"
                      /*ads[index].phone ?? "",
                      style: TextStyle(fontSize: 12.0),*/
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

}
