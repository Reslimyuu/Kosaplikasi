import 'package:flutter/material.dart';

class CategoryIcons extends StatelessWidget {
  final List<String> imagePaths;
  final List<Color> colors;

  const CategoryIcons({
    super.key,
    required this.imagePaths,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(imagePaths.length, (index) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              imagePaths[index],
              height: 20,
              width: 20,
              alignment: Alignment.center,
            ),
          ),
        );
      }),
    );
  }
}
