import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {

  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;


  //Service Category Backend

  Stream<QuerySnapshot> fetchCategoryData() {
    return fireStore.collection('category').snapshots();
  }

  Future<DocumentReference> insertCategoryData(
      {required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> documentReference = await fireStore
        .collection('category').add(data);

    return documentReference;
  }

  Future<void> updateCategoryData(
      {required Map<String, dynamic> data, required String id}) async {
    await fireStore.collection('category').doc(id).update(data);
  }

  Future<void> deleteCategoryData({required String id}) async {
    await fireStore.collection('category').doc(id).delete();
  }


  //Employee Backend

  Future<DocumentReference> insertEmployeeData(
      {required Map<String, dynamic> data}) async {
    DocumentReference<Map<String, dynamic>> documentReference = await fireStore
        .collection('employee').add(data);

    return documentReference;
  }

  Stream<QuerySnapshot> fetchEmployeeData() {
    return fireStore.collection('employee').snapshots();
  }

  Future<void> updateEmployeeData(
      {required Map<String, dynamic> data, required String id}) async {
    await fireStore.collection('employee').doc(id).update(data);
  }

  Future<void> deleteEmployeeData({required String id}) async {
    await fireStore.collection('employee').doc(id).delete();
  }


  //User Backed

  Future<DocumentReference> insertUserData({required Map<String,  dynamic> data}) async{

    DocumentReference<Map<String, dynamic>> documentReference = await fireStore
        .collection('user').add(data);

    return documentReference;
  }

  Stream<QuerySnapshot> fetchUserData() {
    return fireStore.collection('user').snapshots();
  }

  Future<void> updateUserData(
      {required Map<String, dynamic> data, required String id}) async {
    await fireStore.collection('user').doc(id).update(data);
  }

  Future<void> deleteUserData({required String id}) async {
    await fireStore.collection('user').doc(id).delete();
  }

}