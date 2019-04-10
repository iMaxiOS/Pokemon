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
    var filterPokemon = [Pokemon]()
    var inSearchMode = false
    var searchBar: UISearchBar!
    
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
    
    private func showPokemonInfoViewController(pokemon: Pokemon) {
        let controller = PokemonInfoController()
        controller.pokemon = pokemon
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func configureSearchBar(isShow: Bool) {
        if isShow {
            searchBar = UISearchBar()
            searchBar.placeholder = " search Pokemon"
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = .white
            searchBar.layoutIfNeeded()
            
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        } else {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchHandle))
            navigationItem.rightBarButtonItem?.tintColor = .white
            inSearchMode = false
            collectionView.reloadData()
        }
    }
    
    private func fetchPokemon() {
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
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let pokemon = pokemon else { return }
            self.showPokemonInfoViewController(pokemon: pokemon)
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
        configureSearchBar(isShow: true)
    }
    
    @objc private func handleInfoView() {
        dismissInfoView(pokemon: nil)
    }
}

extension PokemonController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filterPokemon.count : pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyborad.pokemonCell, for: indexPath) as! PokemonCell
        
        cell.pokemon = inSearchMode ? filterPokemon[indexPath.row] : pokemon[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poke = inSearchMode ? filterPokemon[indexPath.row] : pokemon[indexPath.row]
        
        var evolutionArray = [Pokemon]()

        if let evoChain = poke.evolutionChain {
            let evoPokemon = EvolutionChain(evolutionArray: evoChain)
            let evoId = evoPokemon.evolutionAds
            
            evoId.forEach { (id) in
                evolutionArray.append(pokemon[id - 1])
            }
            poke.evoArrray = evolutionArray
        }

        showPokemonInfoViewController(pokemon: poke)
        
    }
}

extension PokemonController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        configureSearchBar(isShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filterPokemon = pokemon.filter{( $0.name?.range(of: searchText.lowercased()) != nil)}
            collectionView.reloadData()
        }
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
        
        configureSearchBar(isShow: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(visualEffect)
        visualEffect.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
        view.addSubview(infoView)
        infoView.configureUIView()
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
