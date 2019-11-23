//
//  Sample.swift
//  VergeStore
//
//  Created by muukii on 2019/09/24.
//  Copyright © 2019 muukii. All rights reserved.
//

import Foundation

#if DEBUG

class MyStore: StoreBase<MyStore.State> {
  
  struct State {
    var count: Int = 0
  }
  
  init() {
    super.init(initialState: .init(), logger: nil)
  }
  
  func increment() -> Mutation {
    return .init {
      $0.count += 1
    }
  }
  
  func asyncIncrement() -> Action<Void> {
    return .init { context in
      DispatchQueue.main.async {
        context.commit { $0.increment() }
      }
    }
  }
  
}

enum Run {
  
  static func hoge() {
    
    let m = MyStore()
    
    m.commit { $0.increment() }
  }
}

#endif
