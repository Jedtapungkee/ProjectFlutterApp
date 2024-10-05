import '../database/serviceAPI.dart';
import 'package:flutter/material.dart';
import '../pages/MealDetail.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  final MealService _mealService = MealService();
  late Future<List<dynamic>> _recommendedMeal;
  List<dynamic> _allMeals = [];
  List<dynamic> _filteredMeals = [];
  List<String> _selectedIngredients = [];
  final List<String> _availableIngredients =
      []; // รายการวัตถุดิบที่สามารถเลือกได้
  bool _showIngredients = false; // ตัวแปรเพื่อควบคุมการแสดงผลของแถบวัตถุดิบ

  @override
  void initState() {
    super.initState();
    _recommendedMeal = _mealService.fechMultipleRandomMeals(10);
    _recommendedMeal.then((meals) {
      setState(() {
        _allMeals = meals;
        _filteredMeals = meals;
        _extractAvailableIngredients(meals); // ดึงรายการวัตถุดิบ
      });
    });
  }

  void _extractAvailableIngredients(List<dynamic> meals) {
    for (var meal in meals) {
      for (int i = 1; i <= 20; i++) {
        String ingredientKey = 'strIngredient$i';
        if (meal[ingredientKey] != null && meal[ingredientKey].isNotEmpty) {
          if (!_availableIngredients.contains(meal[ingredientKey])) {
            _availableIngredients.add(meal[ingredientKey]);
          }
        }
      }
    }
  }

  void _filterMeals() {
    setState(() {
      if (_selectedIngredients.isEmpty) {
        _filteredMeals = _allMeals;
      } else {
        _filteredMeals = _allMeals.where((meal) {
          for (String ingredient in _selectedIngredients) {
            bool hasIngredient = false;
            for (int i = 1; i <= 20; i++) {
              String ingredientKey = 'strIngredient$i';
              if (meal[ingredientKey] != null &&
                  meal[ingredientKey] == ingredient) {
                hasIngredient = true;
                break;
              }
            }
            if (!hasIngredient)
              return false; // ถ้าไม่มีวัตถุดิบที่เลือกในเมนูนี้
          }
          return true;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Meal'),
      ),
      body: Column(
        children: [
          // ปุ่มค้นหา
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showIngredients = !_showIngredients; // เปลี่ยนสถานะการแสดงผล
                });
                _filterMeals(); // เรียกใช้การกรองเมนูใหม่เมื่อกดค้นหา
              },
              child: Text(_showIngredients ? 'ซ่อนวัตถุดิบ' : 'แสดงวัตถุดิบที่ต้องการค้นหา'),
            ),
          ),
          // แสดงรายการวัตถุดิบที่สามารถเลือกได้
          if (_showIngredients)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                children: _availableIngredients.map((ingredient) {
                  return FilterChip(
                    label: Text(ingredient),
                    selected: _selectedIngredients.contains(ingredient),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedIngredients.add(ingredient);
                        } else {
                          _selectedIngredients.remove(ingredient);
                        }
                        _filterMeals(); // เรียกใช้การกรองเมนูใหม่
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _recommendedMeal,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || _filteredMeals.isEmpty) {
                  return const Center(
                    child: Text('No recommended meals found.'),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: _filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _filteredMeals[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MealDetailScreen(meal: meal),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(meal['strMealThumb'],
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.cover),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal['strMeal'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        meal['strCategory'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        meal['strArea'],
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
