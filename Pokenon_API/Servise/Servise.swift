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
    func fetchPokemon() {
        
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
                        print(pokemon.name)
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
        
    }
}
