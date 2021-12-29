// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/bloc/bloc.dart';
// import 'package:kmp_pengurus_app/features/bendahara/cash_book/presentation/pages/cash_book_screen.dart';
// import 'package:kmp_pengurus_app/features/bendahara/deposit/presentation/pages/deposit_page.dart';
// import 'package:kmp_pengurus_app/main.dart';
// import 'package:kmp_pengurus_app/service_locator.dart';

// class CashBookMenuScreen extends StatefulWidget {
//   const CashBookMenuScreen({Key? key}) : super(key: key);

//   @override
//   _CashBookMenuScreenState createState() => _CashBookMenuScreenState();
// }

// class _CashBookMenuScreenState extends State<CashBookMenuScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF8F8F8),
//       appBar: AppBar(
//         toolbarHeight: 80,
//         elevation: 0,
//         backgroundColor: Color(0xffF8F8F8),
//         automaticallyImplyLeading: false,
//         title: Padding(
//           padding: const EdgeInsets.only(
//             left: 5,
//             right: 5,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               InkWell(
//                 onTap: () {
//                   // Navigator.pop(context);
//                   Navigator.of(context).pushAndRemoveUntil(
//                       CupertinoPageRoute(
//                         builder: (BuildContext context) {
//                           return App();
//                         },
//                       ),
//                       (_) => false,
//                     );
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   height: 33,
//                   width: 33,
//                   decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           spreadRadius: 1.5,
//                           blurRadius: 15,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(16),
//                       color: Colors.white),
//                   child: SvgPicture.asset(
//                     "assets/icon/back.svg",
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 25),
//             child: Text(
//               "Buku Kas",
//               style: TextStyle(
//                   fontSize: 22,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w800,
//                   fontFamily: "Nunito"),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(left: 25),
//             child: Text(
//               "Kelola Buku Kas RT dan RW",
//               style: TextStyle(
//                   fontSize: 12,
//                   color: Color(0xff979797),
//                   fontWeight: FontWeight.w400,
//                   fontFamily: "Nunito"),
//             ),
//           ),
//           SizedBox(
//             height: 25,
//           ),
//           InkWell(
//             onTap: () {
//               var year = DateTime.now().year;
//               var month = DateTime.now().month;
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => BlocProvider(
//                             create: (context) => serviceLocator.get<CashBookBloc>(),
//                             child: ProgressHUD(
//                               child: CashBookScreen(
//                                 month: month,
//                                 year: year,
//                               ),
//                             ),
//                           )));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15),
//               child: Container(
//                 padding: EdgeInsets.only(left: 15, right: 21),
//                 height: 68,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           height: 46,
//                           width: 46,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               color: Color(0xff2FA9ED).withOpacity(0.1)),
//                           child: SvgPicture.asset("assets/icon/cash_book.svg"),
//                         ),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(
//                               "Buku Kas RW",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w800,
//                                   fontFamily: "Nunito"),
//                             ),
//                             Text(
//                               "Kelola Buku Kas RW",
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: Color(0xff121212),
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: "Nunito"),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     Icon(Icons.chevron_right)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => DepositPage()));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
//               child: Container(
//                 padding: EdgeInsets.only(left: 15, right: 21),
//                 height: 68,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(8),
//                           height: 46,
//                           width: 46,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(24),
//                               color: Color(0xff2FA9ED).withOpacity(0.1)),
//                           child: SvgPicture.asset("assets/icon/cash_book.svg"),
//                         ),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Text(
//                               "Buku Kas RT",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w800,
//                                   fontFamily: "Nunito"),
//                             ),
//                             Text(
//                               "Kelola Buku Kas RT",
//                               style: TextStyle(
//                                   fontSize: 10,
//                                   color: Color(0xff121212),
//                                   fontWeight: FontWeight.w400,
//                                   fontFamily: "Nunito"),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     Icon(Icons.chevron_right)
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
