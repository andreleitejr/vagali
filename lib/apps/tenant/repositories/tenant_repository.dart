import 'package:vagali/apps/tenant/models/tenant.dart';
import 'package:vagali/repositories/firestore_repository.dart';

class TenantRepository extends FirestoreRepository<Tenant>  {
  TenantRepository()
      : super(
    collectionName: 'users',
    fromDocument: (document) => Tenant.fromDocument(document),
  );
}
