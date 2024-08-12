import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../models/store_model/store_model.dart';
import '../../../../widgets/w_profile_products.dart';
import '../../../../widgets/widgets.dart';

class ProfileProductsProfileList extends StatelessWidget {
  final List<StoreModel> products;
  const ProfileProductsProfileList(this.products, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: 100.w,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            for (int i = 0; i < products.length; i++)
              StaggeredGridTile.fit(
                crossAxisCellCount: 2,
                child: HorizontalAnimation(
                  duration: 50 * (i + 10),
                  child: CardProductProfileShop(
                    buttonText: tr("setProfile"),
                    width: context.width / 2.2,
                    storeModel: products[i],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
