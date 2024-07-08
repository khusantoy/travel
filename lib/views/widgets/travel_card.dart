import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel/models/travel.dart';

class TravelCard extends StatefulWidget {
  final Travel travel;

  const TravelCard({super.key, required this.travel});

  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // This is needed to keep the state alive
    return Card(
      key: ValueKey(widget.travel.id), // Use a unique key for each item
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.travel.imageUrl,
            placeholder: (context, url) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.travel.title,
                  style: const TextStyle(fontSize: 22),
                ),
                Text(widget.travel.location)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
