import 'dart:developer';
import 'package:bazar_list/Models/Bag.dart';
import 'package:bazar_list/Models/bag_dto.dart';
import 'package:bazar_list/Models/product.dart';
import 'package:bazar_list/Services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final DbService _db = DbService();

final AutoDisposeFutureProvider<List<BagDto>> getAllBagProvider =
    FutureProvider.autoDispose((ref) async {
  final List<BagDto> bags;
  try {
    bags = await _db.getAllBag();
    return bags;
  } catch (err) {
    log("Provider  ERROR::$err");
  }
  return Future.error('error');
});

final AutoDisposeFutureProviderFamily<void, Bag> addNewBagProvider =
    FutureProvider.autoDispose.family<void, Bag>((ref, bag) async {
       try{
         await _db.createNewBag(bag);
       }catch (err){
         return Future.error(err);
       }
    });

final AutoDisposeFutureProviderFamily<List<Product>,int> getProductByBagIdProvider =
    FutureProvider.autoDispose.family<List<Product>,int>((ref, bagId) async  {
           try{
             return await _db.getProductByBag(bagId);
           }catch(err){
             return Future.error(err);
           }
    });

/*

 var d = Bag(
              createTime: '2023-11-25 12:00:00',
              totalCost: 500,
              products: [
                Product(
                  name: 'Product 1',
                  perUnitPrice: 100,
                  unitType: 'Unit 1',
                  quantity: 5,
                  price: 500,
                ),
                Product(
                  name: 'Product 2',
                  perUnitPrice: 200,
                  unitType: 'Unit 2',
                  quantity: 2,
                  price: 400,
                ),
              ],
            );
 */