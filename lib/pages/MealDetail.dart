import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  final dynamic meal;

  const MealDetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่าค่าคำสั่งการทำอาหารเป็น null หรือไม่ และแยกออกเป็นลิสต์
List<String> instructions = (meal['strInstructions']?.toString() ?? 'No instructions available')
    .split('.')
    .where((instruction) => instruction.trim().isNotEmpty)
    .toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(meal['strMeal'] ?? 'No Meal Name'),  // ตรวจสอบค่า null
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal['strMealThumb'] ?? 'https://via.placeholder.com/150',  // ถ้า null ใส่ลิงก์รูปภาพ placeholder
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              meal['strMeal'] ?? 'Unknown Meal',  // ถ้า null ใส่ข้อความแทน
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Category: ${meal['strCategory'] ?? 'Unknown Category'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              'Area: ${meal['strArea'] ?? 'Unknown Area'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Instructions:',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < instructions.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          instructions[i].trim(),
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              'Ingredients:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            for (int i = 1; i <= 20; i++)
              if (meal['strIngredient$i'] != null &&
                  meal['strIngredient$i'].isNotEmpty &&
                  meal['strMeasure$i'] != null && meal['strMeasure$i'].isNotEmpty)
                Row(
                  children: [
                    Image.network(
                      'https://www.themealdb.com/images/ingredients/${meal['strIngredient$i']}-Small.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${meal['strIngredient$i']}: ${meal['strMeasure$i'] ?? ''}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
