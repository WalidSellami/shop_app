import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/Cubit.dart';
import 'package:shop/model/searchModel/SearchModel.dart';
import 'package:shop/modules/searchShop/cubit/Cubit.dart';
import 'package:shop/modules/searchShop/cubit/States.dart';
import 'package:shop/modules/settingsShop/darkMode/cubit/Cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit()..listen(),
      child: BlocConsumer<SearchCubit , SearchStates>(
        listener: (context , state){},
        builder: (context , state){
          var cubit = SearchCubit.get(context);
          var search = cubit.searchModel;
          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Colors.white,
            //   elevation: 0,
            //   leading: IconButton(
            //     onPressed: (){
            //       Navigator.pop(context);
            //     },
            //     icon: Icon(
            //       Icons.arrow_back_ios_new_rounded,
            //       color: Colors.black,
            //     ),
            //     tooltip: 'Back',
            //   ),
            //   title: Text(
            //     'Search',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: cubit.controller,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Search...',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            width: 1.2,
                          ),
                        ),
                        prefixIcon: IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                            ),
                          tooltip: 'Back',
                        ),
                        suffixIcon: cubit.controller.text.isNotEmpty ? IconButton(
                            onPressed: (){
                              cubit.clearSearch();
                            },
                            icon: const Icon(Icons.close_rounded)): null,
                      ),
                      onChanged: (value){
                        cubit.search(value);
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: CheckCubit.get(context).hasInternet ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                          itemBuilder: (context , index) => buildItemSearch(search?.data?.data?[index], context),
                          separatorBuilder: (context , index) => const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1.5,
                            ),
                          ),
                          itemCount: (search?.data?.data?.length) ?? 0) :
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItemSearch(SData? product , context) => SizedBox(
    height: 130.0,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Image.network(
              '${product?.image}',
              width: 120.0,
              height: 130.0,
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product?.name}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${product?.price}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppCubit.get(context).isDark ? Colors.teal : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
