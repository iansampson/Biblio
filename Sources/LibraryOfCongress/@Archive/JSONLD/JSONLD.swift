//
//  JSONLD.swift
//  
//
//  Created by Ian Sampson on 2021-11-14.
//

public enum JSONLD { }

// TODO: Consider renaming to LinkedData
extension JSONLD {
    struct Container<ObjectType: Decodable> where ObjectType: Equatable,
                                                    ObjectType: RawRepresentable,
                                                    ObjectType.RawValue == String
    {
        private let container: UnkeyedDecodingContainer // KeyedDecodingContainer<CodingKeys>
        private let propertyContainers: [String: UnkeyedDecodingContainer]
        
        enum ParseOutput {
            case object(UnkeyedDecodingContainer)
            case property(String, UnkeyedDecodingContainer)
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "@id"
            case type = "@type"
        }
        
        private static func parse(_ type: ObjectType, _ input: UnkeyedDecodingContainer) throws -> (remainingInput: UnkeyedDecodingContainer, output: ParseOutput)? {
            var remainingInput = input
            guard let propertyContainer = try? remainingInput.nestedContainer(keyedBy: CodingKeys.self) else {
                return nil
            }
            
            if let types = try? propertyContainer.decode([String].self, forKey: .type),
               types.contains(type.rawValue)
            {
                return (remainingInput, .object(input))
            } else {
                let id = try propertyContainer.decode(String.self, forKey: .id)
                return (remainingInput, .property(id, input))
            }
        }
        
        init(type: ObjectType, from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            var objectContainer: UnkeyedDecodingContainer?
            var propertyContainers: [String: UnkeyedDecodingContainer] = [:]
            
            while let result = try Self.parse(type, container) {
                switch result.output {
                case let .object(container):
                    objectContainer = container
                case let .property(id, container):
                    propertyContainers[id] = container
                }
                container = result.remainingInput
            }
            
            guard let objectContainer = objectContainer else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath,
                                                        debugDescription: "Unkeyed container does not contain an object whose @type property matches the expected value \"\(type)\"",
                                                        underlyingError: nil))
            }
            
            self.container = objectContainer
            self.propertyContainers = propertyContainers
        }
        
        func decode<T: Decodable, CodingKeys: CodingKey>(_ type: T.Type, forProperty property: CodingKeys) throws -> [T] {
            var container = self.container
            let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self)
            
            guard let property = try nestedContainer.decodeIfPresent([ValueOrID<T, String>].self, forKey: property) else {
                return []
            }
            
            return try property.compactMap {
                if let value = $0.value {
                    return value
                } else if let id = $0.id {
                    guard var container = propertyContainers[id] else {
                        return nil
                    }
                    return try container.decode(T.self)
                } else {
                    return nil
                }
            }
        }
    }
}

protocol JSONLDCodingKey {
    static var jsonLDID: Self { get }
    static var jsonLDType: Self { get }
}

extension JSONLD {
    struct Identifier<Base: Decodable>: Decodable {
        let id: Base
        
        enum CodingKeys: String, CodingKey {
            case id = "@id"
        }
    }
    
    struct Value<Base: Decodable>: Decodable {
        let value: Base
        
        enum CodingKeys: String, CodingKey {
            case value = "@value"
        }
    }
    
    // TODO: Consider renaming to Property
    struct ValueOrID<Value: Decodable, ID: Decodable>: Decodable {
        let id: ID?
        let value: Value?
        
        enum CodingKeys: String, CodingKey {
            case id = "@id"
            case value = "@value"
        }
    }
    
    public struct Identifiable<ID: Decodable>: Decodable {
        let id: ID
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self)
            id = try nestedContainer.decode(ID.self, forKey: .id)
        }
        
        enum CodingKeys: String, CodingKey {
            case id = "@id"
        }
    }
    
    public struct Valuable<Value: Decodable>: Decodable {
        let value: Value
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self)
            value = try nestedContainer.decode(Value.self, forKey: .value)
        }
        
        enum CodingKeys: String, CodingKey {
            case value = "@value"
        }
    }
}

/*
 
 
     .lazy
     .compactMap { $0.id }
     .compactMap { propertyContainers[$0] }
 // TODO: Check if container contains appropriate Class
     .map { input -> T in
         var remainingInput = input
         return try remainingInput.decode(T.self)
     } ?? []
 */
