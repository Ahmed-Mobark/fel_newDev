part of '../widgets.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({Key? key}) : super(key: key);

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  var _rangeValues = const RangeValues(25.0, 200.0);

  int _indexGender = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      margin: EdgeInsetsDirectional.only(top: 10.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        color: kColorPrimaryDark,
      ),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 5,
                margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: kColorCard,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            HorizontalAnimation(
              duration: 300,
              child: Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
                  child: Text(
                    'Filters',
                    style: Get.textTheme.displayMedium?.copyWith(
                      fontFamily: "Algerian",
                    ),
                  ),
                ),
              ),
            ),
            HorizontalAnimation(
              duration: 400,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                child: Text(
                  'Genders',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ),
              ),
            ),

            ///Gender
            Row(
              children: [
                Expanded(
                  child: HorizontalAnimation(
                    duration: 500,
                    child: CardGender(
                      label: 'Men',
                      isSelected: _indexGender == 1,
                      onTap: () {
                        setState(() {
                          _indexGender = 1;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: HorizontalAnimation(
                    duration: 550,
                    child: CardGender(
                      label: 'Women',
                      isSelected: _indexGender == 2,
                      onTap: () {
                        setState(() {
                          _indexGender = 2;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: HorizontalAnimation(
                    duration: 600,
                    child: CardGender(
                      label: 'Kids',
                      isSelected: _indexGender == 3,
                      onTap: () {
                        setState(() {
                          _indexGender = 3;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            HorizontalAnimation(
              duration: 700,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                child: Text(
                  'Price range',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ),
              ),
            ),

            ///Slider Price
            SizedBox(
              width: double.infinity,
              // height: 5.h,
              child: Row(
                children: [
                  HorizontalAnimation(
                    duration: 750,
                    child: Text(
                      '\$${(_rangeValues.start).round()}',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                  Expanded(
                    child: HorizontalAnimation(
                      duration: 800,
                      child: SliderTheme(
                        data: SliderThemeData(
                          valueIndicatorColor: kColorPrimary,
                          inactiveTickMarkColor: kColorCardHint,
                          activeTrackColor: kColorPrimary,
                          trackHeight: 1.5,
                        ),
                        child: RangeSlider(
                          values: _rangeValues,
                          min: 0.0,
                          max: 500.0,
                          divisions: 20,
                          inactiveColor: kColorCardHint,
                          activeColor: kColorIconCardHint,
                          labels: RangeLabels(
                            '\$${(_rangeValues.start).round()}',
                            '\$${(_rangeValues.end).round()}',
                          ),
                          onChanged: (RangeValues val) {
                            setState(() {
                              _rangeValues = val;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  HorizontalAnimation(
                    duration: 850,
                    child: Text(
                      '\$${(_rangeValues.end).round()}',
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ///Category
            HorizontalAnimation(
              duration: 850,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                child: Text(
                  'Product by category',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ),
              ),
            ),
            Wrap(
              children: [
                for (int i = 0; i < kProductCatygories.length; i++)
                  HorizontalAnimation(
                    duration: 200 * (i + 3),
                    child: SizedBox(
                      width: 40.w,
                      child: CheckboxListTile(
                        value: i == 2,
                        activeColor: kColorCard,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          kProductCatygories[i],
                          style: Get.textTheme.titleSmall?.copyWith(
                            fontFamily: "Algerian",
                          ),
                        ),
                        onChanged: (val) {},
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            ///Brand
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
              child: Text(
                'Brand',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontFamily: "Algerian",
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 20.w,
              child: ListView.builder(
                itemCount: kListMarkes.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return HorizontalAnimation(
                    duration: 200 * (i + 5),
                    child: Container(
                      width: 20.w,
                      margin:
                          const EdgeInsetsDirectional.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kColorCard,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          kListMarkes[i],
                          color: Colors.white,
                          width: 22.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardGender extends StatelessWidget {
  const CardGender({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 5.5.h,
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? kColorPrimary : null,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? null
              : Border.all(
                  color: kColorCardHint,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: Get.textTheme.titleMedium?.copyWith(
              fontFamily: "Algerian",
            ),
          ),
        ),
      ),
    );
  }
}
