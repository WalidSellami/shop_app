import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop/model/categoriesModel/CategorieModel.dart';
import 'package:shop/model/homeModel/HomeModel.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';
import 'package:shop/shared/components/Components.dart';
import 'package:hexcolor/hexcolor.dart';

class ProductsScreen extends StatelessWidget {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocConsumer<ShopCubit, ShopStates>(
            listener: (context, state) {
              if (state is ShopSuccessFavoritesModelState) {
                if (state.favorite?.status == false) {
                  showToast(
                      message: (state.favorite?.message).toString(),
                      state: ToastStates.error);
                }
              }
            }, builder: (context, state) {

          return ConditionalBuilder(
            condition: ShopCubit.get(context).home != null &&
                ShopCubit.get(context).categories != null,
            builder: (context) => CheckCubit.get(context).hasInternet ? RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue.shade700,
              backgroundColor: Colors.white,
              strokeWidth: 3.0,
              onRefresh: () async {
                ShopCubit.get(context).getHomeData();
                return Future<void>.delayed(const Duration(seconds: 3));
              },
              child: productsBuilder(ShopCubit.get(context).home,
                  ShopCubit.get(context).categories, context),
            ) :
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Internet',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(Icons.signal_wifi_connected_no_internet_4_outlined)
                ],
              ),
            ),
            fallback: (context) => CheckCubit.get(context).hasInternet
                ? Center(
                child: CircularProgressIndicator(
                    color: AppCubit.get(context).isDark
                        ? HexColor('198989')
                        : Colors.blue.shade700))
                : const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Internet',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Icon(Icons.signal_wifi_connected_no_internet_4_outlined)
                ],
              ),
            ),
          );
        });

      },
    );
  }

  Widget productsBuilder(
          HomeModel? model, CategoriesModel? categories, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model?.data?.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                viewportFraction: 1.0,
                autoPlayCurve: Curves.fastOutSlowIn,
                reverse: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      // color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoriesItem(
                            categories?.data?.data[index], context),
                        separatorBuilder: (context, index) => const SizedBox(
                              width: 10.0,
                            ),
                        itemCount: (categories?.data?.data.length)!.toInt()),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        'New Products',
                        style: TextStyle(
                          fontSize: 24.0,
                          // color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ShopCubit.get(context).showText();
                        },
                        child: Text(
                          'Show Description',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: AppCubit.get(context).isDark
                                ? HexColor('35c2c2')
                                : Colors.blue.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              color: AppCubit.get(context).isDark
                  ? Colors.grey.shade700.withOpacity(.2)
                  : Colors.grey.shade100,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio:
                    ShopCubit.get(context).isShow ? 1 / 1.97 : 1 / 1.56,
                children: List.generate(
                    model?.data?.products.length ?? 0,
                    (index) => buildGridProducts(
                        model?.data?.products[index], context)),
              ),
            ),
          ],
        ),
      );

  Widget buildCategoriesItem(DataModel? model, context) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(
              (model?.image).toString(),
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: 100.0,
            height: 25.0,
            color: AppCubit.get(context).isDark
                ? Colors.grey.shade300
                : Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                (model?.name).toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppCubit.get(context).isDark
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      );

  Widget buildGridProducts(ProductModel? model, context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    '${model?.image}',
                    width: double.infinity,
                    height: 200.0,
                  ),
                ),
                if (model?.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'discount'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model?.name}',
                    maxLines: ShopCubit.get(context).isShow ? null : 2,
                    overflow: ShopCubit.get(context).isShow
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(
                    height: 3.5,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model?.price.round()}',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: AppCubit.get(context).isDark
                              ? HexColor('198989')
                              : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if (model?.discount != 0)
                        Text(
                          '${model?.oldPrice.round()}',
                          style: const TextStyle(
                            fontSize: 11.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites((model.id)!.toInt());
                        },
                        splashColor: Colors.grey,
                        icon: CircleAvatar(
                          radius: 16.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[(model!.id)] ??
                                      true
                                  ? Colors.blue.shade700
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
