//
//  GameViewController.swift
//  GameOfLife
//
//  Created by Elizabeth Wingate on 7/27/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import SpriteKit

class GameViewController: UIViewController {
    
    let lifeSize = 15
    
    var grid = [Cell]()
    var gridView: UIView!
    
    var timeInterval = 0.25
    var timer = Timer()
    
    var generations = 0
    var running = false
    
    // Outlets
    @IBOutlet weak var generationsLabel: UILabel!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var darkMode: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var genNum: UILabel!
    @IBOutlet weak var GOF: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        
        //setting up how wide and long the grid will be
        for x in 0...(23) {
            for y in 0...(40) {
                grid.append(Cell(x: x, y: y, state: false))
                print(y)
            }
        }
        // setting up grid details
        for i in 0...grid.count-1 {
            let cell = grid[i] //cells turning into big grid
            cell.gridView.frame = CGRect(x: cell.x*lifeSize+25, y: cell.y*lifeSize+100, width: lifeSize, height: lifeSize) // cell sizes on grid
            resetColor(cell: cell) // setting color to gray and white
            cell.gridView.tag = i
            
            // when someone taps on grid it recognizes
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            cell.gridView.addGestureRecognizer(recognizer)
            view.addSubview(cell.gridView)
        }
    }
    
    //Setting cell colors gray and white because cells are dead
    func resetColor(cell: Cell) {
        if cell.x % 2 == 0 && cell.y % 2 == 0 || cell.x % 2 == 1 && cell.y % 2 == 1{ // dead cells reset to gray and white pattern
            cell.gridView.backgroundColor = UIColor.lightGray
        } else {
            cell.gridView.backgroundColor = UIColor.white
        }
    }
    
    //when someone manually inputs the cells to run then it gets handled here
    @objc func handleTap(sender: UIGestureRecognizer) {
        // handling code
        let senderCell = grid[(sender.view?.tag)!]
        if senderCell.state == false {
            senderCell.state = true
            senderCell.gridView.backgroundColor = UIColor.systemPurple //1/3 custom feature: changed cell color
        } else { //someone taps again to change back
            senderCell.state = false
            resetColor(cell: senderCell)
        }
    }
    
    // running the game in the grid
    @objc func runGeneration() {
        for i in 0...grid.count-1 {
            let cell = grid[i]
            let neighbors = checkForNeighbors(cell: cell)
            if cell.state == true {
                print("number of neighbors \(neighbors)")
                if neighbors < 2 { //if neighbors is less then two
                   cell.live = false // cell die
                }
                if neighbors == 2 || neighbors == 3 { //if neighbors equal 2 + 3
                    cell.live = true // cell live
                }
                if neighbors > 3 { // if neighbors more then 3
                    cell.live = false // cell die
                }
                
            } else if neighbors == 3 { // neighbors equal to 3
                cell.live = true // cell live
            }
        }
        for j in 0...grid.count-1 {
            let cell = grid[j]
            if cell.live == true { // cell live, it stays purple
                cell.state = true
                cell.gridView.backgroundColor = UIColor.systemPurple // 1/3 custom feature: changed cell color
            } else {
                cell.state = false // if cell dead
                resetColor(cell: cell) // reset cell color
            }
        }
        generations += 1 // add one to generation here
        generationsLabel.text = String(generations) // changing gen label here
    }
    
    //Checking the cells around to see if they need to live or die
    func checkForNeighbors(cell: Cell) -> Int {
        var neighbors = 0
        for i in 0...grid.count-1 {
            if grid[i].state == true {
                if grid[i].x == cell.x && grid[i].y == cell.y+1 { //below
                    neighbors += 1
                }
                if grid[i].x == cell.x && grid[i].y == cell.y-1 { //above
                    neighbors += 1
                }
                if grid[i].y == cell.y && grid[i].x == cell.x+1 { //right
                    neighbors += 1
                }
                if grid[i].y == cell.y && grid[i].x == cell.x-1 { //left
                    neighbors += 1
                }
                if grid[i].y == cell.y+1 && grid[i].x == cell.x+1 { //bottom right
                    neighbors += 1
                }
                if grid[i].y == cell.y+1 && grid[i].x == cell.x-1 { //bottom left
                    neighbors += 1
                }
                if grid[i].y == cell.y-1 && grid[i].x == cell.x+1 { //top right
                    neighbors += 1
                }
                if grid[i].y == cell.y-1 && grid[i].x == cell.x-1 { //top left
                    neighbors += 1
                }
            }
        }
        return neighbors
    }
    
    //Start the timer for animations
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runGeneration), userInfo: nil, repeats: true)
    }
    
    //Reseting Timer for animations
    func resetTimer(){
        timer.invalidate()
        startTimer()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        startTimer() //calling start timer
        speedSlider.isEnabled = true //making sure the slider is enabled
    }
    
    //Restarting the game, and generations reset
    @IBAction func restartButtonPressed(_ sender: Any) {
        
        timer.invalidate() //invalidating the timer
        //resetting all the cells in grid
        for i in 0...grid.count-1 {
            let cell = grid[i]
            cell.state = false
            resetColor(cell: cell)
        }
        //resetting gens and label
        generations = 0
        generationsLabel.text = "0"
    }

    
    // 2/3 Custom feature: Speed Slider
    @IBAction func speedChanged(_ sender: UISlider) {
        timeInterval = Double(0.5 - 5.0)
        resetTimer()
        startTimer()
    }
    
    // 3/3 Custom feature: dark mode switch
    @IBAction func darkModeSwitched(_ sender: Any) {
        if darkModeSwitch.isOn == true { //setting dark mode
            view.backgroundColor = UIColor.black
            darkMode.textColor = UIColor.white
            generationsLabel.textColor = UIColor.white
            GOF.textColor = UIColor.white
            genNum.textColor = UIColor.white
        } else { //back to light mode
            view.backgroundColor = UIColor.white
            darkMode.textColor = UIColor.darkGray
            generationsLabel.textColor = UIColor.darkGray
            GOF.textColor = UIColor.black
            genNum.textColor = UIColor.darkGray
        }
    }
    
 }
