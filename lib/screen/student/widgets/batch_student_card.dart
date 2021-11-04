import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BatchStudentCard extends StatefulWidget {
  const BatchStudentCard({Key? key, required this.data}) : super(key: key);
  final QueryDocumentSnapshot<Object?> data;

  @override
  State<BatchStudentCard> createState() => _BatchStudentCardState();
}

class _BatchStudentCardState extends State<BatchStudentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            imageUrl: widget.data.get('imageUrl'),
            fadeInDuration: const Duration(milliseconds: 500),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset('assets/images/pp_placeholder.png')),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('assets/images/pp_placeholder.png')),
          ),
        ),
        title: Text(widget.data.get('name')),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: 'ID :  ',
                style: const TextStyle(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: widget.data.get('id'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            widget.data.get('hall') == '' ||
                    widget.data.get('hall') == 'Info not available'
                ? const Text('')
                : Text.rich(
                    TextSpan(
                      text: 'Hall :  ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: widget.data.get('hall'),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
        // isThreeLine: true,
      ),
    );
  }
}
