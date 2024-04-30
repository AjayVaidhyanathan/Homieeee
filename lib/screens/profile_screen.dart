import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homieeee/auth/auth_service.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:homieeee/widgets/edit_profile.dart';
import 'package:homieeee/widgets/product_details.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: const BottomBody(),
    );
  }

  appBarMethod(context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(76),
      child: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        backgroundColor: scaffoldColor,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        elevation: 0,
        flexibleSpace: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(20).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorF9,
                child: Image.asset(
                  settingIcon,
                  height: 2.5.h,
                ),
              ),
              Text('Profile', style: blackBold18),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfilePage()),
                  );
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colorF9,
                  child: Image.asset(
                    editPenIcon,
                    height: 2.5.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomBody extends StatefulWidget {
  const BottomBody({super.key});

  @override
  State<BottomBody> createState() => _BottomBodyState();
}

class _BottomBodyState extends State<BottomBody> with TickerProviderStateMixin {
  String? _userEmail;
  String? _userDisplayName;
  String? _userPhotoURL;
  late TabController tabController;

  Future<void> _getUserData() async {
    _userEmail = await AuthService().getUserEmail();
    _userDisplayName = await AuthService().getUserDisplayName();
    _userPhotoURL = await AuthService().getPhotoURL();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: primaryColor.withOpacity(.25),
            backgroundImage: Image.network(_userPhotoURL!).image,
          ),
          heightSpace15,
          Text(_userDisplayName!, style: blackSemiBold17),
          heightSpace5,
          Text(_userEmail!, style: color8ARegular15),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              'View Profile',
              style: TextStyle(
                  color: primaryColor,
                  fontFamily: 'M',
                  fontSize: 11.2.sp,
                  decoration: TextDecoration.underline),
            ),
          ),
          TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                text: 'Offerings',
              ),
              Tab(
                text: 'Received',
              ),
              Tab(
                text: 'Reserved',
              )
            ],
            labelColor: Colors.black,
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: const [
              ProfileOffered(),
              Text('2'),
              ReservedProfileContainer(),
            ],
          ))
        ],
      ),
    );
  }
}

class ProfileOffered extends StatelessWidget {
  const ProfileOffered({Key? key});

  Future<Map<String, dynamic>> _fetchUserData(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userData.data() as Map<String, dynamic>;
  }

  Stream<QuerySnapshot> getAllActiveCollectionsStream() async* {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    yield* FirebaseFirestore.instance
        .collectionGroup('active')
        .orderBy('uid', descending: false)
        .orderBy('cooked_date', descending: false)
        .where('uid', isEqualTo: myUid) // Filter by current user's UID
        .snapshots(); // Replace with your actual group name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllActiveCollectionsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          print(documents);
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1,
              crossAxisSpacing: 2,
              mainAxisExtent: 200,
            ),
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final QueryDocumentSnapshot document = documents[index];
              final String docID = document.id;
              final Map<String, dynamic> thisItem =
                  document.data() as Map<String, dynamic>;
              return FutureBuilder<Map<String, dynamic>>(
                  future: _fetchUserData(thisItem['uid']),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final userData = userSnapshot.data!;
                    return CardView(
                      image: thisItem['img'],
                      location: '${thisItem['lat']},${thisItem['lng']}',
                      title: thisItem['title'],
                      name: userData['displayName'],
                      uid: thisItem['uid'],
                      description: thisItem['description'],
                      productID: docID,
                      email: thisItem['email'],
                      address: thisItem['location'],
                      photoURL: userData['img'],
                      cookedDate: thisItem['cooked_date'],
                      reserved: thisItem['reserved'],
                      reservedTo: thisItem['reserved_to'],
                    );
                  });
            },
          );
        },
      ),
    );
  }
}

class ReservedProfileContainer extends StatelessWidget {
  const ReservedProfileContainer({super.key});

  Future<Map<String, dynamic>> _fetchUserData(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return userData.data() as Map<String, dynamic>;
  }

  Stream<QuerySnapshot> getAllReservedCollectionsStream() async* {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    yield* FirebaseFirestore.instance
        .collectionGroup('reserved')
        .where('uid', isEqualTo: myUid)
        .where('reserved_to', isEqualTo: myUid)
        .orderBy('uid', descending: false)
        .orderBy('cooked_date', descending: false)
// Filter by current user's UID
        .snapshots(); // Replace with your actual group nameF
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: getAllReservedCollectionsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available'));
              }
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1,
                    crossAxisSpacing: 2,
                    mainAxisExtent: 200,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final QueryDocumentSnapshot document = documents[index];
                    final String docID = document.id;
                    final Map<String, dynamic> thisItem =
                        document.data() as Map<String, dynamic>;
                    return FutureBuilder<Map<String, dynamic>>(
                        future: _fetchUserData(thisItem['uid']),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (userSnapshot.hasError) {
                            return Center(
                                child: Text('Error: ${userSnapshot.error}'));
                          }
                          if (!userSnapshot.hasData) {
                            return const Center(
                                child: Text('No user data available'));
                          }
                          final userData = userSnapshot.data!;
                          return CardView(
                            image: thisItem['img'],
                            location: '${thisItem['lat']},${thisItem['lng']}',
                            title: thisItem['title'],
                            name: userData['displayName'],
                            uid: thisItem['uid'],
                            description: thisItem['description'],
                            productID: docID,
                            email: thisItem['email'],
                            address: thisItem['location'],
                            photoURL: userData['img'],
                            cookedDate: thisItem['cooked_date'],
                            reserved: thisItem['reserved'],
                            reservedTo: thisItem['reserved_to'],
                          );
                        });
                  });
            }));
  }
}

// ignore: must_be_immutable
class CardView extends StatelessWidget {
  CardView({
    super.key,
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
    this.reserved,
    this.cookedDate,
    this.reservedTo,
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
  bool? reserved;
  String? reservedTo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4, // Adjust the elevation for the shadow effect
        shadowColor: Colors.black,
        // Optional: specify the shadow color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Optional: adjust the border radius
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image goes here,
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(image!),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address!,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(title!),
                      Text(description!),
                      const SizedBox(height: 10),
                    ],
                  ),
                  PopupMenuButton(
                      itemBuilder: (context) =>
                          [const PopupMenuItem(child: Text('data'))])
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
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
                                photoURL: photoURL),
                          ),
                        );
                      },
                      child: const Text('View Details')),
                  reserved == true
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        const Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                              'Did you offered your food to the reserved user?'),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setOfferedForProduct(
                                                      context, productID!);
                                                },
                                                child: const Text('Yes')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'))
                                          ],
                                        )
                                      ],
                                    ));
                          },
                          child: const Text('Offered'))
                      : Container(),
                  ElevatedButton(onPressed: () {}, child: const Text('Delete')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> setOfferedForProduct(
    BuildContext context, String productID) async {
  try {
    // Get the current user's UID
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUID != null) {
      // Set 'offered' to true for the product in the user's product_list document
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserUID)
          .collection('product_list')
          .doc(productID)
          .update({'offered': true});

      // Provide feedback to the user that the product has been offered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product offered successfully.'),
        ),
      );
    } else {
      // Handle the case when the current user is not authenticated
      // You can prompt the user to log in or handle it based on your app's requirements
    }
  } catch (error) {
    // Handle any errors that occur during the operation
    print('Error setting offered for product: $error');
    // Provide feedback to the user about the error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to offer product. Please try again later.'),
      ),
    );
  }
}

class ReviewPopup extends StatefulWidget {
  ReviewPopup({super.key, required this.receiverID});

  String? receiverID;

  @override
  _ReviewPopupState createState() => _ReviewPopupState();
}

class _ReviewPopupState extends State<ReviewPopup> {
  double _rating = 0.0;
  TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text('Leave a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rate your experience:'),
            const SizedBox(height: 8.0),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 48.0,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text('Add a review:'),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your review here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform some action with the rating and review, e.g., submit them
              print('Rating: $_rating');
              print('Review: ${_reviewController.text}');
              addReview(_reviewController.text, _rating,
                  widget.receiverID.toString());
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

Future<void> addReview(String review, double rating, String receiverID) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create a reference to the reviews collection under the user's document
      CollectionReference reviewCollection = FirebaseFirestore.instance
          .collection('Users')
          .doc(receiverID)
          .collection('reviews');

      // Add the review and rating to a new document
      await reviewCollection.add({
        'review': review,
        'rating': rating,
      });
    } else {
      throw Exception('User is not authenticated.');
    }
  } catch (e) {
    print('Error adding review: $e');
  }
}
