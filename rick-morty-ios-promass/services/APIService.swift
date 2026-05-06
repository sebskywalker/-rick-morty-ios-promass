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
    
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Error de red
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Validar data
            guard let data = data else {
                return
            }
            
            // Decodificación en contexto concurrente (Swift 6 safe)
            Task {
                do {
                    let decoded = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    
                    await MainActor.run {
                        completion(.success(decoded.results))
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
