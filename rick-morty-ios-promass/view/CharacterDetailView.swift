//
//  CharacterDetailView.swift
//  rick-morty-ios-promass
//
//  Created by seb's on 5/6/26.
//
import SwiftUI

struct CharacterDetailView: View {
    
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 220, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(radius: 8)
                
                VStack(spacing: 8) {
                    
                    Text(character.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Character ID: \(character.id)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Text(character.status)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Species", value: character.species)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    if let gender = character.gender {
                        DetailRow(title: "Gender", value: gender)
                    }
                    
                    if let origin = character.origin?.name {
                        DetailRow(title: "Origin", value: origin)
                    }
                    
                    if let location = character.location?.name {
                        DetailRow(title: "Location", value: location)
                    }
                    
                    if let episodes = character.episode {
                        DetailRow(title: "Episodes", value: "\(episodes.count)")
                    }
                    
                    if let type = character.type, !type.isEmpty {
                        DetailRow(title: "Type", value: type)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
            }
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
