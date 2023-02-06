//
//  ParametersEncoder.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/6.
//

import Foundation

protocol ParametersEncoder {
    func encode<Params: Encodable>(parameters: Params, request: inout URLRequest)
}

final class JsonEncoder: ParametersEncoder {
    func encode<Params>(parameters: Params, request: inout URLRequest) where Params: Encodable {
        guard let data = try? JSONEncoder().encode(parameters) else {
            // TODO: Throw Error
            return
        }
        request.httpBody = data
        if request.allHTTPHeaderFields?["Content-Type"] == nil {
            request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        }
    }
}
