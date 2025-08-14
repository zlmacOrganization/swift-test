//
//  CodableUtil.swift
//  SwiftTest
//
//  Created by zhangliang on 2022/12/19.
//  Copyright © 2022 zhangliang. All rights reserved.
//

import Foundation

func decode(fromObject container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any] {
  var result: [String: Any] = [:]

  for key in container.allKeys {
    if let val = try? container.decode(Int.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(Double.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(String.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(Bool.self, forKey: key) {
      result[key.stringValue] = val
    } else if let nestedContainer = try? container.nestedContainer(
      keyedBy: JSONCodingKeys.self, forKey: key)
    {
      result[key.stringValue] = decode(fromObject: nestedContainer)
    } else if var nestedArray = try? container.nestedUnkeyedContainer(forKey: key) {
      result[key.stringValue] = decode(fromArray: &nestedArray)
    } else if (try? container.decodeNil(forKey: key)) == true {
      result.updateValue(Any?(nil) as Any, forKey: key.stringValue)
    }
  }

  return result
}

func decode(fromArray container: inout UnkeyedDecodingContainer) -> [Any] {
  var result: [Any] = []

  while !container.isAtEnd {
    if let value = try? container.decode(String.self) {
      result.append(value)
    } else if let value = try? container.decode(Int.self) {
      result.append(value)
    } else if let value = try? container.decode(Double.self) {
      result.append(value)
    } else if let value = try? container.decode(Bool.self) {
      result.append(value)
    } else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
      result.append(decode(fromObject: nestedContainer))
    } else if var nestedArray = try? container.nestedUnkeyedContainer() {
      result.append(decode(fromArray: &nestedArray))
    } else if (try? container.decodeNil()) == true {
      result.append(Any?(nil) as Any)
    }
  }

  return result
}

func encodeValue(
  fromObjectContainer container: inout KeyedEncodingContainer<JSONCodingKeys>, map: [String: Any]
) throws {
  for k in map.keys {
    let value = map[k]
    let encodingKey = JSONCodingKeys(stringValue: k)

    if let value = value as? String {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Int {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Double {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Bool {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? [String: Any] {
      var keyedContainer = container.nestedContainer(
        keyedBy: JSONCodingKeys.self, forKey: encodingKey)
      try encodeValue(fromObjectContainer: &keyedContainer, map: value)
    } else if let value = value as? [Any] {
      var unkeyedContainer = container.nestedUnkeyedContainer(forKey: encodingKey)
      try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
    } else {
      try container.encodeNil(forKey: encodingKey)
    }
  }
}

func encodeValue(fromArrayContainer container: inout UnkeyedEncodingContainer, arr: [Any]) throws {
  for value in arr {
    if let value = value as? String {
      try container.encode(value)
    } else if let value = value as? Int {
      try container.encode(value)
    } else if let value = value as? Double {
      try container.encode(value)
    } else if let value = value as? Bool {
      try container.encode(value)
    } else if let value = value as? [String: Any] {
      var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self)
      try encodeValue(fromObjectContainer: &keyedContainer, map: value)
    } else if let value = value as? [Any] {
      var unkeyedContainer = container.nestedUnkeyedContainer()
      try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
    } else {
      try container.encodeNil()
    }
  }
}

struct JSONCodingKeys: CodingKey {
  var stringValue: String
    
  init(stringValue: String) {
    self.stringValue = stringValue
  }
    
  var intValue: Int?
    
  init?(intValue: Int) {
    self.init(stringValue: "\(intValue)")
    self.intValue = intValue
  }
}

struct JSONValue: Codable {
  var value: Any?

  init(value: Any?) {
    self.value = value
  }
    
  init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
      self.value = decode(fromObject: container)
    } else if var array = try? decoder.unkeyedContainer() {
      self.value = decode(fromArray: &array)
    } else if let value = try? decoder.singleValueContainer() {
      if value.decodeNil() {
        self.value = nil
      } else {
        if let result = try? value.decode(Int.self) { self.value = result }
        if let result = try? value.decode(Double.self) { self.value = result }
        if let result = try? value.decode(String.self) { self.value = result }
        if let result = try? value.decode(Bool.self) { self.value = result }
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    if let map = self.value as? [String: Any] {
      var container = encoder.container(keyedBy: JSONCodingKeys.self)
      try encodeValue(fromObjectContainer: &container, map: map)
    } else if let arr = self.value as? [Any] {
      var container = encoder.unkeyedContainer()
      try encodeValue(fromArrayContainer: &container, arr: arr)
    } else {
      var container = encoder.singleValueContainer()

      if let value = self.value as? String {
        try container.encode(value)
      } else if let value = self.value as? Int {
        try container.encode(value)
      } else if let value = self.value as? Double {
        try container.encode(value)
      } else if let value = self.value as? Bool {
        try container.encode(value)
      } else {
        try container.encodeNil()
      }
    }
  }
}

struct ThingWithJson: Codable {
  let intVal: Int
  let stringVal: String
  let json: JSONValue
}

func runEncode(_ movie: ThingWithJson) {
    let encoder = JSONEncoder()
    if let result = try? encoder.encode(movie) {
        let json = String(data: result, encoding: .utf8)!
        print(json, "\n")
    }
}

func runDecode(_ json: String) -> ThingWithJson? {
  let decoder = JSONDecoder()
  let data = json.data(using: .utf8)!

  return try? decoder.decode(ThingWithJson.self, from: data)
}

//runEncode(ThingWithJson(intVal: 1, stringVal: "String - yo", json: JSON(value: "Yo")))
//
//runEncode(ThingWithJson(intVal: 2, stringVal: "Object / Map", json: JSON(value: ["a": 12, "b": "Hi"])))
//
//runEncode(ThingWithJson(intVal: 3, stringVal: "null", json: JSON(value: nil)))
//
//runEncode(ThingWithJson(intVal: 4, stringVal: "nested object", json: JSON(value: ["a": 12, "o": ["b": 2, "c": "hi"]])))
//
//runEncode(ThingWithJson(intVal: 5, stringVal: "array", json: JSON(value: [1, [2, nil, [ "str": "string", "nil": nil, "arr": ["a", ["b"]] ]], 3])))
//
//
//print("\n\ntrying object")
//let resultObject = runDecode("""
//{"intVal": 12, "stringVal": "Yo", "json": { "num": 12, "null": null, "nullArr": [1, null, { "a": "a", "null": null }], "str": "Hi", "dbl": 1.2, "arr": [1, 2, 3], "obj": { "int": 1, "o2": { "a": 88, "b": "b" } } } }
//""")
//
//print("\n", resultObject!, "\n")
//
//if let map = resultObject?.json.value as? [String: Any] {
//    print("got object")
//    print(map["num"]!, map["dbl"]!)
//    print("null", map["null"] ?? "<null>")
//    print("nullArr", map["nullArr"]!)
//
//    let nullarr = map["nullArr"] as! [Any]
//    if let secondVal = nullarr[1] as Any? {
//        print("SECOND VAL", secondVal)
//    }
//
//
//    if let nullMap = nullarr[2] as? [String: Any] {
//        print("null map", nullMap)
//
//        print("Keys")
//        for k in nullMap.keys {
//            print(k, nullMap[k]!)
//        }
//        print("End keys")
//    }
//
//    if let nestedMap = map["obj"] as? [String: Any] {
//        print("Got nested object")
//        print(nestedMap["int"]!)
//        if let nestedMap2 = nestedMap["o2"] as? [String: Any] {
//            print("Got nested object 2")
//            print(nestedMap2["a"]!)
//        }
//    }
//}


//https://juejin.cn/post/7168748765946806303
public struct AnyValue: Decodable {
    var value: Any
     
    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        init?(stringValue: String) { self.stringValue = stringValue }
    }
     
    init(value: Any) {
        self.value = value
    }
     
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyValue.self, forKey: key).value
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                result.append(try container.decode(AnyValue.self).value)
            }
            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let doubleVal = try? container.decode(Double.self) {
                value = doubleVal
            } else if let boolVal = try? container.decode(Bool.self) {
                value = boolVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
}
 
extension AnyValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        if let array = value as? [Any] {
            var container = encoder.unkeyedContainer()
            for value in array {
                let decodable = AnyValue(value: value)
                try container.encode(decodable)
            }
        } else if let dictionary = value as? [String: Any] {
            var container = encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in dictionary {
                let codingKey = CodingKeys(stringValue: key)!
                let decodable = AnyValue(value: value)
                try container.encode(decodable, forKey: codingKey)
            }
        } else {
            var container = encoder.singleValueContainer()
            if let intVal = value as? Int {
                try container.encode(intVal)
            } else if let doubleVal = value as? Double {
                try container.encode(doubleVal)
            } else if let boolVal = value as? Bool {
                try container.encode(boolVal)
            } else if let stringVal = value as? String {
                try container.encode(stringVal)
            } else {
                throw EncodingError.invalidValue(value, EncodingError.Context.init(codingPath: [], debugDescription: "The value is not encodable"))
            }
        }
    }
}


public struct ZLNumber: Codable {
    public var intValue: Int
    public var stringValue: String
    public var doubleValue: Double
    
    public init(_ intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
        self.doubleValue = Double(intValue)
    }
    
    public init(_ stringValue: String) {
        self.intValue = Int(stringValue) ?? 0
        self.stringValue = stringValue
        self.doubleValue = Double(stringValue) ?? 0
    }
    
    public init(_ doubleValue: Double) {
        self.intValue = Int(doubleValue)
        self.stringValue = String(doubleValue)
        self.doubleValue = doubleValue
    }
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self) {
            if let intValue = Int(stringValue) {
                self.intValue = intValue
                self.stringValue = String(intValue)
                self.doubleValue = Double(intValue)
            } else {
                self.intValue = 0
                self.stringValue = String(0)
                self.doubleValue = Double(0)
            }
            
        } else if let stringValue = try? singleValueContainer.decode(Int.self) {
            self.intValue = stringValue
            self.stringValue = String(stringValue)
            self.doubleValue = Double(stringValue)
        } else if let doubleValue = try? singleValueContainer.decode(Double.self) {
            self.intValue = Int(doubleValue)
            self.stringValue = String(doubleValue)
            self.doubleValue = doubleValue
        } else {
            self.intValue = 0
            self.stringValue = String(0)
            self.doubleValue = Double(0)
        }
    }
}

/*
 * 兼容 Bool
 */
public struct ZLBoolean: Codable {
    
    public var value: Bool
    
    public init(_ value: Bool) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let stringValue = try? singleValueContainer.decode(String.self) {
            
            switch stringValue.lowercased() {
            case "0", "false":
                self.value = false
            case "1", "true":
               self.value = true
            default:
                self.value = false
            }
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            self.value = intValue == 1 ? true : false
        } else if let boolValue = try? singleValueContainer.decode(Bool.self) {
            self.value = boolValue
        } else {
            self.value = false
        }
    }
}
