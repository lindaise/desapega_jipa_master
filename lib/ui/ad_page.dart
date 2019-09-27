import 'dart:io';

import 'package:desapega_jipa_master/helpers/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdPage extends StatefulWidget {

  final Ad ad;

  AdPage({this.ad});

  @override
  _AdPageState createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Ad _editedAd;

  @override
  void initState() {
    super.initState();

    if(widget.ad == null){
      _editedAd = Ad();
    } else {
      _editedAd = Ad.fromMap(widget.ad.toMap());

      _nameController.text = _editedAd.name;
      _emailController.text = _editedAd.email;
      _phoneController.text = _editedAd.phone;
    }
  }

  @override
  //Widget _adCard(BuildContext context, int index){
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(_editedAd.name ?? "Novo Anúncio"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedAd.name != null && _editedAd.name.isNotEmpty){
              Navigator.pop(context, _editedAd);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedAd.img != null ?
                        FileImage(File(_editedAd.img)) :
                        AssetImage("images/add_foto.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){

                  _showOptions(context);
                },

              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedAd.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited = true;
                  _editedAd.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedAd.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }
//inicio-----------------------------------opçoes de camera e galeria
  void _showOptions(BuildContext context){
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
                        child: Text("Galeria",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          //launch("tel:${ads[index].phone}");
                          ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                            if(file == null) return;
                            setState(() {
                              _editedAd.img = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Camera",
                          style: TextStyle(color: Colors.teal, fontSize: 20.0),
                        ),
                        onPressed: (){
                          ImagePicker.pickImage(source: ImageSource.camera).then((file){
                            if(file == null) return;
                            setState(() {
                              _editedAd.img = file.path;
                            });
                          });
                          Navigator.pop(context);
                        },
                        /*onPressed: (){
                          Navigator.pop(context);
                          _showAdPage(ad: ads[index]);
                        },*/

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
// fim ------------ opçoes de camera e galeria


  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
