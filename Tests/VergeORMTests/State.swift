//
//  State.swift
//  VergeORMTests
//
//  Created by muukii on 2019/12/17.
//  Copyright © 2019 muukii. All rights reserved.
//

import Foundation

import VergeORM

struct Book: EntityType, Equatable {
  
  let rawID: String
  let authorID: Author.ID
  var name: String = ""
}

struct Author: EntityType {
  
  let rawID: String
  
  static let anonymous: Author = .init(rawID: "anonymous")
}

struct RootState {
  
  struct Database: DatabaseType {
    
    struct Schema: EntitySchemaType {
      let book = EntityTableKey<Book>()
      let author = EntityTableKey<Author>()
    }
    
    struct Indexes: IndexesType {
      let bookA = IndexKey<OrderedIDIndex<Schema, Book>>()
      let authorGroupedBook = IndexKey<GroupByIndex<Schema, Author, Book>>()
      let bookMiddleware = IndexKey<OrderedIDIndex<Schema, Author>>()
    }
    
    var middlewares: [AnyMiddleware<RootState.Database>] {
      [
        AnyMiddleware<RootState.Database>(performAfterUpdates: { (context) in
          let ids = context.insertsOrUpdates.author.all().map { $0.id }
          context.indexes.bookMiddleware.append(contentsOf: ids)
        })
      ]
    }
    
    var _backingStorage: BackingStorage = .init()
  }
  
  var db = Database()
}
