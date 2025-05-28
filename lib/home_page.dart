import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todos_example/services/socket_connection.dart';
import 'package:todos_example/utils/get_todo.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _addTaskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _addTaskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask(WidgetRef ref) {
    final socketService = ref.read(socketServiceProvider.notifier);
    final message = _addTaskController.text.trim();
    if (message.isNotEmpty) {
      socketService.sendMessage(message);
      _addTaskController.clear();
    }
  }

  void _searchTasks() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(socketServiceProvider);

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
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: () => _addTask(ref),
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
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        onPressed: _searchTasks,
                        child: const Text('Найти'),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.cyan,
                child: Column(
                  children: [
                    const Text('Сообщения: '),
                    Expanded(
                      child: Consumer(builder: (context, ref, child) {
                  
                        return ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(messages[index]);
                            });
                      }),
                    ),
                  ],
                ),
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
