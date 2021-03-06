import Vapor

public struct PrototypeValidator: NodeValidator {

  enum PrototypeError: String, Error {
    case noFields = "Prototype may have al least 1 field."
  }

  public var node: Node
  public var errors: [String: Node] = [:]
  public var fieldNodes: [Node] = []

  public init(node: Node) {
    self.node = node
    validate(key: Prototype.Key.name.value, by: NameValidation.self)
    validate(key: Prototype.Key.handle.value, by: NameValidation.self)
    validateFields()
  }

  fileprivate mutating func validateFields() {
    let names = node["field_names"]?.nodeArray
    let handles = node["field_handles"]?.nodeArray
    let kinds = node["field_kinds"]?.nodeArray

    guard let array = kinds ?? names ?? handles, !array.isEmpty else {
      errors["fields"] = Node.string(PrototypeError.noFields.rawValue)
      return
    }

    func extract(from array: [Node]?, index: Int) -> String {
      guard let array = array, index < array.count else {
        return ""
      }

      return array[index].string ?? ""
    }

    var fieldErrors = [Node]()
    fieldNodes = []

    for i in 0..<array.count {
      let node: Node = [
        "index": Node(i),
        "name": Node.string(extract(from: names, index: i)),
        "handle": Node.string(extract(from: handles, index: i)),
        "kind": Node.string(extract(from: kinds, index: i)),
      ]

      fieldNodes.append(node)

      let validator = FieldValidator(node: node)

      if !validator.isValid {
        fieldErrors.append(Node.object(validator.errors))
      }
    }

    node["fields"] = Node.array(fieldNodes)

    if !fieldErrors.isEmpty {
      errors["fields"] = Node.array(fieldErrors)
    }
  }
}
