import 'package:vagali/apps/tenant/features/home/models/tenant.dart';
import 'package:vagali/features/user/models/user.dart';
import 'package:vagali/features/user/repositories/user_repository.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class TenantRepository extends FirestoreRepository<Tenant>  {
  TenantRepository()
      : super(
    collectionName: 'users',
    fromDocument: (document) => Tenant.fromDocument(document),
  );
}
