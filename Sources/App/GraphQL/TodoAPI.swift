import Graphiti
import Vapor

final class TodoAPI {
    func getAllTodos(request: Request, _: NoArguments) throws -> EventLoopFuture<[Todo]> {
        Todo.query(on: request).all()
    }

    struct CreateTodoArguments: Codable {
        let title: String
    }

    func createTodo(request: Request, arguments: CreateTodoArguments) throws -> EventLoopFuture<Todo> {
        Todo(title: arguments.title).save(on: request)
    }

    struct DeleteTodoArguments: Codable {
        let id: Int
    }

    func deleteTodo(request: Request, arguments: DeleteTodoArguments) throws -> EventLoopFuture<Bool> {
        Todo.find(arguments.id, on: request)
            .unwrap(or: Abort(.notFound))
            .flatMap({ $0.delete(on: request) })
            .transform(to: true)
    }

    struct ChangeTodoStateArguments: Codable {
        let id: Int
        let state: Todo.TodoState
    }

    func changeTodoState(request: Request, arguments: ChangeTodoStateArguments) throws -> EventLoopFuture<Todo> {
        Todo.find(arguments.id, on: request)
            .unwrap(or: Abort(.notFound))
            .map ({ (todo) in
                todo.state = arguments.state
                return todo
            })
            .save(on: request)

    }
}

extension TodoAPI: FieldKeyProvider {
    typealias FieldKey = FieldKeys

    enum FieldKeys: String {
    // Names for the GraphQL schema endpoints
        case todos // Get all todos
        case createTodo // Create a new todo
        case deleteTodo // Delete a todo
        case changeTodoState // Mark a todo as done, open or forLater
    }
}
