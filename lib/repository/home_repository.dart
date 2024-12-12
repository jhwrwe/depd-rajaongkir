import 'package:depd_2024_mvvm/data/network/network_api_services.dart';
import 'package:depd_2024_mvvm/model/city.dart';
import 'package:depd_2024_mvvm/model/costs/cost.dart';
import 'package:depd_2024_mvvm/model/costs/costs.dart';
import 'package:depd_2024_mvvm/model/model.dart';

class HomeRepository {
  final _apiServices = NetworkApiServices();

  Future<List<Province>> fetchProvinceList() async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/province');
      List<Province> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => Province.fromJson(e))
            .toList();
      }
      return result;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<City>> fetchCityList(var provId) async {
    try {
      dynamic response = await _apiServices.getApiResponse('/starter/city');
      List<City> result = [];

      if (response['rajaongkir']['status']['code'] == 200) {
        result = (response['rajaongkir']['results'] as List)
            .map((e) => City.fromJson(e))
            .toList();
      }

      List<City> selectedCities = [];
      for (var c in result) {
        if (c.provinceId == provId) {
          selectedCities.add(c);
        }
      }

      return selectedCities;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Costs>> fetchCostList(
      String cityId1, String cityId2, int weight, String courier) async {
    try {
      dynamic response = await _apiServices.postApiResponse('/starter/cost', {
        "origin": cityId1,
        "destination": cityId2,
        "weight": weight,
        "courier": courier,
      });

      // Log the response to inspect it
      print('API Response: $response');

      if (response['rajaongkir'] == null) {
        throw Exception('No rajaongkir in the response');
      }

      if (response['rajaongkir']['status']['code'] == 200) {
        final results = response['rajaongkir']['results'] as List;
        return results
            .expand((result) => (result['costs'] as List)
                .map((cost) => Costs.fromJson(cost as Map<String, dynamic>)))
            .toList();
      } else {
        throw Exception(
            'API Error: ${response['rajaongkir']['status']['description']}');
      }
    } catch (e) {
      print('Error fetching cost list: $e');
      throw Exception('Error fetching cost list: $e');
    }
  }
}
