import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:va_client/models/navigation.dart';
import 'package:va_client/utils/api_manager.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final reviewController = TextEditingController();
  double rating = 5.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
              SizedBox(height: 30.0),
              Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: Colors.red,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: Colors.redAccent,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied,
                          color: Colors.lightGreen,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.green,
                        );
                      default:
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                    }
                  },
                  onRatingUpdate: (rating) {
                    setState(() {
                      this.rating = rating;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.0),
              Material(
                borderRadius: BorderRadius.circular(16.0),
                clipBehavior: Clip.antiAlias,
                shadowColor: Colors.orangeAccent.shade100,
                child: MaterialButton(
                  onPressed: () {
                    APIManager.sendUserReview({'review': reviewController.text, 'rating': rating});
                    scaffoldKey.currentState.showSnackBar(_showSendSnackBar());
                    setState(() {
                      reviewController.text = '';
                      rating = 5.0;
                    });
                    Future.delayed(Duration(seconds: 2)).then((_) =>
                        Keys.navKey.currentState.pushNamed(Routes.homeScreen));
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  color: Colors.blueGrey,
                  child: Text(
                    'Отправить',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
      ),
    );
  }

  SnackBar _showSendSnackBar() {
    return SnackBar(
      content: const Text(
        'Спасибо! Ваш отзыв отправлен.',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 2500),
      width: 300.0,
      // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }
}