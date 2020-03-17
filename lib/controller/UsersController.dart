import 'package:api_moviles/api_moviles.dart';
import 'package:api_moviles/model/Users.dart';

class UsersController extends ResourceController{
  UsersController(this.context, this.authServer);
  final ManagedContext context;
  final AuthServer authServer;

  @Operation.get()
  Future<Response> getUsers() async{
    final query = Query<User>(context);
    final res = await query.fetch();
    return Response.ok(res);
  }

  @Operation.get('idUser')
  Future<Response> getUserById(@Bind.path('idUser') int idAct) async{
    final query = Query<User>(context)..where((a)=>a.id).equalTo(idAct);
    final res = await query.fetch();
    if(res==null){
      return Response.notFound();
    }
    return Response.ok(res);
  }

  @Operation.post('username')
  Future<Response> loginUser(@Bind.body() User user, @Bind.path('username') String username) async {
    String token = "No Token";
    if(user.username==null || user.password==null || user.username!=username){
      return Response.badRequest(
        body:{"error": "Username and Password required."}
      );
    }
    try {
      final autenticado = await authServer.authenticate(user.username, user.password, "com.classroom.patm","");
      token = autenticado.accessToken;
      return Response.ok(token);
    } catch (e) {
      print(e);
      return Response.forbidden(body: {"error": "Not authenticaded"});
    }
  }

  @Operation.post()
  Future<Response> insertUser(@Bind.body() User user) async{
    if(user.username==null || user.password==null){
      return Response.badRequest(
        body:{"error": "Username and Password required."}
      );
    }
    user
      ..salt=AuthUtility.generateRandomSalt()
      ..hashedPassword=authServer.hashPassword(user.password, user.salt);
    return Response.ok(
      await Query(context, values: user).insert()
    );
  }

  @Operation.put('idUser')
  Future<Response> updateUser(@Bind.path('idUser') int idAct) async{
    final advertisement = User()..read(await request.body.decode());
    final query = Query<User>(context)..where((a)=>a.id).equalTo(idAct)..values=advertisement;
    final res = await query.updateOne();
    return Response.ok(res);
  }

  @Operation.delete('idUser')
  Future<Response> deleteUser(@Bind.path('idUser') int idAct) async{
    final query = Query<User>(context)..where((a)=>a.id).equalTo(idAct);
    final res = await query.delete();
    return Response.ok(res);
  }
}
