//
//  Document.swift
//
//
//  Created by Ian Sampson on 2021-11-14.
//

struct Document: Decodable {
    let nodesByID: [String: DecodableNode]
    let nodeIDsByTypeName: [String: [String]]
    
    enum DecodingError: Error {
        case expectedNodeWithID(String)
        case expectedNodeWithTypeName(String)
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var nextContainer = container
        var nodesByID: [String: DecodableNode] = [:]
        var nodeIDsByTypeName: [String: [String]] = [:]
        
        while let node = try nextContainer.decodeIfPresent(Node.self) {
            let decodableNode = DecodableNode(base: node, container: container)
            
            if let id = node.id {
                nodesByID[id] = decodableNode
                
                if let types = node.types {
                    for type in types {
                        if nodeIDsByTypeName[type] == nil {
                            nodeIDsByTypeName[type] = [id]
                        } else {
                            nodeIDsByTypeName[type]?.append(id)
                        }
                    }
                }
            }
            
            container = nextContainer
        }
        
        self.nodesByID = nodesByID
        self.nodeIDsByTypeName = nodeIDsByTypeName
    }
    
    func decode<T>(_ type: T.Type, withID id: String) throws -> T where T: Decodable {
        guard var node = nodesByID[id] else {
            throw DecodingError.expectedNodeWithID(id)
        }
        
        // TODO: Double-check that the type matches
        return try node.container.decode(T.self)
    }
    
    func decode<T>(_ type: T.Type, withTypeName typeName: String, idPrefix: String? = nil) throws -> T where T: Decodable {
        guard let id = nodeIDsByTypeName[typeName]?
                .filter({
                    if let prefix = idPrefix { return $0.hasPrefix(prefix) }
                    return true
                })
                .first,
              var node = nodesByID[id]
        else {
            throw DecodingError.expectedNodeWithTypeName(typeName)
        }
        
        // TODO: Double-check that the type matches
        return try node.container.decode(T.self)
    }
    
    func expand<T, P>(_ property: P, into type: T.Type) throws -> T? where T: Decodable, P: Linkable {
        guard let id = property.id else {
            return nil
        }
        return try decode(T.self, withID: id)
    }
    
    func expand<T, P>(_ property: P?, into type: T.Type) throws -> T? where T: Decodable, P: Linkable {
        guard let property = property else {
            return nil
        }
        return try expand(property, into: type)
    }
    
    func expand<T, P>(_ properties: [P], into type: T.Type) throws -> [T] where T: Decodable, P: Linkable {
        try properties.lazy
            .compactMap { $0.id }
            .map {
                try decode(T.self, withID: $0)
            }
    }
    
    func expand<T, P>(_ properties: [P]?, into type: T.Type) throws -> [T] where T: Decodable, P: Linkable {
        guard let properties = properties else {
            return []
        }
        return try expand(properties, into: type)
    }
}
