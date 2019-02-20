//
//  MemeTableViewController.swift
//  memeTest
//
//  Created by Sara Alomran on 22/01/2019.
//  Copyright © 2019 Sara Alomran. All rights reserved.
//

import Foundation
import UIKit


private let reuseIdentifier = "memeTableCell"

class MemeTableViewController: UITableViewController {
    
    //--------------------------------------------------

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //--------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    //--------------------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //--------------------------------------------------

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //--------------------------------------------------

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    //--------------------------------------------------

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let memes = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = memes.memedImage
        
        return cell
    }
    //--------------------------------------------------

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.selectedMeme = selectedMeme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
}
