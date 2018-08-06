//
//  QuestionCollectionViewController.swift
//  Jeopardy
//
//  QuestionCollectionViewController class that handles the collection view
//  Collection view is in a container in the game screen view controller
//  Sets the names & colors of the cards that are shown for the game
//  Sets the size of the cell
//  NOTE: the size is hardcoded so it only works on iPadPro (12.9 inch)
//
//  Created by Prathyusha Pillari on 7/23/18.
//  Edited by Prathyusha Pillari on 7/27/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit
import AVFoundation

class QuestionCollectionViewController: UICollectionViewController {
    
    // sound for the button click
    var buttonClickSound = AVAudioPlayer()
    // path to the audio file
    let path = Bundle.main.path(forResource: "buttonClicked", ofType: "mp3")

    // sets colors for our color palette
    let lightGray = UIColor.init(red: 170/225, green: 170/225, blue: 170/225, alpha: 1)
    let red = UIColor.init(red: 244/225, green: 78/225, blue: 66/225, alpha: 1)
    let blue = UIColor.init(red: 65/225, green: 149/225, blue: 224/225, alpha: 1)
    let green = UIColor.init(red: 24/225, green: 206/225, blue: 45/225, alpha: 1)
    let yellow = UIColor.init(red: 188/225, green: 185/225, blue: 20/225, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // sets the cell size
        setCellSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* This method sets the size of the cell
     * It's set to fit the iPad 12.9 inch
     * @returns Nothing.
     */
    func setCellSize(){
        let cellSize = CGSize(width:333 , height:130)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing = 1.5
        layout.minimumInteritemSpacing = 1.5
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.reloadData()
    }

    /* This method sets the num of sections to 4
     * @returns Int: the num of sections
     */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // the number of sections/ colomns is 4
        return 4
    }

    /* This method sets the num of rows to 6
     * @returns Int: the num of rows
     */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // the number of rows is 6
        return 6
    }
    
    /* This method defines what cells can be selected
     * The categories and the buttons that were already played (light gray in color)
     * cannot be selected
     * @returns Bool: true for the cells that can be selected
     */
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        return indexPath.row != 0 && cell.backgroundColor != lightGray
    }
    
    /* This method defines what cells can be selected
     * The categories and the buttons that were already played (light gray in color)
     * cannot be selected
     * @returns Nothing.
     */
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        if(cell.backgroundColor != lightGray){
            perform(#selector(animateCells(_:)), with: cell, afterDelay: TimeInterval(0.2))
            playSound()
            cell.backgroundColor = lightGray
            let path = QuestionPath(categoryIndex: indexPath.section, indexInCategory: indexPath.row-1)
            AppDelegate.gm.chooseQuestion(questionPath: path)
            cell.backgroundColor = lightGray
            performSegue(withIdentifier: "answerStoryboardSegue", sender: self)
        }
    }
    
    /* This method plays the button sound
     * The try catch block is set to handle the error thrown by AVAudioPlayer
     * if the file isnt found
     * @returns Nothing.
     * @exception throws file not found error
     */
    func playSound(){
        do {
            // assings the path to the sound file
            try buttonClickSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            // plays the button click sound
            buttonClickSound.play()
        } catch {
            print("Could not load file")
        }
    }
    
    /* This method animates the button when clicked
     * @returns Nothing.
     */
    @objc func animateCells(_ sender: UICollectionViewCell){
        UICollectionViewCell.animate(withDuration: 0.2, animations: {sender.alpha = 0.0;}) {(_) in sender.alpha = 1.0}
    }

    /* This method sets the cells
     * Called once in the beginning of the game
     * Sets the names and colors
     * @returns UICollectionViewCell: The cell setup
     */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // object of the custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNumber1", for: indexPath) as! CardCollectionViewCell
        // sets the backgroundColor to gray (for the top)
        cell.backgroundColor = UIColor.gray
        // names the cells
        nameTheCells(indexPath: indexPath, cell: cell)
        // sets the color
        setColors(indexPath: indexPath, cell: cell)
        // returns the cell
        return cell
    }
    
    /* This method names the cells
     * @param IndexPath: The index for the cells
     * @param CardCollectionViewCell: The cell that needs the names set
     * @returns Nothing.
     */
    func nameTheCells(indexPath: IndexPath, cell: CardCollectionViewCell){
        switch indexPath.row {
        // sets the category names
        case 0:
            switch indexPath.section {
            case 0:
                cell.categoryLabel.text = AppDelegate.gm.qr.categories[0]
            case 1:
                cell.categoryLabel.text = AppDelegate.gm.qr.categories[1]
            case 2:
                cell.categoryLabel.text = AppDelegate.gm.qr.categories[2]
            case 3:
                cell.categoryLabel.text = AppDelegate.gm.qr.categories[3]
            default:
                cell.categoryLabel.text = "Default"
            }
        // sets the names of the other buttons
        case 1:
            cell.categoryLabel.text = "100"
        case 2:
            cell.categoryLabel.text = "200"
        case 3:
            cell.categoryLabel.text = "300"
        case 4:
            cell.categoryLabel.text = "400"
        case 5:
            cell.categoryLabel.text = "500"
        default:
            cell.categoryLabel.text = "Default"
        }
    }
    
    /* This method colors the cells
     * @param IndexPath: The index for the cells
     * @param CardCollectionViewCell: The cell that needs the names set
     * @returns Nothing.
     */
    func setColors(indexPath: IndexPath, cell: CardCollectionViewCell){
        // sets the colors of the sections
        switch indexPath.section {
        case 0:
            // red color
            cell.backgroundColor = red
        case 1:
            // blue color
            cell.backgroundColor = blue
        case 2:
            // green color
            cell.backgroundColor = green
        case 3:
            // yellow color
            cell.backgroundColor = yellow
        default:
            cell.backgroundColor = UIColor.gray
        }
        // sets a different color for the category row
        // to differentiate from the clickable buttons
        if(indexPath.row == 0){
            cell.backgroundColor = lightGray
            // sets the text color to back for visibility
            cell.categoryLabel.textColor = UIColor.black
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
