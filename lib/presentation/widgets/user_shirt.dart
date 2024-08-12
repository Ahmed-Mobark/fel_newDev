part of 'widgets.dart';

class UserShirt extends StatefulWidget {
  const UserShirt({
    super.key,
    required this.name,
    required this.number,
    required this.gradient,
    this.textColor,
    this.shirtPhoto,
  });

  final String name;
  final String number;
  final String? shirtPhoto;
  final String? textColor;
  final Gradient gradient;

  @override
  State<UserShirt> createState() => _UserShirtState();
}

class _UserShirtState extends State<UserShirt> {
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

  String? token;

  _getToken() async {
    token = await rxPrefs.getString('token');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          widget.shirtPhoto == null
              ? Container(
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    image: DecorationImage(
                      image: AssetImage(newShirt),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: widget.shirtPhoto ?? '',
                  // width: 80.w,
                  // height: 80.h,
                  // fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      gradient: widget.gradient,
                      image: DecorationImage(
                        image: imageProvider,
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
          // : Container(
          //     decoration: BoxDecoration(
          //       gradient: widget.gradient,
          //       image: DecorationImage(
          //         image: NetworkImage(widget.shirtPhoto!),
          //       ),
          //     ),
          //   ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 3.w,
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 45.w,
                    child: Text(
                      widget.name.split(' ').first,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Aero',
                        color: hexToColor(
                          token != null
                              ? widget.textColor ?? "#FFFFFF"
                              : "#FFFFFF",
                        ),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  // SizedBox(
                  //   width: 130,
                  //   height: 60,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 20),
                  //     child: EllipticText(
                  //       text: widget.name.split(' ').first,
                  //       style: TextStyle(
                  //         fontSize: 18.sp,
                  //         fontWeight: FontWeight.w700,
                  //         fontFamily: 'Aero',
                  //         color: hexToColor(
                  //           widget.textColor ?? "#FFFFFF",
                  //         ),
                  //       ),
                  //       textAlignment: EllipticText_TextAlignment.centre,
                  //       // maxLines: 1,
                  //       // overflow: TextOverflow.visible,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: Platform.isIOS ? 1.h : 1.h),
                  //mobark

                  Text(
                    widget.number,
                    style: Get.textTheme.displayMedium?.copyWith(
                      fontSize: 40.sp,
                      fontFamily: 'Algerian',
                      color: hexToColor(
                        token != null
                            ? widget.textColor ?? "#FFFFFF"
                            : "#FFFFFF",
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
