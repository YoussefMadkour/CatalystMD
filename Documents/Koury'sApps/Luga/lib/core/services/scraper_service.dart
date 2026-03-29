/// Product URL scraping via Edge Function.
class ScraperService {
  ScraperService._();

  static Future<ScrapedProduct?> scrapeUrl(String url) async {
    // TODO: Call Supabase Edge Function to scrape product URL
    throw UnimplementedError();
  }
}

class ScrapedProduct {
  const ScrapedProduct({
    required this.name,
    required this.price,
    this.imageUrl,
    this.description,
    this.weight,
  });

  final String name;
  final double price;
  final String? imageUrl;
  final String? description;
  final double? weight;
}
