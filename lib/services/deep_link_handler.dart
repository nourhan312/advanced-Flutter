import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:deep_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkHandler {
  // Singleton pattern
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final AppLinks _appLinks = AppLinks();

  // Stream controller to broadcast parsed link information
  final _linkController = StreamController<DeepLinkData>.broadcast();
  Stream<DeepLinkData> get linkStream => _linkController.stream;

  Future<void> init() async {
    // 1. Get the initial link if the app was launched by one
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri);
      }
    } catch (e) {
      // Handle errors if any
      debugPrint('Error getting initial link: $e');
    }

    // 2. Listen for incoming links while the app is running
    _appLinks.uriLinkStream.listen(
      (uri) {
        _handleLink(uri);
      },
      onError: (err) {
        debugPrint('Error on link stream: $err');
      },
    );
  }

  void _handleLink(Uri uri) {
    debugPrint('Received Deep Link: $uri');

    // 1. Scenario: Product Page
    if (uri.pathSegments.contains('product')) {
      final id = uri.pathSegments.last;
      _linkController.add(
        DeepLinkData(type: DeepLinkType.product, data: "Product ID: $id"),
      );
    }
    // 2. Scenario: Search Page
    else if   (uri.pathSegments.contains('search')) {
      final query = uri.queryParameters['q'] ?? 'No Query';
      final filter = uri.queryParameters['filter'] ?? 'All';
      _linkController.add(
        DeepLinkData(
          type: DeepLinkType.search,
          data: "Search Results: $query ($filter)",
        ),
      );
    }
    // 3. Scenario: Promo Code -> Goes to First Screen
    else if (uri.pathSegments.contains('promo')) {
      final code = uri.pathSegments.last;
      _linkController.add(
        DeepLinkData(type: DeepLinkType.promo, data: "Promo Applied: $code"),
      );
    }
    // 4. Default
    else {
      _linkController.add(
        DeepLinkData(
          type: DeepLinkType.unknown,
          data: "Unknown Link: ${uri.path}",
        ),
      );
    }
  }

  void dispose() {
    _linkController.close();
  }
}


