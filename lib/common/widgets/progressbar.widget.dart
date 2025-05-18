import 'package:flutter/material.dart';

class StockProgressBar extends StatelessWidget {
  final int quantity;
  final int maxQuantity;

  const StockProgressBar({
    super.key,
    required this.quantity,
    required this.maxQuantity,
  });

  List<Color> _getGradientColors(double percentage) {
    if (percentage == 1.0) {
      return [Colors.green, Colors.green];
    } else if (percentage <= 0.3) {
      return [Colors.red, Colors.deepOrange];
    } else if (percentage <= 0.6) {
      return [Colors.orange, Colors.amber];
    } else {
      return [Colors.green, Colors.lightGreen];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percentage =
        maxQuantity == 0 ? 0.0 : (quantity / maxQuantity).clamp(0.0, 1.0);
    final List<Color> gradientColors = _getGradientColors(percentage);

    return Tooltip(
      message: 'Available $quantity out of $maxQuantity',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 15,
          width: 100,
          color: Colors.grey[300],
          child: Stack(
            children: [
              if (maxQuantity > 0)
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                ),
              Center(
                child: Text(
                  '$quantity / $maxQuantity',
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
