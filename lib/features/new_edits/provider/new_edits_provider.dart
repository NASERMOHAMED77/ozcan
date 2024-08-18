import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/cat_slider_model.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/highligths_model.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/main_slider_model.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/story_model.dart';
import 'package:http/http.dart' as http;

class NewEditsRepo extends ChangeNotifier {
  List<StoriesModel> image = [];
  List<SliderModel> sliderImages = [];
  List<CategorySliderModel> categorySliderImages = [];
  List<StoriesModel> highLigthsImages = [];
  List<StoriesModel> highLigthsCatImages = [];
  Map<String, List<StoriesModel>> gruop = {};
  List<StoriesModel> xx = [];
  List<String> keys = [];
  int ind = 0;
  List<CategoryModel> categories = [];
  
  fetch_Categoey(String url) async {
    var response = await http.get(Uri.parse(url));
    categories = [];
    if (response.statusCode == 200) {
      try {
        for (var element in json.decode(response.body)) {
          categories.add(CategoryModel.fromJson(element));
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
      print('Response status: ${response.statusCode}');
    } else {
      print('Response status: ${response.statusCode}');

      print('Failed to load data');
    }
  }

  fetch_story(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      image = [];

      try {
        for (var element in json.decode(response.body)["_embedded"]
            ["storyResponseList"]) {
          image.add(StoriesModel.fromJson(element));
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
      print('Response status: ${response.statusCode}');
    } else {
      print('Failed to load data');
    }
  }

  fetch_Slider(String url) async {
    var response = await http.get(Uri.parse(url));
    sliderImages = [];
    if (response.statusCode == 200) {
      try {
        for (var element in json.decode(response.body)["_embedded"]
            ["categoricalSliderResponseList"]) {
          sliderImages.add(SliderModel.fromJson(element));
        }
        print(sliderImages);
        notifyListeners();
      } catch (e) {
        print(e);
      }
      print('Response status: ${response.statusCode}');
    } else {
      print('Response status: ${response.statusCode}');

      print('Failed to load data');
    }
  }

  fetch_CategorySlider(String url) async {
    var response = await http.get(Uri.parse(url));
    categorySliderImages = [];
    if (response.statusCode == 200) {
      try {
        for (var element in json.decode(response.body)["_embedded"]
            ["categoricalSliderResponseList"]) {
          categorySliderImages.add(CategorySliderModel.fromJson(element));
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
      print('Response status: ${response.statusCode}');
    } else {
      print('Response status: ${response.statusCode}');

      print('Failed to load data');
    }
  }

  fetch_highLigths(String url, String category) async {
    var response = await http.get(Uri.parse(url));
    highLigthsImages = [];
    gruop = {};
    int x = 0;
    ind = 0;
    xx = [];
    keys = [];
    if (response.statusCode == 200) {
      try {
        var xxx = utf8.encode(response.body);
        for (var element in json.decode(response.body)["_embedded"]
            ["highlightResponseList"]) {
          highLigthsImages.add(StoriesModel.fromJson(element));
        }
        highLigthsCatImages = [];

        for (var element in highLigthsImages) {
          gruop[highLigthsImages[x].title.toString()] = highLigthsImages
              .where((element) =>
                  element.title == highLigthsImages[x].title.toString())
              .toList();
          x++;
          if (element.category == category) {
            keys.add(element.title.toString());
          }
        }
        keys = keys.toSet().toList();
        for (var element in xx) {}
        for (var element in gruop.values) {
          for (var e in element) {
            if (e.category == category) {
              ind++;
              highLigthsCatImages.add(e);
              break;
            }
          }
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    } else {
      print('Response status: ${response.statusCode}');

      print('Failed to load data');
    }
  }
}
class CategoryModel {
  int? id;
  String? title;
  String? color;

  CategoryModel({this.id, this.title, this.color});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['color'] = this.color;
    return data;
  }
}