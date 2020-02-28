import 'package:api_moviles/api_moviles.dart';
import 'package:api_moviles/model/Users.dart';
import 'package:api_moviles/model/Activities.dart';

class CommentActivity extends ManagedObject<tblCommentActivity> implements tblCommentActivity{}
class tblCommentActivity{

  @primaryKey
  int id;

  String comment;
  DateTime datComActivity;


  @Relate(#fkactivities2)
  Activities idActivity;
  @Relate(#fkuser2)
  User idUser;
}
