import 'dart:io';

import 'package:desapega_jipa_master/helpers/ad_helper.dart';
import 'package:desapega_jipa_master/ui/ad_page.dart';
import 'package:desapega_jipa_master/ui/ad_view_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class AdHomePage extends StatefulWidget {
  @override
  _AdHomePageState createState() => _AdHomePageState();
}

class _AdHomePageState extends State<AdHomePage> {

  AdHelper helper = AdHelper();

  List<Ad> ads = List();

  @override
  void initState() {
    super.initState();

    _getAllAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anuncios"),
        backgroundColor: Colors.teal,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showAdPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return _adCard(context, index);
          }
      ),
    );
  }

  Widget _adCard(BuildContext context, int index){
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
                  image: DecorationImage(
                      image: ads[index].img != null ?
                      FileImage(File(ads[index].img)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ads[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(ads[index].email ?? "",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Text(ads[index].phone ?? "",
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),


      onTap: () {
        _showAdPage(ad: ads[index]);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdViewPage(), // ao clicar chama outra pagina
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          launch("tel:${ads[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        /*onPressed: (){
                          Navigator.pop(context);
                          _showAdPage(ad: ads[index]);
                        },*/

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          helper.deleteAd(ads[index].id);
                          setState(() {
                            ads.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  void _showAdPage({Ad ad}) async {
    final recAd = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AdPage(ad: ad,))
    );
    if(recAd != null){
      if(ad != null){
        await helper.updateAd(recAd);
      } else {
        await helper.saveAd(recAd);
      }
      _getAllAds();
    }
  }

  void _getAllAds(){
    helper.getAllAds().then((list){
      setState(() {
        ads = list;
      });
    });
  }

  void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        ads.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        ads.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
