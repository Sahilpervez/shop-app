import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/AppUtils/styles.dart';
import 'package:shop_app/Model/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.order}) : super(key: key);

  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "\$${widget.order.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppStyle.defaultText),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: AppStyle.defaultText,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                  _expanded ? Icons.expand_less_rounded : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(15),
              height: min(widget.order.products.length * 30 + 25, 180),
              child: ListView(
                children: [
                  ...widget.order.products
                      .map(
                        (e) => Row(
                          children: [
                            Text(
                              "${e.title}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStyle.defaultText,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${e.quantity}x \$${e.price}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStyle.defaultText,
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
