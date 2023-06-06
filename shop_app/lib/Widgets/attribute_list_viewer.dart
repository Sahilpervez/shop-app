import 'dart:math';

import 'package:flutter/material.dart';

class AttributeListViewer extends StatelessWidget {
  const AttributeListViewer({
    super.key, required this.e, required this.constraints,
  });
  final MapEntry<String,dynamic> e;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: min(
          e.value.length * 50.toDouble(), 150),
      child: ListView(
        children: [
          ...e.value.map((ele) {
            return Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8,
                        right: 8),
                    child: Icon(Icons.circle,
                        size: 10),
                  ),
                  SizedBox(
                    width: constraints.maxWidth *
                        0.8,
                    child: Text(
                      ele,
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}