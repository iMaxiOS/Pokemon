//
//  PokemonCell.swift
//  Pokenon_API
//
//  Created by Maxim Granchenko on 3/17/19.
//  Copyright © 2019 Maxim Granchenko. All rights reserved.
//

import UIKit

protocol PokemonCellDelegate {
    func presentInfoView(pokemon: Pokemon)
}

class PokemonCell: UICollectionViewCell {
    
    var delegate: PokemonCellDelegate?
    
    var pokemon: Pokemon? {
        didSet {
            nameLabel.text = pokemon?.name?.capitalized
            imageView.image = pokemon?.image
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .groupTableViewBackground
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
   
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "Pokemon"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    private func configureUI() {
    
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addSubview(containerView)
        addSubview(imageView)
        
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 25)
        
        containerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        let longGestureRecognized = UILongPressGestureRecognizer(target: self, action: #selector(handleGesture))
        self.addGestureRecognizer(longGestureRecognized)
    }
    
    @objc fileprivate func handleGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            guard let pokemon = self.pokemon else { return }
            delegate?.presentInfoView(pokemon: pokemon)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
