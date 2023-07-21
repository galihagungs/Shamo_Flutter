import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shamo/models/message_model.dart';
import 'package:shamo/models/product_model.dart';
import 'package:shamo/models/user_model.dart';

class MessageService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
  Stream<List<MessageModel>> getMessagesByUserId({required int userId}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot<Map<String, dynamic>> list) {
        var result = list.docs.map<MessageModel>(
            (DocumentSnapshot<Map<String, dynamic>> message) {
          print(message.data());
          return MessageModel.fromJson(message.data());
        }).toList();
        // var result = list.docs.map<MessageModel>(
        //     (DocumentSnapshot<Map<String, dynamic>> message) {
        //   print(message.data());
        //   return MessageModel.fromJson(message.data());
        // }).toList();

        // result.sort(
        //   (MessageModel a, MessageModel b) =>
        //       a.createdAt.compareTo(b.createdAt),
        // );
        // print(list);

        return result;
      });
      // return firestore
      //     .collection('messages')
      //     .where('userId', isEqualTo: userId)
      //     .snapshots()
      //     .map((QuerySnapshot message) {
      //   print(message);
      // });
    } catch (e) {
      throw Exception('Error : + $e');
    }
  }

  Future<void> addMessage(
      {required UserModel user,
      required bool isFromUser,
      required String message,
      required ProductModel product}) async {
    try {
      firestore.collection('messagges').add({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UninitializedProductModel ? {} : product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then((value) => print('Pesan Berhasil Dikirim!'));
    } catch (e) {
      throw Exception('Pesan Gagal Dikirim');
    }
  }
}
