import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../models/store_model/store_model.dart';
import '../../../../widgets/widgets.dart';

class GroupPictureList extends StatelessWidget {

  final List<StoreModel> products;
  final String groupId;
  final int groupIndex;
  const GroupPictureList(this.products, this.groupId ,{super.key, required this.groupIndex});

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
                child: StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 3,
                  child: HorizontalAnimation(
                    duration: 50 * (i + 10),
                    child: CardGroupPictureScreen(
                      itemIndex:groupIndex,
                      storeModel: products[i],
                      width: context.width - 50,
                      groupId: groupId,
              
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
