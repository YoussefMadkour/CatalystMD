/// All item categories and subcategories.
abstract final class CategoryConstants {
  static const categories = <String, List<String>>{
    'Electronics': ['Phones', 'Tablets', 'Laptops', 'Accessories', 'Cameras'],
    'Clothing': ['Men', 'Women', 'Kids', 'Shoes', 'Sportswear'],
    'Cosmetics': ['Skincare', 'Makeup', 'Fragrance', 'Haircare'],
    'Food': ['Snacks', 'Supplements', 'Coffee & Tea', 'Specialty'],
    'Documents': ['Letters', 'Certificates', 'Contracts'],
    'Medicine': ['Prescription', 'OTC', 'Supplements'],
    'Accessories': ['Jewelry', 'Watches', 'Bags', 'Sunglasses'],
    'Other': ['Books', 'Toys', 'Home', 'Miscellaneous'],
  };

  static List<String> get allCategories => categories.keys.toList();

  static List<String> subcategoriesFor(String category) {
    return categories[category] ?? [];
  }
}
