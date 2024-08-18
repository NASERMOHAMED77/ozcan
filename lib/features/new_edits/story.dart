import 'package:flutter/material.dart';
import 'package:flutter_almirtech_ecommerce/features/new_edits/model/story_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class MoreStories extends StatefulWidget {
  MoreStories({
    Key? key,
    required this.listofstories,
  }) : super(key: key);

  final List<StoriesModel> listofstories;

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          child: StoryView(
        storyItems: widget.listofstories.map((e) {
          if (e.content == "IMAGE") {
            return StoryItem.pageImage(
                url: e.lLinks!.self!.href.toString(),
                controller: storyController);
          } else {
            return StoryItem.pageVideo(e.lLinks!.self!.href.toString(),
                controller: storyController,duration: Duration(seconds: 30));
          }
        }).toList(),
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          Navigator.pop(context);
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      )),
    );
  }
}
