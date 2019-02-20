//
//  MemeCollectionViewController.swift
//  memeTest
//
//  Created by Sara Alomran on 18/01/2019.
//  Copyright © 2019 Sara Alomran. All rights reserved.
//


import UIKit
private let reuseIdentifier = "memeCollectionCell"
class MemeCollectionViewController: UICollectionViewController {
    
// Properties//--------------------------------------------------

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//IB Outlets--------------------------------------------------

@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
//--------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //collection spacing
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
//--------------------------------------------------


    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        collectionView?.reloadData()
    }
//--------------------------------------------------


    
    
//--------------------------------------------------
//UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.memes.count
    }

//--------------------------------------------------

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
//--------------------------------------------------

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let selectedMeme = appDelegate.memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = selectedMeme
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
