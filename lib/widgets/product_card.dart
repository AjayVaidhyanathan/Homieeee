import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:homieeee/widgets/product_details.dart';

class ProductContainer extends StatelessWidget {
  ProductContainer({super.key});

  final Query<Map<String, dynamic>> _query =
      FirebaseFirestore.instance.collectionGroup('active');
  Future<Map<String, dynamic>> _fetchUserData(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userData.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: _query.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 2,
                      mainAxisExtent: 320),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final QueryDocumentSnapshot document =
                        documents[index]; // Access the document
                    final String docID = document.id; // Extract the document ID
                    final Map<String, dynamic> thisItem =
                        documents[index].data() as Map<String, dynamic>;
                      return FutureBuilder<Map<String, dynamic>>(
                          future: _fetchUserData(thisItem['uid']),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final userData = userSnapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: ProductCard(
                                  image: thisItem['img'],
                                  location:
                                      '${thisItem['lat']},${thisItem['lng']}',
                                  title: thisItem['title'],
                                  name: userData['displayName'],
                                  uid: thisItem['uid'],
                                  description: thisItem['description'],
                                  productID: docID,
                                  email: thisItem['email'],
                                  address: thisItem['location'],
                                  photoURL: userData['img'],
                                  cookedDate: thisItem['cooked_date']),
                            );
                          });
                    
                  });
            }
            return const Center(child: Text('No data available'));
          }),
    );
  }
}

// ignore: must_be_immutable
class ProductCard extends StatelessWidget {
  ProductCard({
    this.email,
    this.photoURL,
    this.image,
    this.location,
    this.address,
    this.name,
    this.title,
    this.uid,
    this.description,
    this.productID,
    this.cookedDate,
    super.key,
  });

  String? image;
  String? photoURL;
  String? email;
  String? title;
  String? location;
  String? name;
  String? uid;
  String? productID;
  String? description;
  String? address;
  String? cookedDate;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Product ID $productID & $photoURL & the uid $uid');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetails(
                    img: image,
                    title: title,
                    location: location,
                    name: name,
                    uid: uid,
                    productID: productID,
                    description: description,
                    address: address,
                    photoURL: photoURL,
                  )),
        );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 220,
            decoration: BoxDecoration(boxShadow: const [
              BoxShadow(
                blurRadius: 1,
                color: Colors.grey,
                offset: Offset(1, 1),
              )
            ], borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                image!,
                                width: 190,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 10, 0, 0),
                              child: Container(
                                width: 70,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.kitchen,
                                      color: Color(0xFFEDA44C),
                                      size: 16,
                                    ),
                                    Text(cookedDate!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 20, 0),
                  child: Text(title!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 15,
                        color: Colors.red,
                      ),
                      Text(address!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              name!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: primaryColor.withOpacity(.25),
              backgroundImage: Image.network(photoURL!).image,
            ),
          ),
        ],
      ),
    );
  }
}
