//
//  Pokemon.swift
//  pokedex
//
//  Created by Çağlar Uslu on 25/08/2017.
//  Copyright © 2017 Çağlar Uslu. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!  
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var attack: String{
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var defense: String{
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    var description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var nextEvolutionName: String{
        if _nextEvolutionName == nil {
            _nextEvolutionName = "--"
        }
        return _nextEvolutionName
    }
    var nextEvolutionId: String{
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = "--"
        }
        return _nextEvolutionLevel
    }
    
    
    
    
    
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON{ response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    var typeString = ""
                    for i in 0...(types.count - 1){
                        if let name = types[i]["name"]  {
                            
                            if i>0 {
                                typeString += "/"
                            }
                            typeString += "\(name.capitalized!)"
                        }
                    }
                    self._type = typeString
                }else{
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0  {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        
                        Alamofire.request(URL_BASE + url).responseJSON{ response in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                
                                
                                if let desc = descDict["description"] as? String{
                                    
                                    let newDescription1 = desc.replacingOccurrences(of: "POKMON", with: "Pokémon")
                                    let newDescription2 = newDescription1.replacingOccurrences(of: "pokmon", with: "pokémon")
                                    self._description = newDescription2
                                    
                                }
                                
                            }
                            
                            completed()
                        }
                        
                        
                    }
                    
                }else{
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"]{
                                    if let level = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                    
                                    
                                }else{
                                    self._nextEvolutionLevel = ""
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            
            completed()
        }
        
        
    }
    
    
    
}














