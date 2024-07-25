// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_app_bar.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_slider/carousel_options.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_slider/custom_slider.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/product_widget.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/title_row.dart';
import 'package:flutter_almirtech_ecommerce/features/home/shimmer/latest_product_shimmer.dart';
import 'package:flutter_almirtech_ecommerce/features/home/widget/search_widget_home_page.dart';
import 'package:flutter_almirtech_ecommerce/features/product/domain/model/product_model.dart';
import 'package:flutter_almirtech_ecommerce/features/product/view/view_all_product_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/latest_product_view.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/latest_product_widget.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/recommended_product_view.dart';
import 'package:flutter_almirtech_ecommerce/features/search/search_screen.dart';
import 'package:flutter_almirtech_ecommerce/helper/product_type.dart';
import 'package:flutter_almirtech_ecommerce/localization/language_constrants.dart';
import 'package:flutter_almirtech_ecommerce/localization/provider/localization_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'package:flutter_almirtech_ecommerce/basewidget/custom_image.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/no_internet_screen.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/product_shimmer.dart';
import 'package:flutter_almirtech_ecommerce/features/home/widget/cart_widget_home_page.dart';
import 'package:flutter_almirtech_ecommerce/features/product/provider/product_provider.dart';
import 'package:flutter_almirtech_ecommerce/features/splash/provider/splash_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/custom_themes.dart';
import 'package:flutter_almirtech_ecommerce/utill/dimensions.dart';
import 'package:flutter_almirtech_ecommerce/utill/images.dart';
import 'package:shimmer/shimmer.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const BrandAndCategoryProductScreen(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image});

  @override
  State<BrandAndCategoryProductScreen> createState() =>
      _BrandAndCategoryProductScreenState();
}

class _BrandAndCategoryProductScreenState
    extends State<BrandAndCategoryProductScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProductProvider>(context, listen: false)
        .initBrandOrCategoryProductList(widget.isBrand, widget.id, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).highlightColor,
          actions: [
            CartWidgetHomePage(),
          ],
          title: Row(
            children: [
              Image.asset(Images.logoWithNameImage, height: 35),
              Text(widget.name.toString())
            ],
          )),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  widget.isBrand
                      ? Container(
                          height: 100,
                          padding:
                              const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          margin: const EdgeInsets.only(
                              top: Dimensions.paddingSizeSmall),
                          color: Theme.of(context).highlightColor,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomImage(
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.brandImageUrl}/${widget.image}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text(widget.name!,
                                    style: titilliumSemiBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                              ]),
                        )
                      : const SizedBox.shrink(),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Products
                  productProvider.brandOrCategoryProductList.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.black,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.purple,
                                  child: Text(getTranslated("story", context).toString(),
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SearchScreen())),
                                child: const SearchWidgetHomePage()),
                            SizedBox(
                              height: 40,
                            ),
                            CarouselSlider(
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height * .35,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                              ),
                              items: productProvider.brandOrCategoryProductList
                                  .map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return const Padding(
                                        padding: EdgeInsets.only(
                                            bottom: Dimensions.homePagePadding),
                                        child: RecommendedProductView());
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 500,
                              child: MasonryGridView.count(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 3,
                                itemCount: productProvider
                                    .brandOrCategoryProductList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ItemsView(
                                                      image: widget.image,
                                                      isBrand: false,
                                                      name: widget.name,
                                                      id: widget.id,
                                                    )));
                                      },
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productThumbnailUrl}/${productProvider.brandOrCategoryProductList[index].thumbnail}'))),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: productProvider.hasData!
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        child: CircleAvatar(
                                          radius: 30,
                                        ),
                                        baseColor: Theme.of(context).cardColor,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Shimmer.fromColors(
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .08,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorResources.iconBg(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        spreadRadius: 1,
                                                        blurRadius: 5)
                                                  ]),
                                            )),
                                        baseColor: Theme.of(context).cardColor,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Shimmer.fromColors(
                                        child: SizedBox(
                                            height: 170,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      ColorResources.iconBg(),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        spreadRadius: 1,
                                                        blurRadius: 5)
                                                  ]),
                                            )),
                                        baseColor: Theme.of(context).cardColor,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Shimmer.fromColors(
                                        child: SizedBox(
                                          height: 500,
                                          child: MasonryGridView.count(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeSmall),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            crossAxisCount: 3,
                                            itemCount: 6,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        baseColor: Theme.of(context).cardColor,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                      )
                                    ],
                                  ),
                                )
                              : const NoInternetOrDataScreen(
                                  isNoInternet: false,
                                  icon: Images.noProduct,
                                  message: 'no_product_found',
                                )),
                ]),
          );
        },
      ),
    );
  }
}

class ItemsView extends StatelessWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  const ItemsView(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image});
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .initBrandOrCategoryProductList(isBrand, id, context);
    return Scaffold(
      appBar: CustomAppBar(title: name),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                isBrand
                    ? Container(
                        height: 100,
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        margin: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        color: Theme.of(context).highlightColor,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomImage(
                                image:
                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.brandImageUrl}/$image',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Text(name!,
                                  style: titilliumSemiBold.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                            ]),
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                // Products
                productProvider.brandOrCategoryProductList.isNotEmpty
                    ? Expanded(
                        child: MasonryGridView.count(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 1,
                          itemCount:
                              productProvider.brandOrCategoryProductList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductWidget(
                                productModel: productProvider
                                    .brandOrCategoryProductList[index]);
                          },
                        ),
                      )
                    : Expanded(
                        child: productProvider.hasData!
                            ? ProductShimmer(
                                isHomePage: false,
                                isEnabled: Provider.of<ProductProvider>(context)
                                    .brandOrCategoryProductList
                                    .isEmpty)
                            : const NoInternetOrDataScreen(
                                isNoInternet: false,
                                icon: Images.noProduct,
                                message: 'no_product_found',
                              )),
              ]);
        },
      ),
    );
  }
}
