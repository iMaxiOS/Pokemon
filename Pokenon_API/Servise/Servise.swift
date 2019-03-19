//
//  Servise.swift
//  Pokenon_API
//
//  Created by Maxim Granchenko on 3/18/19.
//  Copyright © 2019 Maxim Granchenko. All rights reserved.
//

import UIKit

class Servise {
    
    static let shared = Servise()
    let Base_url = "https://pokedex-bb36f.firebaseio.com/pokemon.json"
    let name = ["anna", "1", "2"]
    
    func fetchPokemon(completion: @escaping ([Pokemon]) -> ()) {
        
        var pokemonArrya = [Pokemon]()
        
        guard let url = URL(string: Base_url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fatch data task error, ", error.localizedDescription)
                return
            }

            guard let data = data  else { return }
            
            do {
                guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else { return }
                
                for (key, result) in resultArray.enumerated() {
                    if let dictinary = result as? [String: AnyObject] {
                        let pokemon = Pokemon(id: key, dictinary: dictinary)
                        guard let imageUrl = pokemon.imageUrl else { return }
                        
                        self.fetchImageURL(withImage: imageUrl, complition: { (image) in
                            pokemon.image = image
                            pokemonArrya.append(pokemon)
                            
                            pokemonArrya.sort(by: { (poke1, poke2) -> Bool in
                                return poke1.id! < poke2.id!
                            })
                            
                            completion(pokemonArrya)
                        })
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImageURL(withImage url: String, complition: @escaping(UIImage) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fatch image task error, ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            complition(image)
            
        }.resume()
    }
}
