import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/layout/cubit/States.dart';
import 'package:shop/layout/shopAppLayout/cubit/Cubit.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:shop/model/categoriesModel/CategorieModel.dart';

class CategoriesScreen extends StatelessWidget {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state){},
      builder: (context , state){
        return BlocConsumer<ShopCubit , ShopStates>(
          listener: (context , state){},
          builder: (context , state){
            var cubit = ShopCubit.get(context);
            return CheckCubit.get(context).hasInternet ? RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue.shade700,
              backgroundColor: Colors.white,
              strokeWidth: 3.0,
              onRefresh: () async {
                ShopCubit.get(context).getCategoriesData();
                return Future<void>.delayed(const Duration(seconds: 3));
              },
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context , index) => buildItem(cubit.categories?.data?.data[index]),
                  separatorBuilder:  (context , index) => const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: (cubit.categories?.data?.data.length) ?? 0),
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
            );
          },
        );

      },
    );
  }


  Widget buildItem(DataModel? model) =>  Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image.network((model?.image).toString(),
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 20.0,
        ),
        Text(
          (model?.name).toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        // const Spacer(),
        // IconButton(
        //   onPressed: (){
        //
        //   },
        //   icon: const Icon(
        //     Icons.arrow_forward_ios,
        //   ),)
      ],
    ),
  );
}
