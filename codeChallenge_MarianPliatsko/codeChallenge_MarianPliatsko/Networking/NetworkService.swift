//
//  NetworkService.swift
//  codeChallenge_MarianPliatsko
//
//  Created by mac on 2022-12-10.
//

import Foundation

enum NetworkError: Error {
    case urlIsMissing
    case notFound
    case badResponse
    case unknown
}

protocol NetworkService {
    func request(urlRequest: URLRequest, callback: @escaping (Result<Data, Error>) -> Void)
}

class StubNetworkService: NetworkService {
    func request(urlRequest: URLRequest, callback: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                callback(.failure(NetworkError.unknown))
                return
            }
            guard let url = urlRequest.url else {
                callback(.failure(NetworkError.urlIsMissing))
                return
            }
            if url.absoluteString.hasSuffix("profiles/mine") {
                if let data = self.profilesMineResponse().data(using: .utf8) {
                    callback(.success(data))
                    return
                } else {
                    callback(.failure(NetworkError.badResponse))
                    return
                }
            }
            if url.absoluteString.hasSuffix("profiles/update") {
                if let data = self.profilesMineResponse().data(using: .utf8) {
                    callback(.success(data))
                    return
                } else {
                    callback(.failure(NetworkError.badResponse))
                    return
                }
            }
            
            if url.absoluteString.hasSuffix("password/change") {
                if let data = self.passwordResponse().data(using: .utf8) {
                    callback(.success(data))
                    return
                } else {
                    callback(.failure(NetworkError.badResponse))
                    return
                }
            }
            callback(.failure(NetworkError.notFound))
        }
    }
    
    private func profilesMineResponse() -> String {
        return """
{
    "message": "User Retrieved",
    "data": {
        "firstName": "Marian",
        "userName": "iOS User",
        "lastName": "Goode"
    }
}
"""
    }
    
    private func passwordResponse() -> String {
        return """
{
    "data": {},
    "code": "string",
    "message": "Password Changed",
    "exceptionName": null
}
"""
    }
}
