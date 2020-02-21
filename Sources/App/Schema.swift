import Graphiti
import Vapor

// Definition of our GraphQL schema.
let todoSchema = Schema<TodoAPI, Request>([
    // Todo type with it's fields
    Enum(Todo.TodoState.self),

    Type(Todo.self, fields: [
        Field(.title, at: \.title),
        Field(.id, at: \.id),
        Field(.state, at: \.state) // New: Todo state field
    ]),

    // We only have one single query: Getting all existing todos
    Query([
        Field(.todos, with: TodoAPI.getAllTodos),
    ]),

    // Both mutations accept arguments.
    // First we define the name from our FieldKey enum in the TodoAPI
    // and we pass the keypath to the field of the argument struct.
    Mutation([
        Field(.createTodo, with: TodoAPI.createTodo),
        Field(.deleteTodo, with: TodoAPI.deleteTodo),
        Field(.changeTodoState, with: TodoAPI.changeTodoState), // New: Change Todo State API
    ]),
])
