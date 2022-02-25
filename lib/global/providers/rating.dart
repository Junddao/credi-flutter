import 'package:crediApp/global/models/rating/rating_model.dart';
import 'package:crediApp/global/models/rating/rating_response_model.dart';
import 'package:crediApp/global/providers/parent_provider.dart';
import 'package:crediApp/global/service/api_service.dart';
import 'package:flutter/material.dart';

class RatingChangeNotifier extends ParentProvider {
  List<RatingResponseData>? ratingData = [];

  Future<void> createRating(Rating rating) async {
    try {
      setStateBusy();
      var api = ApiService();
      await api.post('/rating/create', rating.toMap());

      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }

  Future<void> getRatingById(int id) async {
    try {
      setStateBusy();

      print('getRatingById start');
      var api = ApiService();
      var response = await api.get('/rating/get/$id');
      RatingResponse ratingResponse = RatingResponse.fromMap(response);
      ratingData = ratingResponse.data;
      print('rating num : ' + ratingData!.length.toString());
      print('getRatingById end');
      setStateIdle();
    } catch (error) {
      setStateError();
    }
  }
}
