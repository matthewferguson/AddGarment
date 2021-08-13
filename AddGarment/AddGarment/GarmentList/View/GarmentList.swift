//
//  GarmentList.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit

class GarmentList : UIViewController {
    
    
    @IBOutlet var garmetnTableView: UITableView!
    var garments: [GarmentNode] = []
    
    //MARK:- View Controller Lifecycle
    
    override func viewDidLoad() {
    
        
        setupFetchControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupSubViews()
    }
    
    //MARK:- View Customization
    
    private func setupSubViews() {
        
        /*
        self.btnLookup?.layer.cornerRadius = 6
        self.btnLookup?.layer.borderWidth = 1
        self.btnLookup?.layer.borderColor = UIColor.getCustomDarkGreyColor().cgColor
        self.btnLookup?.layer.masksToBounds = true
        self.btnLookup?.clipsToBounds = true
        self.btnLookup?.backgroundColor = UIColor.clear
        */
    
        /*
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.getCustomPurpleColor()
        view.backgroundColor = UIColor.getCustomLightGreyColor()
        */

    }
    
    
    //MARK:- Core Data Fetch Controller
    
    private func setupFetchControllers() {
        do {
                self.garments.removeAll()
                try self.fetchAllCharactersRequestController.performFetch()
                
                let charactersCollection = self.fetchAllCharactersRequestController.fetchedObjects!
            
                for (singleCharacter) in charactersCollection {
                
                    
                    let bbcharacter = BBCharacter(charId: singleCharacter.character_id, portrayedBy: singleCharacter.actor_name, charName: singleCharacter.char_name, occupacyArray: singleCharacter.occupation_array as? Array<String>, imageURL: singleCharacter.occupation_array as? String, imageData: singleCharacter.image_binary?.imageBlob, isImageLoaded: singleCharacter.is_image_loaded, nickname:singleCharacter.nickname, seasonAppearance: singleCharacter.appearance_array as? Array<Int64>,status: singleCharacter.status)
                    
                    self.characters.append(bbcharacter)
                }
            
                if characters.count > 0 {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("Character unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
    
    
    
    
    
    
}

