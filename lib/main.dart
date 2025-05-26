import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todos_example/utils/get_todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );

  runApp(GraphQLProvider(
    client: ValueNotifier(client),
    child: const MyApp(),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _addTaskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _addTaskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask() {}

  void _searchTasks() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Добавление задачи',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: _addTaskController,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: _addTask,
                        child: const Text('Добавить'),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Поиск задачи',
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: _searchController,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: _searchTasks,
                        child: const Text('Найти'),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: TaskList(searchText: _searchText),
              )
            ],
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  final String searchText;

  const TaskList({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(TodoQuery.getTodos),
        variables: {
          "options": {
            if (searchText.isNotEmpty)
              "search": {
                "q": searchText,
              },
            "paginate": const {"limit": 1000}
          }
        },
      ),
      builder: (QueryResult<Object?> result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (result.hasException) {
          return Center(child: Text('Ошибка: ${result.exception.toString()}'));
        }

        final taskList = result.data!['todos']['data'] as List;

        if (taskList.isEmpty) {
          return const Center(child: Text('Нет задач.'));
        }

        return ListView.builder(
          itemCount: taskList.length,
          itemBuilder: (BuildContext context, int index) {
            final task = taskList[index];
            return ListTile(
              textColor: task['completed'] ? Colors.green : Colors.black,
              title: Text(task['title']),
            );
          },
        );
      },
    );
  }
}
