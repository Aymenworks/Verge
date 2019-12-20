//
//  OrderedIDIndexTests.swift
//  VergeORMTests
//
//  Created by muukii on 2019/12/17.
//  Copyright © 2019 muukii. All rights reserved.
//

import Foundation

import XCTest

import VergeORM

class OrderedIDIndexTests: XCTestCase {
  
  var state = RootState()
  
  override func setUp() {
    state.db.performBatchUpdates { (context) in
      
      let author = Author(rawID: "author.1")
      context.insertsOrUpdates.author.insert(author)
      
      let book = Book(rawID: "some", authorID: author.id)
      context.insertsOrUpdates.book.insert(book)
      
      context.indexes.authorGroupedBook
        .update(in: author.id) { (index) in
          index.append(book.id)
      }
    }
    
    XCTContext.runActivity(named: "setup") { _ in
      
      XCTAssertEqual(
        state.db.indexes.authorGroupedBook.groups().count,
        1
      )
      
      XCTAssertEqual(
        state.db.indexes.authorGroupedBook.orderedID(in: .init("author.1")).count,
        1
      )
      
    }
    
  }
  
  override func tearDown() {
    self.state = RootState()
  }
  
  func testRemoveBook() {
    
    state.db.performBatchUpdates { (context) -> Void in
      
      context.deletes.book.insert(.init("some"))
    }
    
    XCTAssertEqual(
      state.db.indexes.authorGroupedBook.groups().count,
      0
    )
    
    XCTAssertEqual(
      state.db.indexes.authorGroupedBook.orderedID(in: .init("author.1")).count,
      0
    )
    
  }
  
  func testRemoveAuthor() {
    
    state.db.performBatchUpdates { (context) -> Void in
      
      context.deletes.author.insert(.init("author.1"))
    }
    
    XCTAssertEqual(
      state.db.indexes.authorGroupedBook.groups().count,
      0
    )
    
    XCTAssertEqual(
      state.db.indexes.authorGroupedBook.orderedID(in: .init("author.1")).count,
      0
    )
    
  }
}
