//
// Copyright (c) 2019 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public struct EntityIdentifier<Entity: EntityType> : Hashable, CustomStringConvertible {
  
  public let raw: Entity.EntityIDRawType
  
  public init(_ raw: Entity.EntityIDRawType) {
    self.raw = raw
  }
  
  public var description: String {
    "<\(String(reflecting: Entity.self))>(\(raw))"
  }
}

/// A protocol describes object is an Entity.
///
/// EntityType has VergeTypedIdentifiable.
/// You might use IdentifiableEntityType instead, if you create SwiftUI app.
public protocol EntityType {
  
  associatedtype EntityIDRawType: Hashable, CustomStringConvertible
   
  var entityID: EntityID { get }
  
  #if COCOAPODS
  typealias EntityTableKey = Verge.EntityTableKey<Self>
  #else
  typealias EntityTableKey = VergeORM.EntityTableKey<Self>
  #endif
}

extension EntityType {
    
  public typealias EntityID = EntityIdentifier<Self>
    
  @available(*, deprecated, renamed: "EntityID")
  public typealias ID = EntityID
  
  @available(*, deprecated, renamed: "entityID")
  public var id: EntityID {
    _read { yield entityID }
  }
}

public struct EntityName: Hashable {
  public let name: String
}

extension EntityType {
     
  public static var entityName: EntityName {
    .init(name: String(reflecting: self))
  }
  
}
