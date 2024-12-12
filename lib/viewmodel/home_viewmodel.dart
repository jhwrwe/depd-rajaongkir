import 'package:depd_2024_mvvm/data/response/api_response.dart';
import 'package:depd_2024_mvvm/model/city.dart';
import 'package:depd_2024_mvvm/model/costs/costs.dart';
import 'package:depd_2024_mvvm/model/model.dart';
import 'package:depd_2024_mvvm/repository/home_repository.dart';
import 'package:flutter/material.dart';

class HomeViewmodel with ChangeNotifier {
  final _homeRepo = HomeRepository();
  ApiResponse<List<Province>> provincelist = ApiResponse.loading();

  setProvinceList(ApiResponse<List<Province>> response) {
    provincelist = response;
    notifyListeners();
  }

  Future<dynamic> getProvinceList() async {
    setProvinceList(ApiResponse.loading());
    _homeRepo.fetchProvinceList().then((value) {
      setProvinceList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setProvinceList(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> CityListOrigin = ApiResponse.loading();

  setCityListOrigin(ApiResponse<List<City>> response) {
    CityListOrigin = response;
    notifyListeners();
  }

  Future<dynamic> getCityListOrigin(var provId) async {
    setCityListOrigin(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityListOrigin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListOrigin(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<City>> CityListDestination = ApiResponse.loading();

  setCityListDestination(ApiResponse<List<City>> response) {
    CityListDestination = response;
    notifyListeners();
  }

  Future<dynamic> getCityListDestination(var provId) async {
    setCityListDestination(ApiResponse.loading());
    _homeRepo.fetchCityList(provId).then((value) {
      setCityListDestination(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCityListDestination(ApiResponse.error(error.toString()));
    });
  }

  ApiResponse<List<Costs>> CostList = ApiResponse.loading();

  setCostList(ApiResponse<List<Costs>> response) {
    CostList = response;
    notifyListeners();
  }

  Future<dynamic> getCostList(
      String origin, String destination, int weight, String courier) async {
    setCostList(ApiResponse.loading());
    _homeRepo.fetchCostList(origin, destination, weight, courier).then((value) {
      
      setCostList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCostList(ApiResponse.error(error.toString()));
    });
  }
}
