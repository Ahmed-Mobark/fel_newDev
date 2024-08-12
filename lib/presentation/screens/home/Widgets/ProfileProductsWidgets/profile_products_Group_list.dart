import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/store_model/store_model.dart';
import '../../../../widgets/w_profile_products.dart';
import '../../../../widgets/widgets.dart';

class ProfileProductsGroupList extends StatelessWidget {
  final List<StoreModel> products;
  const ProfileProductsGroupList(this.products, {super.key});

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
                  child: CardProductProfileShop(
                    storeModel: products[i],
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
