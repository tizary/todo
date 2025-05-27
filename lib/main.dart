import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todos_example/home_page.dart';
import 'package:todos_example/services/socket_connection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );

  runApp(GraphQLProvider(
    client: ValueNotifier(client),
    child: ChangeNotifierProvider(
      create: (_) => SocketService()..initSocketConnection(),
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GraphQl Todos'),
    );
  }
}
