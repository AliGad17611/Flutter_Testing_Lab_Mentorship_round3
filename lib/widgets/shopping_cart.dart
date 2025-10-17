import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final double discount; // Discount percentage (0.0 to 1.0)

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.discount = 0.0,
  });
}

class ShoppingCart {
  final List<CartItem> _items = [];

  void addItem(String id, String name, double price, {double discount = 0.0}) {
    if (_items.any((item) => item.id == id)) {
      _items.firstWhere((item) => item.id == id).quantity += 1;
    } else {
      _items.add(
        CartItem(id: id, name: name, price: price, discount: discount),
      );
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  void clearCart() {
    _items.clear();
  }

  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      // If the discount is a percentage (e.g. 0.1 == 10%), apply to price * quantity
      discount += (item.price * item.discount) * item.quantity;
    }
    return discount;
  }

  double get totalAmount {
    return subtotal - totalDiscount;
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  List<CartItem> get items => _items;
}

class ShoppingCartWidget extends StatefulWidget {
  const ShoppingCartWidget({super.key});

  @override
  State<ShoppingCartWidget> createState() => _ShoppingCartWidgetState();
}

class _ShoppingCartWidgetState extends State<ShoppingCartWidget> {
  final ShoppingCart _cart = ShoppingCart();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cart.addItem('1', 'Apple iPhone', 999.99, discount: 0.1);
                });
              },
              child: const Text('Add iPhone'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cart.addItem('2', 'Samsung Galaxy', 899.99, discount: 0.15);
                });
              },
              child: const Text('Add Galaxy'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cart.addItem('3', 'iPad Pro', 1099.99);
                });
              },
              child: const Text('Add iPad'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cart.addItem('1', 'Apple iPhone', 999.99, discount: 0.1);
                });
              },
              child: const Text('Add iPhone Again'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Items: ${_cart.totalItems}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cart.clearCart();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear Cart'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Subtotal: \$${_cart.subtotal.toStringAsFixed(2)}'),
              Text(
                'Total Discount: \$${_cart.totalDiscount.toStringAsFixed(2)}',
              ),
              const Divider(),
              Text(
                'Total Amount: \$${_cart.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _cart.items.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _cart.items.length,
                itemBuilder: (context, index) {
                  final item = _cart.items[index];
                  final itemTotal = item.price * item.quantity;

                  return Card(
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${item.price.toStringAsFixed(2)} each',
                          ),
                          if (item.discount > 0)
                            Text(
                              'Discount: ${(item.discount * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.green),
                            ),
                          Text('Item Total: \$${itemTotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _cart.updateQuantity(
                                  item.id,
                                  item.quantity - 1,
                                );
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${item.quantity}'),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _cart.updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                );
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _cart.removeItem(item.id);
                              });
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
