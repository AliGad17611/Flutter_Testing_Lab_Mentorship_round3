import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';

void main() {
  group('Unit Tests for shopping cart', () {
    late ShoppingCart cart;
    setUp(() {
      cart = ShoppingCart();
    });
    test('should calculate subtotal correctly', () {
      cart.addItem('1', 'Item 1', 10.0);
      expect(cart.subtotal, 10.0);
    });
    test('should calculate total discount correctly', () {
      cart.addItem('1', 'Item 1', 10.0, discount: 0.1);
      expect(cart.totalDiscount, 1.0);
    });
    test('should calculate total amount correctly', () {
      cart.addItem('1', 'Item 1', 10.0, discount: 0.1);
      expect(cart.totalAmount, 9.0);
    });
    test('should return total items count correctly', () {
      cart.addItem('1', 'Item 1', 10.0, discount: 0.1);
      cart.addItem('2', 'Item 2', 20.0, discount: 0.2);
      expect(cart.totalItems, 2);
    });
  });
  group('Widget Tests for shopping cart', () {

    testWidgets('should show shopping cart widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.byType(ShoppingCartWidget), findsOneWidget);
    });
    testWidgets('should show add iPhone button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Add iPhone'), findsOneWidget);
    });
    testWidgets('should show add Galaxy button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Add Galaxy'), findsOneWidget);
    });
    testWidgets('should show add iPad button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Add iPad'), findsOneWidget);
    });
    testWidgets('should show add iPhone again button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Add iPhone Again'), findsOneWidget);
    });
    testWidgets('should show clear cart button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Clear Cart'), findsOneWidget);
    });
    testWidgets('should show total items count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Total Items: 0'), findsOneWidget);
    });
    testWidgets('should show subtotal', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Subtotal: \$0.00'), findsOneWidget);
    });
    testWidgets('should show total discount', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Total Discount: \$0.00'), findsOneWidget);
    });
    testWidgets('should show total amount', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Total Amount: \$0.00'), findsOneWidget);
    });
    testWidgets('should show cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      expect(find.text('Cart is empty'), findsOneWidget);
    });
    testWidgets('should show item list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.tap(find.byType(ElevatedButton).at(1));
      await tester.pump();
      expect(find.byType(Card), findsNWidgets(2));
      expect(find.text('Apple iPhone'), findsOneWidget);
      expect(find.text('Samsung Galaxy'), findsOneWidget);
    });
    testWidgets('should show item price', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.tap(find.byType(ElevatedButton).at(1));
      await tester.pump();
      expect(find.text('Price: \$999.99 each'), findsOneWidget);
      expect(find.text('Price: \$899.99 each'), findsOneWidget);
    });
    testWidgets('should show item discount', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.tap(find.byType(ElevatedButton).at(1));
      await tester.pump();
      expect(find.text('Discount: 10%'), findsOneWidget);
      expect(find.text('Discount: 15%'), findsOneWidget);
    });
    testWidgets('should show item total', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: ShoppingCartWidget())),
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.tap(find.byType(ElevatedButton).at(1));
      await tester.pump();
      expect(find.text('Total Items: 2'), findsOneWidget);
    });


  });
}
