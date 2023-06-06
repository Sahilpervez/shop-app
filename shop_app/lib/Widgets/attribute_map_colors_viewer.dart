import 'dart:math';

import 'package:flutter/material.dart';

class AttributeMapColorsViewer extends StatelessWidget {
  const AttributeMapColorsViewer({
    super.key, required this.e, required this.constraints,
  });

  final MapEntry<String,dynamic> e;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: min(
          (e.value.length + 1) * 50.toDouble(),
          150),
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              ...e.value.entries.map((ele) {
                return Container(
                  // padding: EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 20),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: min(
                            constraints.maxWidth *
                                0.40,
                            200),
                        child: Text(
                          "${ele.key} : ",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      // Icon(Icons.circle,color: ele.value,),
                      Container(
                        decoration: BoxDecoration(
                          color: ele.value,
                          shape: BoxShape.circle,
                        ),
                        height:
                        constraints.maxHeight *
                            0.045,
                        width: constraints.maxHeight *
                            0.045,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          )),
    );
  }
}