//
//  PokemonController.swift
//  Pokenon_API
//
//  Created by Maxim Granchenko on 3/17/19.
//  Copyright © 2019 Maxim Granchenko. All rights reserved.
//

import UIKit

class PokemonController: UICollectionViewController {
    
    var pokemon = [Pokemon]()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    struct Storyborad {
        static let pokemonCell = "PokemonCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationViewController()
        fetchPokemon()
    }
    
    func fetchPokemon() {
        Servise.shared.fetchPokemon { (pokemon) in
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configurationViewController() {
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = UIColor.mainPink()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Pokemon"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchHandle))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: Storyborad.pokemonCell)
        
        view.addSubview(infoView)
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 500)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func searchHandle() {
        print("Pokemon")
    }
}

extension PokemonController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyborad.pokemonCell, for: indexPath) as! PokemonCell
        
        cell.pokemon = pokemon[indexPath.item]
        
        return cell
        
    }
}

extension PokemonController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
}
