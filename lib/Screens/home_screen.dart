import 'dart:developer';

import 'package:bazar_list/Models/bag_dto.dart';
import 'package:bazar_list/Provider/bag_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/product.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<BagDto>> bags = ref.watch(getAllBagProvider);
    final AsyncValue<List<Product>> p = ref.watch(getProductByBagIdProvider(1));
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: switch (bags) {
            AsyncData(:final value) => Column(
                children: [
                  for (BagDto bag in value)
                    Text('>>${bag.totalCost.toString()}'),
                ],
              ),
            AsyncError() => const Center(
                child: Text(
                    "Something unexpected happened while retrieve all bags"),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              ),
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: Text("Add"),
        ),
      ),
    );
  }
}
