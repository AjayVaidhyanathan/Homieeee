import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/new_chat/presentation/chatBetweenUsers.dart';
import 'package:homieeee/new_chat/provider/get_user_info_by_id_provider.dart';
import 'package:homieeee/utils/constants/constants.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  ProductDetails(
      {super.key,
      this.description,
      this.photoURL,
      this.img,
      this.location,
      this.name,
      this.title,
      this.uid,
      this.productID,
      this.address});

  String? title;
  String? description;
  String? img;
  String? photoURL;
  String? location;
  String? name;
  String? uid;
  String? productID;
  String? address;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F4F8),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 1,
                decoration: const BoxDecoration(
                  color: Color(0xffffffff),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: const BoxDecoration(
                            color: Color(0xffffffff),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                height: 400,
                                decoration: const BoxDecoration(
                                  color: Color(0xffffffff),
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.network(
                                          widget.img!,
                                          width: MediaQuery.sizeOf(context).width,
                                          height:
                                              400,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              30, 50, 20, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0x47878383),
                                                  Color(0xA0D8D4D4)
                                                ],
                                                stops: [0, 1],
                                                begin:
                                                    AlignmentDirectional(0, -1),
                                                end: AlignmentDirectional(0, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_back_ios,
                                              color: Color(0xffffffff),
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 252, 252, 252),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 30, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.title!,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 0,
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Icon(Icons.location_on),
                                        Text(widget.address!,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w300,
                                            )),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 0, 0),
                                    child: Text('Description',
                                        style: TextStyle(
                                            letterSpacing: 0, fontSize: 20)),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 20, 0),
                                            child: Text(widget.description!,
                                                style: const TextStyle(
                                                  color: Color(0xff57636C),
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 30, 0, 0),
                                    child: Text('Offerer',
                                        style: TextStyle(
                                            letterSpacing: 0, fontSize: 20)),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              primaryColor.withOpacity(.25),
                                          backgroundImage:
                                              Image.network(widget.photoURL!)
                                                  .image,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(widget.name!)
                                      ],
                                    ),
                                  ),
                                  BottomBar(
                                    id: widget.uid!,
                                    productId: widget.productID!,
                                    productTitle: widget.title!,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BottomBar extends ConsumerWidget {
  const BottomBar({
    super.key,
    required this.id,
    required this.productId,
    required this.productTitle
  });

  final String id;
  final String productId;
  final String productTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoPic = ref.watch(getUserInfoByIdProvider(id));
    return userInfoPic.when(
      data: (user) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  print('receiver id $id');
                  print(
                      'current userid ${AuthService().getCurrentUser()!.uid}');
                  print(productId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              userId: id,
                              imageurl: user.profilePicUrl,
                              productID: productId,
                              productTitle: productTitle,
                            )),
                  );
                },
                child: Container(
                  width: 270,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9A577E), Color(0xFF574977)],
                      stops: [0, 1],
                      begin: AlignmentDirectional(-0.34, 1),
                      end: AlignmentDirectional(0.34, -1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Text('Reserve it',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffffffff),
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
