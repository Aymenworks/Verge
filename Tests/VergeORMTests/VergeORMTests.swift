//
//  VergeNormalizerTests.swift
//  VergeNormalizerTests
//
//  Created by muukii on 2019/12/07.
//  Copyright © 2019 muukii. All rights reserved.
//

import XCTest

import VergeCore
import VergeORM

class VergeORMTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.        
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testCommit() {
    
    var state = RootState()
    
    let context = state.db.beginBatchUpdates()
    
    let book = Book(rawID: "some", authorID: Author.anonymous.id)
    context.book.insertsOrUpdates.insert(book)
    
    state.db.commitBatchUpdates(context: context)
    
    let a = state.db.entities.book
    let b = state.db.entities.book
    
    XCTAssertEqual(a, b)
    
  }
  
  func testEqualityEntityTable() {
    
    var state = RootState()
    
    state.db.performBatchUpdates { (context) in
      
      let book = Book(rawID: "some", authorID: Author.anonymous.id)
      context.book.insertsOrUpdates.insert(book)
    }
    
    let a = state.db.entities.book
    let b = state.db.entities.book
    
    XCTAssertEqual(a, b)
        
  }
  
  func testSimpleInsert() {
    
    var state = RootState()
    
    state.db.performBatchUpdates { (context) in
      
      let book = Book(rawID: "some", authorID: Author.anonymous.id)
      context.book.insertsOrUpdates.insert(book)
    }
    
    XCTAssertEqual(state.db.entities.book.count, 1)
    
  }
  
  func testManagingOrderTable() {
    
    var state = RootState()
    
    state.db.performBatchUpdates { (context) in
      
      let book = Book(rawID: "some", authorID: Author.anonymous.id)
      context.book.insertsOrUpdates.insert(book)
      context.indexes.allBooks.append(book.id)
    }
        
    XCTAssertEqual(state.db.entities.book.count, 1)
    XCTAssertEqual(state.db.indexes.allBooks.count, 1)
    
    print(state.db.indexes.allBooks)
    
    state.db.performBatchUpdates { (context) -> Void in
      context.book.deletes.insert(Book.ID.init("some"))
    }
    
    XCTAssertEqual(state.db.entities.book.count, 0)
    XCTAssertEqual(state.db.indexes.allBooks.count, 0)
    
  }
  
  func testUpdate() {
    
    var state = RootState()
    
    let id = Book.ID.init("some")
    
    state.db.performBatchUpdates { (context) in
      
      let book = Book(rawID: id.raw, authorID: Author.anonymous.id)
      context.book.insertsOrUpdates.insert(book)
    }
    
    XCTAssertNotNil(state.db.entities.book.find(by: id))
    
    state.db.performBatchUpdates { (context) in
            
      guard var book = context.book.current.find(by: id) else {
        XCTFail()
        return
      }
      book.name = "hello"
      
      context.book.insertsOrUpdates.insert(book)
    }
    
    XCTAssertNotNil(state.db.entities.book.find(by: id))
    XCTAssertNotNil(state.db.entities.book.find(by: id)!.name == "hello")

  }
  
}
