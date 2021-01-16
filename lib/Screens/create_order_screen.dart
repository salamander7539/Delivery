import 'package:flutter/material.dart';
import 'main_map_screen.dart';

class CreateOrder extends StatefulWidget {
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

var findAddressController = TextEditingController();

class _CreateOrderState extends State<CreateOrder> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15.0),
            topRight: const Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Icon(
                        Icons.circle,
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Адрес подачи',
                        ),
                      ),
                    ),
                    VerticalDivider(color: Color(0xFFEDEDED),
                      thickness: 1, width: 1,
                      ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: FlatButton(
                          child: Text(
                            'Карта'
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              Column(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
