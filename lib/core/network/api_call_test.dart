

/*

Public API (token লাগবে না)
 Future<void> fetchProducts() async {
  try {
    final response = await ApiClient().dio.get('/products', options: Options(
      extra: {'requiresToken': false}, // public API
    ));
    print('Products: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}



Private API (token লাগবে)
Future<void> fetchOrders() async {
  try {
    final response = await ApiClient().dio.get('/orders'); // default requiresToken = true
    print('Orders: ${response.data}');
  } catch (e) {
    print('Error: $e');
  }
}

 */