//
//  ExtGarmentList+UITableViewDataSource.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit


extension GarmentList: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
      
      
      return garments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      var cell = self.tableView.dequeueReusableCell(withIdentifier: "CharacterListCustomCell_SBID") as? CharacterListCustomCell
      
      if cell == nil {
          cell = UITableViewCell(style:.default, reuseIdentifier:"CharacterListCustomCell_SBID") as? CharacterListCustomCell
      }
  
      var character: BBCharacter?
    
      if isFiltering {
          //candy = filteredCandies[indexPath.row]
          character = self.characters[indexPath.row]
      } else {
          character = self.characters[indexPath.row]
      }
      //print(character!)
      //print("BBCharacter : \(String(describing: character?.charName)) at index.row == \(indexPath.row)")
      cell?.characterImageView.image = UIImage(data: (character?.imageData)!)
      cell?.characterName.text = character?.charName
      
      return cell!
  }
}



