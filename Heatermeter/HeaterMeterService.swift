//
//  HeaterMeterService.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation
import CodableCSV

class HeaterMeterService {
    enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    fileprivate struct Request {
        let device: any Device
        let path: RequestPath
        let queryParameters: [String: String]
        let headers: [String: String]
        let method: RequestMethod
        let body: Data?
        
        init(device: any Device, path: RequestPath, method: RequestMethod, queryParameters: [String: String] = [:], headers: [String: String] = [:], body: Data? = nil) {
            self.device = device
            self.path = path
            self.method = method
            self.queryParameters = queryParameters
            self.headers = headers
            self.body = body
        }
    }
    
    fileprivate enum RequestPath: String {
        case status = "/luci/lm/api/status"
        case graph = "/luci/lm/hist"
        case login = "/luci/admin/lm"
    }
    
    let device: AuthedDevice
    
    init(device: AuthedDevice) {
        self.device = device
    }
    
    public func status() async throws -> CurrentStatus {
        let request = Request(device: self.device,
                              path: .status,
                              method: .get)
        let data = try await Self.perform(request: request).data
        let model = try JSONDecoder().decode(CurrentStatus.self, from: data)
        return model
    }
    
    public func graph() async throws -> [GraphSample] {
        let request = Request(device: self.device,
                              path: .graph,
                              method: .get)
        let data = try await Self.perform(request: request).data
        let model = try CSVDecoder().decode([GraphSample].self, from: data)
        return model
    }
    
    public static func getAPIKey(device: CredentialedDevice) async throws -> String? {
        let body = "luci_username=root&luci_password=\(device.password)"
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?
            .data(using: .utf8)
        let request = Request(device: device,
                              path: .login,
                              method: .post,
                              headers: ["Content-Type": "application/x-www-form-urlencoded"],
                              body: body)
        
        let response = try await Self.perform(request: request)
        guard let responseBody = String (data: response.data, encoding: .utf8) else {
            return nil
        }
        
        let matches = responseBody.match("var lm_apikey = \"(.*)\";")
        
        return matches.first?[1]
    }
    
    private func get(_ request: RequestPath) async throws -> (data: Data, response: URLResponse) {
        let host = device.host
        
        var urlComponents = URLComponents()
        urlComponents.host = host
        urlComponents.path = request.rawValue
        urlComponents.scheme = "http"
        
        guard let url = urlComponents.url else {
            throw HeaterMeterServiceError.failedToCreateURL(urlComponents)
        }
        
        return try await URLSession.shared.data(from: url)
    }
    
    private static func perform(request: Request) async throws -> (data: Data, response: URLResponse){
        var urlComponents = URLComponents()
        urlComponents.host = request.device.host
        urlComponents.path = request.path.rawValue
        urlComponents.scheme = "http"
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in request.queryParameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw HeaterMeterServiceError.failedToCreateURL(urlComponents)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        
        return try await URLSession.shared.data(for: urlRequest)
    }
}

enum HeaterMeterServiceError: Error {
    case failedToCreateURL(URLComponents)
}

extension String {
    func match(_ regex: String) -> [[String]] {
        let nsString = self as NSString
        return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, nsString.length)).map { match in
            (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
        } ?? []
    }
}
