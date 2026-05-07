//
//  FavoritesManager.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//

import Foundation
import CoreData
import UIKit

final class FavoritesManager {
    
    static let shared = FavoritesManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Save Favorite
    
    func saveFavorite(character: Character) {
        
        if isFavorite(characterID: character.id) {
            return
        }
        
        let favorite = FavoriteCharacterEntity(context: context)
        
        favorite.id = Int64(character.id)
        favorite.name = character.name
        favorite.status = character.status
        favorite.species = character.species
        favorite.image = character.image
        
        do {
            try context.save()
            print("✅ Favorito guardado")
        } catch {
            print("❌ Error guardando favorito:", error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Favorites
    
    func fetchFavorites() -> [FavoriteCharacterEntity] {
        
        let request: NSFetchRequest<FavoriteCharacterEntity> = FavoriteCharacterEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Error obteniendo favoritos:", error.localizedDescription)
            return []
        }
    }
    
    // MARK: - Check Favorite
    
    func isFavorite(characterID: Int) -> Bool {
        
        let request: NSFetchRequest<FavoriteCharacterEntity> = FavoriteCharacterEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", characterID)
        
        do {
            let result = try context.fetch(request)
            return !result.isEmpty
        } catch {
            print("❌ Error verificando favorito:", error.localizedDescription)
            return false
        }
    }
    
    // MARK: - Remove Favorite
    
    func removeFavorite(characterID: Int) {
        
        let request: NSFetchRequest<FavoriteCharacterEntity> = FavoriteCharacterEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %d", characterID)
        
        do {
            let result = try context.fetch(request)
            
            if let favoriteToDelete = result.first {
                context.delete(favoriteToDelete)
                
                try context.save()
                
                print("🗑 Favorito eliminado")
            }
            
        } catch {
            print("❌ Error eliminando favorito:", error.localizedDescription)
        }
    }
}
