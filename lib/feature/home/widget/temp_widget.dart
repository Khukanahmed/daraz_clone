import 'package:flutter/material.dart';

class TemperatureModule extends StatelessWidget {
  final double temperature;

  const TemperatureModule({super.key, required this.temperature});

  Color getTemperatureColor(double temp) {
    if (temp <= 15) {
      return Colors.blue;
    } else if (temp <= 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  /// Thermometer fill height
  double getFillHeight(double temp) {
    return (temp.clamp(0, 45) / 45) * 90;
  }

  @override
  Widget build(BuildContext context) {
    final Color tempColor = getTemperatureColor(temperature);
    final double fillHeight = getFillHeight(temperature);

    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(25),
          left: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperature.toInt().toString(),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          color: tempColor,
                          height: 1,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 18,
                          color: tempColor,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Module\nTemperature',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: 60,
            height: 120,
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: SizedBox(
                    width: 25,
                    height: 120,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0.5,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF424242),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: tempColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        // Tube (upore layer - draws over bulb)
                        Positioned(
                          bottom: 20,
                          left: 5.5,
                          child: Container(
                            width: 14,
                            height: 96,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xFF424242),
                                  width: 1.5,
                                ),
                                left: BorderSide(
                                  color: Color(0xFF424242),
                                  width: 1.5,
                                ),
                                right: BorderSide(
                                  color: Color(0xFF424242),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 2,
                                  right: 2,
                                  child: Container(
                                    width: 10,
                                    height: fillHeight,
                                    decoration: BoxDecoration(
                                      color: tempColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Temperature Labels
                _tempLabel('45°C', 0),
                _tempLabel('30°C', 30),
                _tempLabel('15°C', 60),
                _tempLabel('0°C', 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tempLabel(String text, double top) {
    return Positioned(
      left: 0,
      top: top,
      child: Text(text, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
    );
  }
}
