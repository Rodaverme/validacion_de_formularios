import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validacion_de_formularios/models/models.dart';
import 'package:validacion_de_formularios/screens/screens.dart';
import 'package:validacion_de_formularios/services/services.dart';
import 'package:validacion_de_formularios/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsServices>(context);
    final authservice = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              authservice.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: Icon(Icons.login_outlined)),
      ),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (BuildContext context, index) => GestureDetector(
                onTap: () {
                  productsService.selectedProduct =
                      productsService.products[index].copy();
                  Navigator.pushNamed(context, 'product');
                },
                child: ProductCard(product: productsService.products[index]),
              )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            productsService.selectedProduct =
                new Product(available: false, name: '', price: 0);
            Navigator.pushNamed(context, 'product');
          }),
    );
  }
}
