//
//  ViewController.swift
//  DispatchGroups
//
//  Created by Muhammad Wasiq  on 16/04/2024.
//

import UIKit

class ViewController: UIViewController {
    
    let waitArray: [TimeInterval] = [1, 3, 5, 7, 2, 7]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getData()
    }
    
    func getData() {
        let group = DispatchGroup()
        
        for number in waitArray {
            group.enter()   
            print("Entering Group with number: \(number)")
            DispatchQueue.global().asyncAfter(deadline: .now() + number, execute: {
                group.leave()
                print("Leaving Group for number: \(number)")
            })
        }
        
        group.notify(queue: .main, execute: {
            print("Done with All Operations!")
            self.view.backgroundColor = .blue
        })
    }

}

