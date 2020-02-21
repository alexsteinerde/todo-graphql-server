import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String

    var state: TodoState

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String, state: TodoState = .open) {
        self.id = id
        self.title = title
        self.state = state
    }

    enum TodoState: String, CaseIterable {
        case open
        case done
        case forLater
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }

/// Allows `Todo.TodoState` to be stored in the database.
extension Todo.TodoState: Content, SQLiteEnumType {
    static func reflectDecoded() throws -> (Todo.TodoState, Todo.TodoState) {
        return (.done, .open) // Provide two unique cases
    }
}
