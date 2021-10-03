//
//  NetworkClientTests.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import XCTest
import Combine
@testable import Countries

class NetworkClientTests: XCTestCase {
    private struct TestStructure: Codable {
        let name: String
    }
    
    private let json = "{\"name\": \"Dushant\"}"
    private let errorJson = "{\"error\": \"invalid resource\"}"
    private var networkClient = NetworkClient.shared
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }()
    
    override func setUpWithError() throws {
        networkClient = NetworkClient(urlSession: urlSession)
    }

    func testThatClientCanDecodeSuccessfully() {
        // GIVEN
        let expectation = expectation(description: "Excepeting a successfull response from test")
        let endpoint: Endpoint = .all
        let response = HTTPURLResponse(url: endpoint.url(), statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.requestHandler = (Data(json.utf8), response)
        
        // WHEN
        var result: Result<TestStructure, Error>?
        networkClient.performRequest(Request(with: endpoint))
            .map { testStructure -> Result<TestStructure, Error> in .success(testStructure)}
            .catch { error -> AnyPublisher<Result<TestStructure, Error>, Never> in .just(.failure(error)) }
            .sink { result = $0; expectation.fulfill() }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isSuccess)
        
        let object = try? result!.get()
        XCTAssertEqual(object?.name ?? "", "Dushant")
    }
    
    func testThatClientCanHandle404Error() {
        // GIVEN
        let expectation = expectation(description: "Excepeting a 400 response from test")
        let endpoint = Endpoint.all
        let response = HTTPURLResponse(url: endpoint.url(), statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.requestHandler = (Data(errorJson.utf8), response)
        
        // WHEN
        var result: Result<TestStructure, Error>?
        networkClient.performRequest(Request(with: endpoint))
            .map { testStructure -> Result<TestStructure, Error> in .success(testStructure)}
            .catch { error -> AnyPublisher<Result<TestStructure, Error>, Never> in .just(.failure(error)) }
            .sink { result = $0; expectation.fulfill() }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.isSuccess)
        XCTAssertEqual(result!.error as! RequestError, RequestError.notFound)
    }
    
    func testThatClientCanHandleDecodeError() {
        // GIVEN
        let expectation = expectation(description: "Excepeting a decoding issue from test")
        let endpoint = Endpoint.all
        let response = HTTPURLResponse(url: endpoint.url(), statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.requestHandler = (Data(errorJson.utf8), response)
        
        // WHEN
        var result: Result<TestStructure, Error>?
        networkClient.performRequest(Request(with: endpoint))
            .map { testStructure -> Result<TestStructure, Error> in .success(testStructure)}
            .catch { error -> AnyPublisher<Result<TestStructure, Error>, Never> in .just(.failure(error)) }
            .sink { result = $0; expectation.fulfill() }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.isSuccess)
        XCTAssertEqual(result!.error as! RequestError, RequestError.decodingError)
    }
}
