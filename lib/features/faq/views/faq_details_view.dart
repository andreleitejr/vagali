// Página de Detalhes
import 'package:flutter/material.dart';
import 'package:vagali/features/faq/models/faq_topic.dart';

class FaqDetailPage extends StatelessWidget {
  final FaqTopic topic;

  FaqDetailPage(this.topic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.title),
      ),
      body: ListView.builder(
        itemCount: topic.subtopics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(topic.subtopics[index].title),
            subtitle: Text(topic.subtopics[index].description),
          );
        },
      ),
    );
  }
}
