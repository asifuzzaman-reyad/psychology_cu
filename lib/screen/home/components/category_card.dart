import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {required this.title, required this.color, required this.routeName});
  final String title;
  final Color color;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 1,
            // offset: Offset(1, 2), // changes position of shadow
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: FloatingActionButton(
              heroTag: routeName,
              onPressed: () {
                Navigator.pushNamed(context, routeName);
              },
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
