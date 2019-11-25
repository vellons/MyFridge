// components.dart - Layout for app
import 'package:flutter/material.dart';

class MyFridgeElement extends StatefulWidget {

  String picUrl;
  String name;
  String expiry;
  int qty;

  MyFridgeElement({Key key, this.picUrl, this.name, this.expiry, this.qty}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyFridgeElement();
  }
}

class _MyFridgeElement extends State<MyFridgeElement> {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,  
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width * 0.25,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        widget.picUrl,
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(widget.qty.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(" "),
                            Text(widget.name, style: new TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(widget.expiry.substring(0,10)),
                        
                      ],
                    )
                  ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width * 0.10,
                    child: Column(
                      children: <Widget>[
                          IconButton(
                          color: Colors.orange,
                          icon: Icon(Icons.remove_circle_outline),
                          tooltip: "Remove one item",
                          onPressed: () {
                            setState(() { 
                              if(widget.qty > 0) {
                                widget.qty = widget.qty - 1;
                              }
                            });
                          },
                        ),
                      ],
                    )
                  )

                ]
              ),
            ],
          )
        )
      )
    );
  }
}