//
//  ChooseFurnitureVC.swift
//  AR Home Design
//
//  Created by Danit on 15/06/2022.
//

import UIKit

class ChooseFurnitureVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let furniturePictures = FurniturePicture()
    var sofaBoolArray : Array<Bool> = []
    var tableBoolArray : Array<Bool> = []
    var lampBoolArray : Array<Bool> = []

    
    var sofaData = FurniturePicture().sofa
    var tableData = FurniturePicture().table
    var lampData = FurniturePicture().lamp

    var filter: Array<String> = []
    var filter2: Array<String> = []
    var filter3: Array<String> = []

    var arrayOfChosenSofa:Array<String>  = []
    var arrayOfChosenTable:Array<String>  = []
    var arrayOfChosenLamp:Array<String>  = []

    var arrayOfChosen:Array<String>  = []
    
    var collectionType = "sofa"
    var data = FurniturePicture().sofa.count
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for _ in 0...sofaData.count - 1{
            sofaBoolArray.append(false)
        }
        
        
        for _ in 0...tableData.count - 1{
            tableBoolArray.append(false)
        }
        
        for _ in 0...lampData.count - 1{
            lampBoolArray.append(false)
        }
        
        
        
        let layout = UICollectionViewFlowLayout()
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(SofaCollectionViewCell.nib() , forCellWithReuseIdentifier: SofaCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionType == "sofa"{
            if sofaBoolArray[indexPath.row] == true{
                sofaBoolArray[indexPath.row] = false
                filter = arrayOfChosenSofa.filter {$0 != FurniturePicture().sofa[indexPath.row]}
                arrayOfChosenSofa.removeAll()
                arrayOfChosenSofa = filter
    
                print(filter.count)
                print(arrayOfChosenSofa.count)
                
            }else{
                sofaBoolArray[indexPath.row] = true
                arrayOfChosenSofa.append (FurniturePicture().sofa[indexPath.row])
                filter = arrayOfChosenSofa
                print(filter)
                print(filter.count)
            }
            
            
        }else if collectionType == "table"{
            if tableBoolArray[indexPath.row] == true{
                tableBoolArray[indexPath.row] = false
                filter2 = arrayOfChosenTable.filter {$0 != FurniturePicture().table[indexPath.row]}
                arrayOfChosenTable.removeAll()
                arrayOfChosenTable = filter2
                
            }else{
                tableBoolArray[indexPath.row] = true
                arrayOfChosenTable.append (FurniturePicture().table[indexPath.row])
            }
        }else if collectionType == "lamp"{
            if lampBoolArray[indexPath.row] == true{
                lampBoolArray[indexPath.row] = false
                filter3 = arrayOfChosenLamp.filter {$0 != FurniturePicture().lamp[indexPath.row]}
                arrayOfChosenLamp.removeAll()
                arrayOfChosenLamp = filter3
                
            }else{
                lampBoolArray[indexPath.row] = true
                arrayOfChosenLamp.append (FurniturePicture().lamp[indexPath.row])
            }
        }
   
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        if collectionType == "sofa"{
            data = sofaData.count
            
        }else if collectionType == "table"{
            data = tableData.count
            
        }else if collectionType == "lamp"{
            data = lampData.count
        }
        
        return data
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SofaCollectionViewCell.identifier, for: indexPath) as! SofaCollectionViewCell
        
        // logic
        
        if collectionType == "sofa"{
            cell.configure(imageCell: UIImage (named: furniturePictures.sofa[indexPath.row])! , addRemoveBool: sofaBoolArray[indexPath.row])
            
        }else if collectionType == "table"{
            cell.configure(imageCell: UIImage (named: FurniturePicture().table[indexPath.row])!, addRemoveBool: tableBoolArray[indexPath.row])
            
        }else if collectionType == "lamp"{
            cell.configure(imageCell: UIImage (named: FurniturePicture().lamp[indexPath.row])!, addRemoveBool: lampBoolArray[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ARRoomVC {
            
            print(filter)
            arrayOfChosen = arrayOfChosenTable + arrayOfChosenLamp + arrayOfChosenSofa
            vc.imageToPass = arrayOfChosen
            
        }
    }
    
    
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToARRoomVC", sender: self)
        print("++++++++++++++++")
    }
    
    
    @IBAction func sofaCollection(_ sender: UIBarButtonItem) {
        collectionType = "sofa"
        sofaData = FurniturePicture().sofa
        collectionView.reloadData()
    }
    
    @IBAction func lampCollection(_ sender: UIBarButtonItem) {
                collectionType = "lamp"
                lampData = FurniturePicture().lamp
                collectionView.reloadData()
    }
    
    @IBAction func tableCollection(_ sender: UIBarButtonItem) {
        collectionType = "table"
        tableData = FurniturePicture().table
        collectionView.reloadData()
    }
    
    @IBAction func wallpaperCollection(_ sender: UIBarButtonItem) {
        //        collectionType = "wallpaper"
        //        data = FurniturePicture().sofa
        //        collectionView.reloadData()
    }
}

