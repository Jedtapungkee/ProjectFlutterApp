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

  @override
  void initState() {
    super.initState();
    _recommendedMeal = _mealService.fechMultipleRandomMeals(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Meal'),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: _recommendedMeal,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No recommended meals found.'),
              );
            } else {
              final meals = snapshot.data!;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                padding: const EdgeInsets.all(10),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailScreen(meal: meal),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
          }),
    );
  }
}
