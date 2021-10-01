//
//  Swift+XCTest.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import XCTest

extension XCTest {
    func readJson<Value: Decodable>(from fileName: String) throws -> Value {
        let bundle: Bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.path(forResource: fileName, ofType: "json") else {
            fatalError("Could not find \(fileName).json")
        }
        
        guard let jsonString = try? NSString(contentsOfFile: url, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(fileName).json to String")
        }
        
        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert \(fileName).json to NSData")
        }
        
        return try JSONDecoder().decode(Value.self, from: jsonData)
    }
}
