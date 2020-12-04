import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hacker_news/story.dart';
import 'package:hacker_news/webservice.dart';

class TopArticleList extends StatefulWidget {
  @override
  _TopArticleListState createState() => _TopArticleListState();
}

class _TopArticleListState extends State<TopArticleList> {
  List<Story> _stories = List<Story>();

  @override
  void initState() {
    super.initState();
    _populateTopStories();
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hacker News"),
          backgroundColor: Colors.purple,
        ),
        body: ListView.builder(
          itemCount: _stories.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Center(
                  child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        _stories[index].title,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: Text('Score')),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(56))),
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                  "${_stories[index].commentIds.length}",
                                  style: TextStyle(color: Colors.white)),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
            );
          },
        ));
  }
}
