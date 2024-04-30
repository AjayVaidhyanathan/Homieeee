
  /*void _checkProductOwnership() async {
    final isOwner = await isCurrentUserProduct(widget.productID!);
    setState(() {
      _isCurrentUserProduct = isOwner;
    });
  }

  void _reserveItem(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Handle not authenticated case

    try {
      // Create a new document in the 'reserved' collection
      final reservedDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('product_list')
          .doc(widget.productID)
          .collection('reserved')
          .doc();

      await reservedDocRef.set({
        'ownerId': currentUser.uid,
        'buyerId': widget.userId,
        'status': 'reserved',
        'reviewedbyBuyer': false,
        'reviewedbyOwner': false,
      });

      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .collection('product_list')
          .doc(widget.productID)
          .update({
        'reserved': true, // Set the reserved field to true
      });

      // Show success dialog on successful reservation
      _showReservationSuccessDialog(context);
    } catch (error) {
      // Handle potential errors during data storage
      print('Error reserving item: $error');
      // Consider showing an error message to the user
    }
  }





    void _showReserveConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(20.0), // Padding for title
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Padding for content
          title: const Text('Do you want to reserve this item for this user?'),
          content: const Text(
              'This will mark the item as reserved for this user and removes from the active listing.'), // Optional content area
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _beSuretoAgreeBeforeReserveDialog();
              }, // Close dialog on 'No'
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                print('Yes');
                Navigator.pop(context); // Close dialog on 'Yes' and reserve
                _showPickupConfirmationDialog();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showPickupConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pickup Confirmation'),
          content: const Text(
            'Have you and the other user agreed on a location and time for pickup?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAgreeBeforeReserveDialog(context);
              }, // Close dialog on 'No'
              child: const Text('No, not yet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, // Close dialog on 'Yes'
              child: const Text('Yes, confirmed'),
            ),
          ],
        );
      },
    );
  }

// All Dialog boxes
  void _showReservationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text('The product has been successfully reserved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _showAgreeBeforeReserveDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Agree Before Reserve'),
          content: const Text(
              'Please agree on a specific location and timing with the other user before making a reservation.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog manually
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _beSuretoAgreeBeforeReserveDialog() async {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent user from dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Besure before you reserve to the user'),
          content: const Text(
              'Please make sure that the user who gets your food is benefited.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog manually
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }
}

*/