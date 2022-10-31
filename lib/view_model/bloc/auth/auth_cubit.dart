import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/code/constants_value.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';
import 'package:meta/meta.dart';

import '../../../model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);
  UserModel? userModel;

  // login function start
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    userModel = null;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .update({'online': true});
      await CacheHelper.put(key: 'id', value: value.user!.uid);
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((value) {
        userModel = UserModel.fromMap(value.data()!);
        print(value['online']);
        emit(LoginSuccessfulState(
            role: value['role'], message: 'login success'));
      });
    }).catchError((onError) {
      emit(LoginErrorState('login Error'));
    });
  }

// login function end
  Future<void> register({
    required String email,
    required String password,
    required String phone,
    required String age,
    required String name,
    required String role,
  }) async {
    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userModel = UserModel(
          phone: phone,
          age: age,
          ban: false,
          email: email,
          id: value.user!.uid,
          online: false,
          photo: '',
          role: role,
          name: name);

      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .set(userModel!.toMap());
      emit(RegisterSuccessfulState('Register success'));
    }).catchError((onError) {
      emit(LoginErrorState('Register Error'));
    });
  }

  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {
      userModel = UserModel.fromMap(value.data()!);
      emit(GetUserDataSuccessfulState('data come true'));
    }).catchError((onError) {
      emit(GetUserDataErrorState('some Thing Error'));
    });
  }

  Future<void> update({
    required String email,
    required String phone,
    required String age,
    required String name,
    // required String role,
  }) async {
    emit(UpdateDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .update({
          'name': name,
          'phone': phone,
          'age': age,
          'email': email,
        })
        .then((value) {
      emit(UpdateDataSuccessfulState('done'));

    })
        .catchError((onError) {
          emit(UpdateDataErrorState('some thing Error'));
    });
  }
}
