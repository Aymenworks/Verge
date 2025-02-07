//
//  AnyEntity.swift
//  VergeORM
//
//  Created by muukii on 2020/01/02.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

/// Type erased container
/// Identifier based Equality
struct AnyEntity : Hashable {
  
  final class AnyBox {
    
    var base: Any
    
    init(_ base: Any) {
      self.base = base
    }
  }
  
  static func == (lhs: AnyEntity, rhs: AnyEntity) -> Bool {
    if lhs.box === rhs.box {
      return true
    }
    if lhs.identifier == rhs.identifier {
      return true
    }
    return false
  }
  
  func hash(into hasher: inout Hasher) {
    makeHash(&hasher)
  }
    
  var base: Any {
    _read {
      yield box.base
    }
    set {
      if isKnownUniquelyReferenced(&box) {
        box.base = newValue
      } else {
        box = .init(newValue)
      }
    }
  }
  
  private var box: AnyBox
  private let identifier: AnyHashable
  
  private let makeHash: (inout Hasher) -> Void
    
  init<Base: EntityType>(_ base: Base) {
    self.box = .init(base)
    self.makeHash = base.entityID.hash
    self.identifier = base.entityID
  }
  
}
