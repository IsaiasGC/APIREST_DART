import 'package:api_moviles/api_moviles.dart';
import 'package:api_moviles/model/Users.dart';

class UserType extends ManagedObject<tblUserType> implements tblUserType{}
class tblUserType{

  @primaryKey
  int id;

  @Column(unique: true)
  String description;

  ManagedSet<User> fktypeuser;
}
