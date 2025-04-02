import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/Product.dart';
import '../../../screens/details/details_screen.dart';
import '../../../screens/products/products_screen.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  final Function(String)? onSearch;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<SearchSuggestion> _suggestions = [];
  bool _showSuggestions = false;

  // Categories and brands from your application
  final List<String> _categories = [
    "Toys", "Action Figures", "Dolls", "Cars", "Controllers", "Gaming"
  ];
  
  final List<String> _brands = [
    "LEGO", "BANDAI NAMCO", "BARBIE", "DRAGON BALL", "HOT WHEELS", "NERF", "FISHER PRICE"
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    List<SearchSuggestion> newSuggestions = [];
    
    // Product suggestions
    for (var product in demoProducts) {
      if (product.title.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase())) {
        newSuggestions.add(SearchSuggestion(
          text: product.title,
          type: SuggestionType.product,
          productId: product.id,
        ));
      }
    }

    // Category suggestions
    for (var category in _categories) {
      if (category.toLowerCase().contains(query.toLowerCase())) {
        newSuggestions.add(SearchSuggestion(
          text: category,
          type: SuggestionType.category,
        ));
      }
    }
    
    // Brand suggestions
    for (var brand in _brands) {
      if (brand.toLowerCase().contains(query.toLowerCase())) {
        newSuggestions.add(SearchSuggestion(
          text: brand,
          type: SuggestionType.brand,
        ));
      }
    }

    setState(() {
      _suggestions = newSuggestions;
      _showSuggestions = _focusNode.hasFocus && _suggestions.isNotEmpty;
    });
  }

  void _onSuggestionSelected(BuildContext context, SearchSuggestion suggestion) {
    _searchController.text = suggestion.text;
    setState(() {
      _showSuggestions = false;
    });
    
    if (widget.onSearch != null) {
      widget.onSearch!(suggestion.text);
    }
    
    // Navigate based on suggestion type
    switch (suggestion.type) {
      case SuggestionType.product:
        // Find the product and navigate to its details
        final product = demoProducts.firstWhere(
          (p) => p.id == suggestion.productId,
          orElse: () => demoProducts.first,
        );
        Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ProductDetailsArguments(product: product),
        );
        break;
        
      case SuggestionType.category:
      case SuggestionType.brand:
        // Navigate to products screen (could be enhanced to filter by category/brand)
        Navigator.pushNamed(
          context,
          ProductsScreen.routeName,
        );
        break;
    }
    
    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (value) {
              _updateSuggestions(value);
              if (widget.onSearch != null) {
                widget.onSearch!(value);
              }
            },
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                // Navigate to products screen when user submits search
                Navigator.pushNamed(context, ProductsScreen.routeName);
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: kSecondaryColor.withOpacity(0.1),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: "Search Product",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _updateSuggestions('');
                        if (widget.onSearch != null) {
                          widget.onSearch!('');
                        }
                      },
                    )
                  : null,
            ),
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion.text),
                    dense: true,
                    leading: Icon(_getIconForSuggestionType(suggestion.type)),
                    onTap: () => _onSuggestionSelected(context, suggestion),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
  
  IconData _getIconForSuggestionType(SuggestionType type) {
    switch (type) {
      case SuggestionType.product:
        return Icons.toys;
      case SuggestionType.category:
        return Icons.category;
      case SuggestionType.brand:
        return Icons.storefront;
    }
  }
}

// Suggestion data model
enum SuggestionType {
  product,
  category,
  brand,
}

class SearchSuggestion {
  final String text;
  final SuggestionType type;
  final int? productId;
  
  SearchSuggestion({
    required this.text,
    required this.type,
    this.productId,
  });
}

const searchOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);