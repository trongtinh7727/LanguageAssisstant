import 'package:flutter/material.dart';

class DiscoveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IIEX'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement your search action
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tiếp tục bài học trước',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Your 'Topic: Expressions/Questions on Classe' card here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Hôm nay làm gì?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Your list of activities here
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Gợi ý cho bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 150, // Adjust height accordingly
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Replace with the actual number of items
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  // Replace with actual data
                  child: Text("Texxt"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Cộng đồng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Your 'Community' section here
        ],
      ),
    );
  }
}
