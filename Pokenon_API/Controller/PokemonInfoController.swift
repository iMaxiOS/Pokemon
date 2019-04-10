//
//  PokemonInfoController.swift
//  Pokenon_API
//
//  Created by Maxim Granchenko on 4/2/19.
//  Copyright © 2019 Maxim Granchenko. All rights reserved.
//

import UIKit

class PokemonInfoController: UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let firstImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let secondImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let infoView: InfoView = {
        let info = InfoView()
        info.configureForInfoController()
        return info
    }()
    
    let evoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        
        let evoLabel = UILabel()
        evoLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        evoLabel.text = "Next Evolution: Charletion"
        evoLabel.textColor = .white
        
        view.addSubview(evoLabel)
        evoLabel.translatesAutoresizingMaskIntoConstraints = false
        evoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        evoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    var pokemon: Pokemon? {
        didSet {
            navigationItem.title = pokemon?.name?.capitalized
            imageView.image = pokemon?.image
            firstImageView.image = pokemon?.image
            secondImageView.image = pokemon?.image
            infoLabel.text = pokemon?.description
            infoView.pokemon = pokemon
            
            if let evoArray = pokemon?.evoArrray {
                if evoArray.count > 1 {
                    firstImageView.image = evoArray[0].image
                    secondImageView.image = evoArray[1].image
                } else {
                    firstImageView.image = evoArray[0].image
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateUI()
    }
    
    func configurateUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 44, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        infoLabel.anchor(top: view.topAnchor, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        infoLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(evoContainerView)
        evoContainerView.anchor(top: infoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 8, paddingBottom: 0, paddingRight: -8, width: 0, height: 50)
        
        view.addSubview(firstImageView)
        firstImageView.anchor(top: evoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        
        view.addSubview(secondImageView)
        secondImageView.anchor(top: evoContainerView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: -32, width: 120, height: 120)
    }
}
