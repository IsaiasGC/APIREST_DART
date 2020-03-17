import 'package:api_moviles/model/Users.dart';
import 'package:aqueduct/managed_auth.dart';

import 'api_moviles.dart';
import 'controller/ActivitiesController.dart';
import 'controller/AdvertisementController.dart';
import 'controller/CommentActivityController.dart';
import 'controller/CommentAdvertisementController.dart';
import 'controller/CourseController.dart';
import 'controller/DeliveryController.dart';
import 'controller/ScheduleController.dart';
import 'controller/UsersController.dart';
import 'controller/UserTypeController.dart';
import 'model/Users.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class ApiMovilesChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  ManagedContext context;
  AuthServer authServer;
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistenStore = PostgreSQLPersistentStore.fromConnectionInfo("moviles", "moviles", "127.0.0.1", 5432, "classroom");

    final authStorage = ManagedAuthDelegate<User>(context);
    authServer = AuthServer(authStorage);
    context = ManagedContext(dataModel,persistenStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route("/example").linkFunction((request) async {
        return Response.ok({"key": "value"});
      });
    router.route("/activities[/:idActivity]").link(()=>ActivitiesController(context));
    router.route("/advertisements[/:idAdvertisement]").link(()=>AdvertisementController(context));
    router.route("/comments/activity[/:idCommentActivity]").link(()=>CommentActivityController(context));
    router.route("/comments/advertisement[/:idCommentAdvertisement]").link(()=>CommentAdvertisementController(context));
    router.route("/courses[/:idCourse]")
    //.link(()=>Authorizer.bearer(authServer))
    .link(()=>CourseController(context));
    router.route("/deliveries[/:idDelivery]").link(()=>DeliveryController(context));
    router.route("/schedules[/:idSchedule]").link(()=>ScheduleController(context));
    router.route("/users[/:idUser]").link(()=>UsersController(context, authServer));
    router.route("/user/login/:username").link(()=>UsersController(context,authServer));
    router.route("/user_types[/:idUserType]").link(()=>UserTypeController(context));

    return router;
  }
}
