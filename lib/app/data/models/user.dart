// To parse this JSON data, do
//
//     final currentUser = currentUserFromJson(jsonString);
import 'package:marocsie/app/utils/api_helpers.dart';

User currentUserFromJson(dynamic str) => User.fromJson(str);

class User {
    String? id;
    String? username;
    String? email;
    String? firstName;
    String? lastName;
    String? phoneNumber;
    String? address;
    String? gender;
    String? profileImage;

    User({
        this.id,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.address,
        this.gender,
        this.profileImage,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"]?.toString() ?? json["id"]?.toString(),
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        gender: json["gender"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "address": address,
        "gender": gender,
        "profile_image": profileImage,
    };
}

class Document {
    String? documentType;
    String? documentUrl;
    String? filetype;
    String? id;

    Document({
        this.documentType,
        this.documentUrl,
        this.filetype,
        this.id,
    });

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        documentType: json["document_type"],
        documentUrl: json["document_url"],
        filetype: json["filetype"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "document_type": documentType,
        "document_url": documentUrl,
        "filetype": filetype,
        "_id": id,
    };
}

class Rating {
    int? rating;
    ReviewPatient? patient;
    String? review;
    String? id;

    Rating({
        this.rating,
        this.patient,
        this.review,
        this.id,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rating: json["rating"],
        patient: json["patient"] == null ? null : ReviewPatient.fromJson(json["patient"]),
        review: json["review"],
        id: json["_id"],
    );
}

class ReviewPatient {
    String? id;
    String? codeName;
    String? avatar;

    ReviewPatient({
        this.id,
        this.codeName,
        this.avatar,
    });

    factory ReviewPatient.fromJson(Map<String, dynamic> json) => ReviewPatient(
        id: json["_id"],
        codeName: json["code_name"],
        avatar: json["avatar"] ?? "${ApiHelpers.hostUrl}/static/male-avatars/13.png",
    );
}