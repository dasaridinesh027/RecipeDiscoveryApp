//
//  APIManager.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func getDataFromEndpoint(_ endPoint: String) async throws -> [Recipe]{
        
        guard let url = URL(string: endPoint) else {
            throw Errors.invalidURL
        }
        print("URL is \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                throw Errors.serverError(httpResponse.statusCode)
            }
            
            //            if let jsonString = String(data: data, encoding: .utf8) {
            //                print(" Raw JSON response:\n\(jsonString)")
            //            }
            
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            print("recipes:::\(recipes)")
            return recipes.recipes
            
        }
        catch _ as DecodingError {
            throw Errors.decodingFailed
        }
        catch  {
            throw Errors.requestFailed
        }
    }
    
    
    
    func getData<T: Decodable>(_ type: T.Type, from endpoint: String) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw Errors.invalidURL
        }
        print("URL is \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw Errors.responseError
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        }
        catch _ as DecodingError {
            throw Errors.decodingFailed
        }
        catch  {
            throw Errors.requestFailed
        }
    }
    
    
    func postData<T: Decodable, U: Encodable>(_ type: T.Type, to endpoint: String, body: U) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw Errors.invalidURL
        }
        print("URL is \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw Errors.responseError
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        }
        catch _ as DecodingError {
            throw Errors.decodingFailed
        }
        catch  {
            throw Errors.requestFailed
        }
    }
    
    
    
}
