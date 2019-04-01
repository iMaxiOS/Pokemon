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
    
    let visualEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let visual = UIVisualEffectView(effect: blur)
        return visual
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
    
    private func dismissInfoView(pokemon: Pokemon?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffect.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (_) in
            self.infoView.removeFromSuperview()
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleInfoView))
        visualEffect.addGestureRecognizer(gesture)
    }
    
    @objc private func searchHandle() {
        print("Pokemon")
    }
    
    @objc private func handleInfoView() {
        dismissInfoView(pokemon: nil)
    }
}

extension PokemonController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyborad.pokemonCell, for: indexPath) as! PokemonCell
        
        cell.pokemon = pokemon[indexPath.item]
        cell.delegate = self
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

extension PokemonController: PokemonCellDelegate {
    
    func presentInfoView(pokemon: Pokemon) {
        
        view.addSubview(visualEffect)
        visualEffect.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
        view.addSubview(infoView)
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 500)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        infoView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        infoView.alpha = 0
        infoView.delegate = self
        infoView.pokemon = pokemon
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffect.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
    }
}

extension PokemonController: InfoViewDelegate {
    func dismissPokemon(pokemon: Pokemon?) {
        dismissInfoView(pokemon: pokemon)
    }
}
