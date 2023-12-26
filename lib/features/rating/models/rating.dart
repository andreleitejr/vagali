import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vagali/models/base_model.dart';

class Rating extends BaseModel {
  final double rating;
  final int numberOfRatings;
  final String reviewerId;
  final String? comment;

  Rating({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.rating,
    required this.numberOfRatings,
    required this.reviewerId,
    this.comment,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  Rating.fromDocument(DocumentSnapshot document)
      : rating = document['rating'],
        numberOfRatings = document['numberOfRatings'],
        reviewerId = document['reviewerId'],
        comment = document['comment'],
        super.fromDocument(document);

  @override
  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'numberOfRatings': numberOfRatings,
      'reviewerId': reviewerId,
      'comment': comment,
      ...super.toMap(),
    };
  }
}
