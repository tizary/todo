class CreateTodoMutation {
  static String createTodo = """
    mutation CreateTodo(\$title: String!) {
      createTodo(input: { title: \$title, completed: false }) {
        id
        title
        completed
      }
    }
  """;
}
