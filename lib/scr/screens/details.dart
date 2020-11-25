import 'package:flutter/material.dart';
import 'package:flutter_app_course/scr/helpers/screen_navigation.dart';
import 'package:flutter_app_course/scr/helpers/style.dart';
import 'package:flutter_app_course/scr/models/products.dart';
import 'package:flutter_app_course/scr/models/user.dart';
import 'package:flutter_app_course/scr/providers/app.dart';
import 'package:flutter_app_course/scr/providers/user.dart';
import 'package:flutter_app_course/scr/screens/cart.dart';
import 'package:flutter_app_course/scr/widgets/custom_text.dart';
import 'package:flutter_app_course/scr/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../helpers/style.dart';

class Details extends StatefulWidget {
  final ProductModel product;
  final UserModel userModel;

  const Details({@required this.product, this.userModel});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1;
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              changeScreen(context, CartScreen());
            },
          ),
        ],
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: SafeArea(
        child: app.isLoading
            ? Loading()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(widget.product.image),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      text: widget.product.name,
                      size: 26,
                      weight: FontWeight.bold),
                  CustomText(
                      text: "ksh ${widget.product.price / 100}",
                      size: 20,
                      weight: FontWeight.w400),
                  SizedBox(
                    height: 5,
                  ),
                  CustomText(
                      text: "Description", size: 18, weight: FontWeight.w400),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.product.description,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: grey, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 36,
                            ),
                            onPressed: () {
                              if (quantity != 1) {
                                setState(() {
                                  quantity -= 1;
                                });
                              }
                            }),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("All set loading");

                          bool value = await user.addToCard(
                              product: widget.product, quantity: quantity);
                          if (value) {
                            print("Item added to cart");
                            _key.currentState.showSnackBar(
                                SnackBar(content: Text("Added ro Cart!")));
                            user.reloadUserModel();
                            return;
                          } else {
                            print("Item NOT added to cart");
                          }
                          print("LOADING SET TO FALSE");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                            child: CustomText(
                              text: "Add $quantity To Cart",
                              color: white,
                              size: 22,
                              weight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 36,
                              color: red,
                            ),
                            onPressed: () {
                              setState(() {
                                quantity += 1;
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
