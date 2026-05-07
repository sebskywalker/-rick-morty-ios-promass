//
//  APIService.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import Foundation

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    private let baseURL = "https://rickandmortyapi.com/api/character"
    
    func fetchCharacters(
        from urlString: String? = nil,
        completion: @escaping (Result<CharacterResponse, Error>) -> Void
    ) {
        let urlToUse = urlString ?? baseURL
        
        guard let url = URL(string: urlToUse) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                return
            }
            
            Task {
                do {
                    let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    
                    await MainActor.run {
                        completion(.success(decoded))
                    }
                } catch {
                    await MainActor.run {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func searchCharacters(
        name: String,
        completion: @escaping (Result<CharacterResponse, Error>) -> Void
    ) {
        let searchURL = "\(baseURL)/?name=\(name)"
        
        guard let encodedURL = searchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                return
            }
            
            Task {
                do {
                    let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    
                    await MainActor.run {
                        completion(.success(decoded))
                    }
                } catch {
                    await MainActor.run {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
}
