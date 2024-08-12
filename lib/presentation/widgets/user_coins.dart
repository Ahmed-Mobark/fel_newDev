import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserCoins extends StatelessWidget {
  final bool isThereAFunction;
  final bool isFromCoinsStore;
  final String numberOfCoins;
  const UserCoins(this.numberOfCoins,
      {this.isThereAFunction = true, this.isFromCoinsStore = false, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isThereAFunction ? () => Get.toNamed('/CoinShop') : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SvgPicture.asset(
              'assets/images/coins.svg',
              // ignore: deprecated_member_use
              allowDrawingOutsideViewBox: true,
              height: 3.h,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          // isFromCoinsStore
          //     ? Expanded(
          //         child: Text(numberOfCoins,
          //             style: const TextStyle(
          //                 color: Colors.amber, fontFamily: 'Algerian'),
          //             textAlign: TextAlign.start),
          //       )
          //     :
          Text(numberOfCoins,
              style:
                  const TextStyle(color: Colors.amber, fontFamily: 'Algerian')),
        ],
      ),
    );
  }
}
