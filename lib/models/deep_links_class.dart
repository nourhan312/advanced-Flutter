enum DeepLinkType { product, search, promo, unknown }

class DeepLinkData {
  final DeepLinkType type;
  final String data;

  DeepLinkData({required this.type, required this.data});
}