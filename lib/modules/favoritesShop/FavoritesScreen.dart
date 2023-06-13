import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:shop/model/favoritesModel/Favorites_Model.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';


class FavoritesScreen extends StatelessWidget {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocConsumer<ShopCubit , ShopStates>(
          listener: (context , state) {},
          builder: (context , state){
            var favorite = ShopCubit.get(context).favor;
            return ConditionalBuilder(
                condition: ((favorite?.data?.data?.length) ?? 0) > 0,
                builder: (context) => CheckCubit.get(context).hasInternet ? RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Colors.blue.shade700,
                  backgroundColor: Colors.white,
                  strokeWidth: 3.0,
                  onRefresh: () async {
                    ShopCubit.get(context).getFavorite();
                    return Future<void>.delayed(const Duration(seconds: 3));
                  },
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context , index) => buildFavoriteItem(favorite?.data?.data?[index].product, context),
                      // separatorBuilder:  (context , index) => const SizedBox(
                      //   height: 6.0,
                      // ),
                      itemCount: (favorite?.data?.data?.length) ?? 0),
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
                fallback: (context) => CheckCubit.get(context).hasInternet ? const Center(child: Text(
                  'No Favorites Added',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),) :
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
            );
          },
        );

      },
    );
  }

  Widget buildFavoriteItem(Product? prod , context) => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: AppCubit.get(context).isDark ? Colors.grey.shade700.withOpacity(.2) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: AppCubit.get(context).isDark ? Colors.white : Colors.grey.shade900,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Image.network(
                        '${prod?.image}',
                        width: 130.0,
                        height: 150.0,
                      ),
                    ),
                    if (prod?.discount != 0)
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
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${prod?.name}',
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          // color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      // const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${prod?.price}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: AppCubit.get(context).isDark ? Colors.teal : Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (prod?.discount != 0)
                            Text(
                              '${prod?.oldPrice}',
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
                              ShopCubit.get(context).changeFavorites((prod?.id)!.toInt());
                            },
                            splashColor: Colors.grey,
                            icon: CircleAvatar(
                              radius: 16.0,
                              backgroundColor: ShopCubit.get(context).favorites[(prod?.id)] ?? true ? Colors.blue.shade700 : Colors.grey,
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
          ),
        ),
  );
}
