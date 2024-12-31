import 'package:flutter/material.dart';
import 'package:todo/models/post_model.dart';

class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "User ID: ${post.userId}",
                      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    Text(
                      "ID: ${post.id}",
                      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 4.0),
            Text(
              post.body,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}