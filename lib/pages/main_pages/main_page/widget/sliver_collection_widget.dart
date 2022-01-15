import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/audio_collections_page.dart';

class SliverCollectionsWidget extends StatelessWidget {
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const SliverCollectionsWidget(
      {Key? key,
      required this.img,
      required this.name,
      required this.displayName,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            CollectionsAudioPage.routeName,
            arguments: {
              'img': img,
              'displayName': displayName,
              'nameCollections': name,
              'description': description
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image:
                DecorationImage(image: NetworkImage(img!), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(
                    displayName!.length > 15
                        ? displayName!.substring(0, 15)
                        : displayName!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
