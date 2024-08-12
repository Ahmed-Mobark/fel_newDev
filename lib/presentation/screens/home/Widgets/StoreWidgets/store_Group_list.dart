import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/store_model/store_model.dart';
import '../../../../widgets/widgets.dart';

class StoreTGroupList extends StatelessWidget {
  final List<StoreModel> products;
  const StoreTGroupList(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: context.width,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: Column(
          children: [
            for (int i = 0; i < products.length; i++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HorizontalAnimation(
                  duration: 50 * (i + 10),
                  child: CardItemShop(
                    storeModel: products[i],
                    isCover: true,
                    width: context.width - 50,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
