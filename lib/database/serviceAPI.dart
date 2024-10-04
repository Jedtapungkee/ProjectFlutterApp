import 'dart:convert';
import 'package:http/http.dart' as http;

class MealService {
  Future<List?> fetchMeals(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'];
    } else {
      throw Exception('Failed to load meals');
    }
  }

  // ดึงข้อมูลเมนูแนะนำหลายรายการแบบสุ่มม
  Future<List<dynamic>> fechMultipleRandomMeals(int count) async {
    List<dynamic> meals = [];

    for (int i = 0; i < count; i++) {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        meals.add(data['meals'][0]);
      } else {
        throw Exception('Failed to load meals');
      }
    }
    return meals;
  }
}
