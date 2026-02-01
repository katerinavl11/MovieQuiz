//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Екатерина Владимирова on 26.01.2026.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //given
        let array = [1, 2, 3, 3, 5]
        
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    func testGetValueOutOfRange() throws {
        //given
        let array = [1, 3, 5, 7]
        
        //when
        let value = array[safe: 15]
        
        //then
        XCTAssertNil(value)
    }
}
