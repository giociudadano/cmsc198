part of main;

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard(
      {super.key,
      required this.id,
      required this.productName,
      required this.placeName,
      required this.productPrice});
  String productName, productImageURL = '', placeName, id;
  int productPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void getProductImageURL() async {
    String url = '';
    String ref = "products/${widget.id}.jpg";
    try {
      url = await FirebaseStorage.instance.ref(ref).getDownloadURL();
    } catch (e) {
      //
    } finally {
      if (mounted) {
        setState(() {
          widget.productImageURL = url;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getProductImageURL();
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: MaterialColors.getSurfaceContainerLowest(darkMode),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 25),
      child: SizedBox(
        height: 140,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.productImageURL),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 15, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          "https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000",
                          width: 32,
                          height: 32,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.placeName,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontFamily: 'Bahnschrift',
                                  fontVariations: const [
                                    FontVariation('wght', 400),
                                    FontVariation('wdth', 100),
                                  ],
                                  fontSize: 13,
                                  letterSpacing: -0.3),
                            ),
                            Text(
                              widget.productName,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontFamily: 'Bahnschrift',
                                fontVariations: const [
                                  FontVariation('wght', 700),
                                  FontVariation('wdth', 100),
                                ],
                                fontSize: 16,
                                letterSpacing: -0.3,
                                height: 0.8,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Text(
                      '₱${widget.productPrice}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontFamily: 'Bahnschrift',
                          fontVariations: const [
                            FontVariation('wght', 700),
                            FontVariation('wdth', 100),
                          ],
                          fontSize: 16,
                          letterSpacing: -0.3),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}