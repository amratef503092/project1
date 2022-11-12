import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation_project/code/resource/routes_manager.dart';
import 'package:graduation_project/code/resource/theme_manager.dart';
import 'package:graduation_project/view/pages/auth/login_screen.dart';
import 'package:graduation_project/view/pages/auth/register_screen.dart';
import 'package:graduation_project/view/pages/home_screens/home_screen.dart';
import 'package:graduation_project/view/pages/splash_screen.dart';
import 'package:graduation_project/view_model/bloc/approve/approve_cubit.dart';
import 'package:graduation_project/view_model/bloc/auth/auth_cubit.dart';
import 'package:graduation_project/view_model/bloc/layout/layout__cubit.dart';
import 'package:graduation_project/view_model/bloc/layout_admin/layout_admin_cubit.dart';
import 'package:graduation_project/view_model/bloc/pharmacy_product/pharmacy_cubit.dart';
import 'package:graduation_project/view_model/bloc/search_screen/search_screen_cubit.dart';
import 'package:graduation_project/view_model/bloc/services/services_cubit.dart';
import 'package:graduation_project/view_model/bloc/user_cubit/user_cubit.dart';
import 'package:graduation_project/view_model/database/local/cache_helper.dart';

import 'code/BlocObserver.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [

            BlocProvider(create: (context) => ApproveCubit(),),
            BlocProvider(create: (context) => AuthCubit()..getUserData(),),
            BlocProvider(create: (context) => PharmacyCubit(),),
            BlocProvider(create: (context) => ServicesCubit()..getServices(),),
            BlocProvider(create: (context) => UserCubit(),),
            BlocProvider(create: (context) => LayoutCubit()),
            BlocProvider(create: (context) => LayoutAdminCubit()),
            BlocProvider(create: (context) => SearchScreenCubit(),)

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: getTheme(),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
