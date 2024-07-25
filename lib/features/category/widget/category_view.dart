import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_image.dart';
import 'package:flutter_almirtech_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_almirtech_ecommerce/features/category/widget/category_widget.dart';
import 'package:flutter_almirtech_ecommerce/features/product/view/brand_and_category_product_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/splash/provider/splash_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_almirtech_ecommerce/utill/custom_themes.dart';
import 'package:flutter_almirtech_ecommerce/utill/dimensions.dart';
import 'package:flutter_almirtech_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

import 'category_shimmer.dart';

class CategoryView extends StatelessWidget {
  final bool isHomePage;
  const CategoryView({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList != null
            ? categoryProvider.categoryList!.isNotEmpty
                ? SizedBox(
                    height: 120,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryProvider.categoryList?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BrandAndCategoryProductScreen(
                                          isBrand: false,
                                          id: categoryProvider
                                              .categoryList![index].id
                                              .toString(),
                                          name: categoryProvider
                                              .categoryList![index].name,
                                        )));
                          },
                          child: CategoryWidget(
                              category: categoryProvider.categoryList![index],
                              index: index,
                              length: categoryProvider.categoryList!.length),
                        );
                      },
                    ),
                  )
                : const SizedBox()
            : const CategoryShimmer();
      },
    );
  }
}

class CategroyViewNew extends StatelessWidget {
  const CategroyViewNew({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList != null
            ? categoryProvider.categoryList!.isNotEmpty
                ? SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BrandAndCategoryProductScreen(
                                          isBrand: false,
                                          id: categoryProvider
                                              .categoryList![index].id
                                              .toString(),
                                          name: categoryProvider
                                              .categoryList![index].name,
                                        )));
                          },
                          // child: CategoryWidgetNew(),
                        );
                      },
                    ),
                  )
                : const SizedBox()
            : const CategoryShimmer();
      },
    );
    ;
  }
}

class CategoryWidgetNew extends StatelessWidget {
  const CategoryWidgetNew({super.key, required this.text, required this.image});
  final String text;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * .35,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
            Images.icon,
          )),
          color: const Color.fromARGB(255, 201, 174, 174),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            child: Row(
          children: [
            Text(text,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge,
                    color: ColorResources.getTextTitle(context))),
          ],
        )),
      ),
    );
  }
}
