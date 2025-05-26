class TodoQuery {
  static const String getTodos = r"""
    query FilteredTodos($options: PageQueryOptions) {
      todos(options: $options) {
        data {
          id
          title
          completed
          user {
            name
            address {
              city
            }
          }
        }
      }
    }
  """;
}
