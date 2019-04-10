//
//  Pokemon.swift
//  Pokenon_API
//
//  Created by Maxim Granchenko on 3/17/19.
//  Copyright © 2019 Maxim Granchenko. All rights reserved.
//

import UIKit

struct EvolutionChain {
    var evolutionArray: [[String: AnyObject]]?
    var evolutionAds = [Int]()
    
    init(evolutionArray: [[String: AnyObject]]) {
        self.evolutionArray = evolutionArray
        self.evolutionAds = setEvolutionIds()
    }
    
    func setEvolutionIds() -> [Int] {
        var result = [Int]()
        
        evolutionArray?.forEach({ (dictinary) in
            if let isString = dictinary["id"] as? String {
                guard let id = Int(isString) else { return }
                if id <= 151 {
                    result.append(id)
                }
            }
        })
        return result
    }
}

class Pokemon {
    var name: String?
    var imageUrl: String?
    var image: UIImage?
    var id: Int?
    var weight: Int?
    var height: Int?
    var defense: Int?
    var attack: Int?
    var description: String?
    var type: String?
    var baseExperience: Int?
    var evolutionChain: [[String: AnyObject]]?
    var evoArrray = [Pokemon]()
    
    init(id: Int, dictinary: [String: AnyObject]) {
        
        self.id = id
        
        if let name = dictinary["name"] as? String {
            self.name = name
        }
        
        if let imageUrl = dictinary["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let weight = dictinary["weight"] as? Int {
            self.weight = weight
        }
        
        if let height = dictinary["height"] as? Int {
            self.height = height
        }
        
        if let defense = dictinary["defense"] as? Int {
            self.defense = defense
        }
        
        if let attack = dictinary["attack"] as? Int {
            self.attack = attack
        }
        
        if let description = dictinary["description"] as? String {
            self.description = description
        }
        
        if let type = dictinary["type"] as? String {
            self.type = type.capitalized
        }
        
        if let evolutionChain = dictinary["evolutionChain"] as? [[String: AnyObject]] {
            self.evolutionChain = evolutionChain
        }
    }
}
