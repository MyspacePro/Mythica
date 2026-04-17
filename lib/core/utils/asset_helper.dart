import 'package:flutter/material.dart';
/// Asset helper to manage all asset paths safely
class AssetHelper {
  // Books
  static const String bookCover1 = 'assets/books/Book1.png';
  static const String bookCover2 = 'assets/books/Book2.png';
  static const String bookCover3 = 'assets/books/Book3.png';
  static const String bookCover4 = 'assets/books/Book4.png';
  static const String bookCover5 = 'assets/books/Book5.png';

  // Banners
  static const String banner1 = 'assets/banners/banner1.jpg';
  static const String banner2 = 'assets/banners/banner2.jpg';
  static const String banner3 = 'assets/banners/banner3.jpg';

  // Profile
  static const String maleProfile = 'assets/profile/male.png';
  static const String femaleProfile = 'assets/profile/female.png';

  // PDFs
  static const String pdfBook1 = 'assets/original/book1.pdf';
  static const String pdfBook2 = 'assets/original/book2.pdf';

  // List of all book covers
  static const List<String> allBookCovers = [
    bookCover1,
    bookCover2,
    bookCover3,
    bookCover4,
    bookCover5,
  ];

  // List of all banners
  static const List<String> allBanners = [
    banner1,
    banner2,
    banner3,
  ];

  /// Safe image widget loader
  static Widget loadImage({
    required String assetPath,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    Widget image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }

  /// Safe network/asset image loader (hybrid)
  static Widget loadImageFromUrl({
    required String url,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    Widget image;

    if (url.startsWith('http')) {
      image = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _errorPlaceholder(width, height, borderRadius);
        },
      );
    } else {
      image = Image.asset(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _errorPlaceholder(width, height, borderRadius);
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: image,
      );
    }

    return image;
  }

  static Widget _errorPlaceholder(
    double width,
    double height,
    BorderRadius? borderRadius,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}