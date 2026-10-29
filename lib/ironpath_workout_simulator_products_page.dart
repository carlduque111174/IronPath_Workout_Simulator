import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ProductItem {
  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.description,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final String description;
  final String imageUrl;

  bool get isService {
    final normalizedCategory = category.toLowerCase();
    return normalizedCategory == 'service' || normalizedCategory == 'program';
  }

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class IronPathWorkoutSimulatorProductsPage extends StatefulWidget {
  const IronPathWorkoutSimulatorProductsPage({super.key, this.client});

  final http.Client? client;

  @override
  State<IronPathWorkoutSimulatorProductsPage> createState() =>
      _IronPathWorkoutSimulatorProductsPageState();
}

class _IronPathWorkoutSimulatorProductsPageState
    extends State<IronPathWorkoutSimulatorProductsPage> {
  late Future<List<ProductItem>> _futureProducts;
  late final http.Client _client;
  late final bool _ownsClient;
  ProductFilter _selectedFilter = ProductFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _ownsClient = widget.client == null;
    _client = widget.client ?? http.Client();
    _futureProducts = _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (_ownsClient) _client.close();
    super.dispose();
  }

  Future<List<ProductItem>> _loadProducts() async {
    final response = await _client
        .get(Uri.parse('https://fakestoreapi.com/products'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Product API returned status ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    final apiProducts = decoded
        .map((item) => item as Map<String, dynamic>)
        .map(
          (item) => ProductItem(
            id: item['id'] as int,
            name: item['title'] as String,
            category: item['category'] as String,
            price: (item['price'] as num).toDouble(),
            rating: ((item['rating'] as Map<String, dynamic>)['rate'] as num)
                .toDouble(),
            stock: 20,
            description: item['description'] as String,
            imageUrl: item['image'] as String,
          ),
        )
        .toList();

    final customProducts = await _loadCustomProducts();
    return [...customProducts, ...apiProducts];
  }

  Future<List<ProductItem>> _loadCustomProducts() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/ironpath_products.json',
    );
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final products = decoded['products'] as List<dynamic>;
    return products
        .map((item) => ProductItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<ProductItem> _visibleProducts(List<ProductItem> products) {
    final query = _searchQuery.trim().toLowerCase();

    return products.where((product) {
      final matchesFilter = switch (_selectedFilter) {
        ProductFilter.all => true,
        ProductFilter.products => !product.isService,
        ProductFilter.services => product.isService,
      };
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F0),
      appBar: AppBar(
        title: const Text('IronPath Shop'),
        backgroundColor: const Color(0xFFB7FF5A),
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<ProductItem>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text('Could not load API data: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _futureProducts = _loadProducts();
                      }),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final products = _visibleProducts(snapshot.data ?? <ProductItem>[]);

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'Featured products & services',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search products and services',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SegmentedButton<ProductFilter>(
                segments: const [
                  ButtonSegment(
                    value: ProductFilter.all,
                    label: Text('All'),
                    icon: Icon(Icons.grid_view_rounded),
                  ),
                  ButtonSegment(
                    value: ProductFilter.products,
                    label: Text('Products'),
                    icon: Icon(Icons.fitness_center),
                  ),
                  ButtonSegment(
                    value: ProductFilter.services,
                    label: Text('Services'),
                    icon: Icon(Icons.support_agent),
                  ),
                ],
                selected: {_selectedFilter},
                onSelectionChanged: (selection) {
                  setState(() => _selectedFilter = selection.first);
                },
              ),
              const SizedBox(height: 18),
              if (products.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No items match this category.'
                          : 'No products or services match "$_searchQuery".',
                    ),
                  ),
                ),
              ...products.map(
                (product) => _ProductCard(
                  product: product,
                  onAdd: () => _showAddedMessage(product),
                  onDetails: () => _showDetails(product),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddedMessage(ProductItem product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to your plan.')),
    );
  }

  Future<void> _showDetails(ProductItem product) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.name),
        content: Text(product.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

enum ProductFilter { all, products, services }

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onAdd,
    required this.onDetails,
  });

  final ProductItem product;
  final VoidCallback onAdd;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: const Color(0xFFDDE8C7),
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(product.rating.toStringAsFixed(1)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.category,
                  style: const TextStyle(
                    color: Color(0xFF4F8B3D),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: const TextStyle(color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${product.stock} in stock',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7FF5A),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Add to cart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDetails,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
