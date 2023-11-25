import 'dart:developer';

import 'package:bazar_list/Models/Bag.dart';
import 'package:bazar_list/Models/product.dart';
import 'package:bazar_list/Services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbService dbService = DbService();
    return MaterialApp(

      home: Scaffold(
        body: Center(
          child: Row(
            children: [
              ElevatedButton(onPressed: () async {
                List<Product> products = [
                  Product(
                    name: 'Product 1',
                    perUnitPrice: 100,
                    unitType: 'Type 1',
                    quantity: 10,
                    price: 1000,
                  ),
                  Product(
                    name: 'Product 2',
                    perUnitPrice: 200,
                    unitType: 'Type 2',
                    quantity: 20,
                    price: 4000,
                  ),
                  Product(
                    name: 'Product 3',
                    perUnitPrice: 300,
                    unitType: 'Type 3',
                    quantity: 30,
                    price: 9000,
                  ),
                ];
                Bag b = new Bag( createTime: 'createTime', products: products);
               await dbService.createNewBag(b);
              }, child: Text("add")),
              ElevatedButton(onPressed: () async {
                var d = await dbService.getAllBag();
                log(">>>${d.length}");
              }, child: Text("get")),
            ],
          ),
        ),
      ),
    );
  }
}
