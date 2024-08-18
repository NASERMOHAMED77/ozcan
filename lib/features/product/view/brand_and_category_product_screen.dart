// ignore_for_file: public_member_api_docs, sort_constructors_first, use_super_parameters
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_app_bar.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_slider/carousel_options.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/custom_slider/custom_slider.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/product_widget.dart';
import 'package:flutter_almirtech_ecommerce/basewidget/title_row.dart';
import 'package:flutter_almirtech_ecommerce/features/home/shimmer/latest_product_shimmer.dart';
import 'package:flutter_almirtech_ecommerce/features/home/widget/search_widget_home_page.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/story_model.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/provider/new_edits_provider.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/story.dart';
import 'package:flutter_almirtech_ecommerce/features/product/domain/model/product_model.dart';
import 'package:flutter_almirtech_ecommerce/features/product/view/view_all_product_screen.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/latest_product_view.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/latest_product_widget.dart';
import 'package:flutter_almirtech_ecommerce/features/product/widget/recommended_product_view.dart';
import 'package:flutter_almirtech_ecommerce/features/search/search_screen.dart';
import 'package:flutter_almirtech_ecommerce/helper/product_type.dart';
import 'package:flutter_almirtech_ecommerce/localization/language_constrants.dart';
import 'package:flutter_almirtech_ecommerce/localization/provider/localization_provider.dart';
import 'package:flutter_almirtech_ecommerce/utill/app_constants.dart';
import 'package:flutter_almirtech_ecommerce/utill/color_resources.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

class BrandAndCategoryProductScreen extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? category;
  final String? image;
  const BrandAndCategoryProductScreen(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image,
      this.category});

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
    Provider.of<NewEditsRepo>(context, listen: false)
        .fetch_story(AppConstants.editsBaseUrl + AppConstants.getStory);
    Provider.of<NewEditsRepo>(context, listen: false).fetch_highLigths(
        AppConstants.editsBaseUrl + AppConstants.getHighLigths,
        widget.category.toString());
    Provider.of<NewEditsRepo>(context, listen: false).fetch_CategorySlider(
        AppConstants.editsBaseUrl + AppConstants.getMainSlider);
    Provider.of<NewEditsRepo>(context, listen: false)
        .fetch_Categoey(AppConstants.editsBaseUrl + AppConstants.getCategory);

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
                            Consumer<NewEditsRepo>(
                                builder: (context, provider, _) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    provider.image
                                                .where((element) =>
                                                    element.category ==
                                                    widget.category)
                                                .toList()
                                                .length ==
                                            0
                                        ? FutureBuilder(
                                            future: Provider.of<NewEditsRepo>(
                                                    context,
                                                    listen: false)
                                                .fetch_story(
                                                    AppConstants.editsBaseUrl +
                                                        AppConstants.getStory),
                                            builder: (context, snapshots) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    child: InkWell(
                                                      onTap: () {},
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor: provider
                                                                    .categories
                                                                    .where((element) =>
                                                                        element
                                                                            .title ==
                                                                        widget
                                                                            .category)
                                                                    .toList()
                                                                    .length !=
                                                                0
                                                            ? Color(int.parse(provider
                                                                .categories
                                                                .where((element) =>
                                                                    element
                                                                        .title ==
                                                                    widget
                                                                        .category)
                                                                .toList()[0]
                                                                .color
                                                                .toString()))
                                                            : Colors.purple,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: provider
                                                                      .categories
                                                                      .where((element) =>
                                                                          element
                                                                              .title ==
                                                                          widget
                                                                              .category)
                                                                      .toList()
                                                                      .length !=
                                                                  0
                                                              ? Color(int.parse(provider
                                                                  .categories
                                                                  .where((element) =>
                                                                      element
                                                                          .title ==
                                                                      widget
                                                                          .category)
                                                                  .toList()[0]
                                                                  .color
                                                                  .toString()))
                                                              : Colors.purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "الحالة",
                                                      style: textBold,
                                                    ),
                                                  )
                                                ],
                                              );
                                            })
                                        : Row(
                                            children: [
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => MoreStories(
                                                                  listofstories: provider
                                                                      .image
                                                                      .where((element) =>
                                                                          element
                                                                              .category ==
                                                                          widget
                                                                              .category)
                                                                      .toList())));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor: provider
                                                                    .categories
                                                                    .where((element) =>
                                                                        element
                                                                            .title ==
                                                                        widget
                                                                            .category)
                                                                    .toList()
                                                                    .length !=
                                                                0
                                                            ? Color(int.parse(provider
                                                                .categories
                                                                .where((element) =>
                                                                    element
                                                                        .title ==
                                                                    widget
                                                                        .category)
                                                                .toList()[0]
                                                                .color
                                                                .toString()))
                                                            : Colors.purple,
                                                        child: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor:
                                                              Colors.white,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            provider.image
                                                                .where((element) =>
                                                                    element
                                                                        .category ==
                                                                    widget
                                                                        .category)
                                                                .toList()[0]
                                                                .lLinks!
                                                                .self!
                                                                .href
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "الحالة",
                                                      style: textBold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                    provider.highLigthsImages!
                                                .where((element) =>
                                                    element.category ==
                                                    widget.category)
                                                .toList()
                                                .length ==
                                            0
                                        ? SizedBox()
                                        : SizedBox(
                                            height: 108,
                                            child: ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: provider.ind,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => MoreStories(
                                                                      listofstories: provider
                                                                          .gruop[provider.keys[
                                                                              index]]!
                                                                          .where((element) =>
                                                                              element.category ==
                                                                              widget.category)
                                                                          .toList() as List<StoriesModel>)));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: CircleAvatar(
                                                            radius: 35,
                                                            backgroundColor: provider
                                                                        .categories
                                                                        .where((element) =>
                                                                            element.title ==
                                                                            widget
                                                                                .category)
                                                                        .toList()
                                                                        .length !=
                                                                    0
                                                                ? Color(int.parse(provider
                                                                    .categories
                                                                    .where((element) =>
                                                                        element
                                                                            .title ==
                                                                        widget
                                                                            .category)
                                                                    .toList()[0]
                                                                    .color
                                                                    .toString()))
                                                                : Colors.purple,
                                                            child: CircleAvatar(
                                                              radius: 30,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                provider
                                                                    .highLigthsCatImages[
                                                                        index]
                                                                    .lLinks!
                                                                    .self!
                                                                    .href
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          utf8.decoder.convert(
                                                              provider
                                                                  .highLigthsCatImages[
                                                                      index]
                                                                  .title!
                                                                  .codeUnits),
                                                          style: textBold,
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }),
                                          )
                                  ],
                                ),
                              );
                            }),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const SearchScreen())),
                                child: SearchWidgetHomePage(
                                  color: Provider.of<NewEditsRepo>(context)
                                              .categories
                                              .where((element) =>
                                                  element.title ==
                                                  widget.category)
                                              .toList()
                                              .length !=
                                          0
                                      ? Color(int.parse(
                                          Provider.of<NewEditsRepo>(context)
                                              .categories
                                              .where((element) =>
                                                  element.title ==
                                                  widget.category)
                                              .toList()[0]
                                              .color
                                              .toString()))
                                      : Colors.purple,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Consumer<NewEditsRepo>(
                                builder: (context, provider, _) {
                              return FutureBuilder(
                                  future: Provider.of<NewEditsRepo>(context,
                                          listen: false)
                                      .fetch_Slider(AppConstants.editsBaseUrl +
                                          AppConstants.getMainSlider),
                                  builder: (context, s) {
                                    return CarouselSlider(
                                      options: CarouselOptions(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        viewportFraction: 1.0,
                                        enlargeCenterPage: false,
                                        autoPlay: true,
                                      ),
                                      items: provider.sliderImages
                                          .where((element) =>
                                              element.category ==
                                              widget.category)
                                          .map((i) {
                                        return Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .35,
                                              width: double.infinity,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                placeholder: (c, cc) =>
                                                    Image.asset(
                                                        Images.placeholder),
                                                imageUrl: i.lLinks!.self!.href
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  });
                            }),
                            SizedBox(
                              height: 20,
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
                                                      category: widget.category!
                                                          .toUpperCase(),
                                                      isBrand: false,
                                                      name: widget.name,
                                                      id: widget.id,
                                                      index: index,
                                                      length: productProvider
                                                          .brandOrCategoryProductList
                                                          .length,
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

class ItemsView extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? category;
  final String? image;
  final int? index;
  final int? length;
  const ItemsView(
      {super.key,
      required this.isBrand,
      required this.id,
      required this.name,
      this.image,
      this.index,
      this.length,
      this.category});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IndexedScrollController controller =
        IndexedScrollController(initialIndex: widget.index!);
    Provider.of<ProductProvider>(context, listen: false)
        .initBrandOrCategoryProductList(widget.isBrand, widget.id, context);
    return Scaffold(
      appBar: CustomAppBar(title: widget.name),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(
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
                    ? Expanded(
                        child: ScrollablePositionedList.builder(
                          initialScrollIndex: widget.index!,
                          itemCount:
                              productProvider.brandOrCategoryProductList.length,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeSmall),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductWidget(
                                color: Provider.of<NewEditsRepo>(context)
                                            .categories
                                            .where((element) =>
                                                element.title ==
                                                widget.category)
                                            .toList()
                                            .length !=
                                        0
                                    ? Color(int.parse(Provider.of<NewEditsRepo>(
                                            context)
                                        .categories
                                        .where((element) =>
                                            element.title == widget.category)
                                        .toList()[0]
                                        .color
                                        .toString()))
                                    : Theme.of(context).highlightColor,
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

class MyWidget extends StatefulWidget {
  final bool isBrand;
  final String id;
  final String? name;
  final String? image;
  final int? index;
  final int? length;

  const MyWidget(
      {super.key,
      required this.isBrand,
      required this.id,
      this.name,
      this.image,
      this.index,
      this.length});
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 22; // index to scroll to

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedIndex != null) {
        _scrollController.animateTo(
          _selectedIndex *
              100.0, // 100 is an estimate of the height of each item
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(builder: (context, productProvider, c) {
      return Scaffold(
        body: ListView.builder(
          controller: _scrollController,
          itemCount: 50,
          itemBuilder: (context, index) {
            return productProvider.brandOrCategoryProductList.isNotEmpty
                ? Expanded(
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall),
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 1,
                      itemCount:
                          productProvider.brandOrCategoryProductList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(
                            color: Theme.of(context).highlightColor,
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
                          ));
            ;
          },
        ),
      );
    });
  }
}
