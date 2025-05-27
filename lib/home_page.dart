import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todos_example/services/socket_connection.dart';
import 'package:todos_example/utils/get_todo.dart';

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
  final SocketService _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _socketService.initSocketConnection();
    final messages = _socketService.messages;
  }

  @override
  void dispose() {
    _addTaskController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTask() {
    final message = _addTaskController.text.trim();
    if (message.isNotEmpty) {
      _socketService.sendMessage(message);
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
    final socketSer = Provider.of<SocketService>(context);
    final messages = socketSer.messages;

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
                      child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(messages[index]);
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
