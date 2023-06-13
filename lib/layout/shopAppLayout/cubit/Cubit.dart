import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/shopAppLayout/cubit/States.dart';
import 'package:shop/model/categoriesModel/CategorieModel.dart';
import 'package:shop/model/favoritesModel/FavoritesModel.dart';
import 'package:shop/model/favoritesModel/Favorites_Model.dart';
import 'package:shop/model/homeModel/HomeModel.dart';
import 'package:shop/model/shopAppModel/LoginModel.dart';
import 'package:shop/model/shopAppModel/UpdateModel.dart';
import 'package:shop/modules/categoriesShop/CategoriesScreen.dart';
import 'package:shop/modules/favoritesShop/FavoritesScreen.dart';
import 'package:shop/modules/productsShop/ProductsScreen.dart';
import 'package:shop/modules/settingsShop/SettingsScreen.dart';
import 'package:shop/shared/components/Constants.dart';
import 'package:shop/shared/network/remot/DioHelper.dart';
import '../../../shared/network/EndPoint.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  final List<BottomNavigationBarItem> item = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.apps,
        ),
        label: 'Categories'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.favorite,
        ),
        label: 'Favorites'),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      label: 'Settings',
    ),
  ];

  final List<Widget> screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  final List<String> titles = [
    'Products',
    'Categories',
    'Favorites',
    'Settings',
  ];

  void changeBottom(int index) {
    currentIndex = index;
    if(index == 0){
      getHomeData();
    }
    else if(index == 1){
      getCategoriesData();
    }
    else if(index == 2){
      getFavorite();
    }
    else if(index == 3){
      getProfile();
    }
    emit(ShopChangeBottomNavState());
  }

  bool isShow = false;

  void showText(){
    isShow = !isShow;
    emit(ShopShowState());
  }

  HomeModel? home;
  
  CategoriesModel? categories;

  LoginModel? userData;

  ProductModel? product;

  Map<int, bool> favorites = {};

  FavoritesModel? favorite;

  void getHomeData() {
    emit(ShopLoadingHomeModelState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      home = HomeModel.fromJson(value?.data);
      home?.data?.products.forEach((element) {
        favorites.addAll({
          (element.id)!.toInt(): (element.inFavorites) ?? true,
        });
      });

      emit(ShopSuccessHomeModelState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorHomeModelState(error));
    });
  }

  void getCategoriesData() {
    DioHelper.getData(
      url: CATEGORIES,
      token: token,
    ).then((value) {
      categories = CategoriesModel.fromJson(value?.data);

      emit(ShopSuccessCategoriesModelState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorCategoriesModelState(error));
    });
  }

  void changeFavorites(int productId) {

    favorites[productId] = !(favorites[productId] ?? true);
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      favorite = FavoritesModel.fromJson(value?.data);

      if (favorite?.status == false) {
        favorites[productId] = !(favorites[productId] ?? true);
      }else {
        getFavorite();
      }

      emit(ShopSuccessFavoritesModelState(favorite));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      favorites[productId] = !(favorites[productId] ?? true);
      emit(ShopErrorFavoritesModelState(error));
    });
  }

  Favorites_Model? favor;

  void getFavorite(){
    emit(ShopLoadingGetFavoritesModelState());
    DioHelper.getData(
        url: FAVORITES,
        token: token,
    ).then((value) {

      favor = Favorites_Model.fromJson(value?.data);
       emit(ShopSuccessGetFavoritesModelState(favor));

    }).catchError((error){
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopErrorGetFavoritesModelState(error));
    });
  }


  void getProfile() {
    emit(ShopProfileLoadingState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userData = LoginModel.fromJson(value?.data);
      emit(ShopProfileSuccessState(userData!));
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ShopProfileErrorState(error));
    });
  }

  UpdateModel? update;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopUpdateLoadingState());
    DioHelper.putData(
      url: UPDATE,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
      token: token,
    ).then((value) {
      update = UpdateModel.fromJson(value?.data);
      // print(update);
      emit(ShopUpdateSuccessState(update!));
    }).catchError((error) {
      if (kDebugMode) {
        print('Error while updating : ${error.toString()}');
      }
      emit(ShopUpdateErrorState(error));
    });
  }

}
