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
                    
                    Text(character.status)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                    Text(character.species)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "Status", value: character.status)
                    DetailRow(title: "Species", value: character.species)
                    DetailRow(title: "Character ID", value: "\(character.id)")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .padding(.horizontal)
            }
            .padding(.top, 24)
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
