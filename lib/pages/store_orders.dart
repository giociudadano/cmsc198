part of '../main.dart';

// ignore: must_be_immutable
class StoreOrdersPage extends StatefulWidget {
  StoreOrdersPage(this.placeID, {super.key});

  String placeID = '';

  @override
  State<StoreOrdersPage> createState() => _StoreOrdersPageState();
}

class _StoreOrdersPageState extends State<StoreOrdersPage> {
  StreamSubscription? ordersListener;
  Map orders = {};

  void initOrdersListener() {
    FirebaseFirestore db = FirebaseFirestore.instance;

    ordersListener =
        db.collection("places").doc(widget.placeID).snapshots().listen((event) {
      db.collection("places").doc(widget.placeID).get().then((document) {
        if (document.exists) {
          List orderIDs = document.data()!['orders'].reversed.toList();
          for (String orderID in orderIDs) {
            db.collection("orders").doc(orderID).get().then((document) {
              if (document.exists) {
                if (mounted) {
                  setState(() {
                    orders[orderID] = document.data()!;
                  });
                }
              }
            });
          }
        }
      });
    });
  }

  void setOrderStatus(String orderID, String newStatus) {
    if (mounted) {
      setState(() {
        orders[orderID]['status'] = newStatus;
      });
    }
  }

  @override
  void initState() {
    initOrdersListener();
    super.initState();
  }

  @override
  void dispose() {
    ordersListener!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            key: UniqueKey(),
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              String key = orders.keys.elementAt(index);
              return OrderCard(key, orders[key], adminControls: true, setOrderStatusCallback: setOrderStatus);
            }),
      ),
    );
  }
}
