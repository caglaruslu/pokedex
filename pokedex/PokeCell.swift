//
//  PokeCell.swift
//  pokedex
//
//  Created by Çağlar Uslu on 25/08/2017.
//  Copyright © 2017 Çağlar Uslu. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImbg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
        
    }
    
    func configureCell(_ pokemon: Pokemon){
        
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        thumbImbg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
        
    }
    
}
