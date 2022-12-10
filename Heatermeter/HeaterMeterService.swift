//
//  HeaterMeterService.swift
//  Heatermeter
//
//  Created by Gary Kagan on 12/4/22.
//

import Foundation
import CodableCSV

class HeaterMeterService {
    private enum Request: String {
        case status = "/luci/lm/api/status"
        case graph = "/luci/lm/hist"
    }
    
    let device: AuthedDevice
    
    init(device: AuthedDevice) {
        self.device = device
    }
    
    public func status() async throws -> CurrentStatus {
        let data = try await get(.status).data
        let model = try JSONDecoder().decode(CurrentStatus.self, from: data)
        return model
    }
    
    public func graph() async throws -> [GraphSample] {
        let data = try await get(.graph).data
        let model = try CSVDecoder().decode([GraphSample].self, from: data)
        return model
    }
    
    private func get(_ request: Request) async throws -> (data: Data, response: URLResponse) {
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
}

enum HeaterMeterServiceError: Error {
    case failedToCreateURL(URLComponents)
}
