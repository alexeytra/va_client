import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отзыв',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: [
              Text(
                'Здесь вы можете отправить отзыв, предложение или идеи для улучшения',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 70.0),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLength: 100,
                maxLines: 10,
                controller: reviewController,
                decoration: InputDecoration(
                    hintText: 'Введите ваш тект здесь...',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0))),
              ),
              SizedBox(height: 70.0),
              Material(
                borderRadius: BorderRadius.circular(16.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.orangeAccent.shade100,
                child: MaterialButton(
                  onPressed: () {},
                  minWidth: 200.0,
                  height: 42.0,
                  color: Colors.blueGrey,
                  child: Text(
                    'Отправить',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}