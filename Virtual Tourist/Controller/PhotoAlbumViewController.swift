//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ahmed Maad on 11/22/20.
//  Copyright © 2020 Next Trend. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Opened photo album view controller")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Number of items in the collection view
        return 10 //should be the number from he data source returned from flicker API or read from DB
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionItem
    
        cell.myImage.image = UIImage(named: "reload")
        cell.backgroundColor = UIColor.cyan
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Handling tap events by deleting pictures
        print("should delete picture from collection view and DB")
    }
    
    @IBAction func loadNewCollection(_ sender: Any) {
        print("Should load new collection")
    }
    
}
