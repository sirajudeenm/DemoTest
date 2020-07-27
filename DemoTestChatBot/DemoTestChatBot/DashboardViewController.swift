//
//  DashboardViewController.swift
//  DemoTestChatBot
//
//  Created by Apple on 25/07/20.
//  Copyright © 2020 ixm. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet var viewCovid19: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewCovid19.addGestureRecognizer(tap)
       // self.viewCovid19.setCardLayoutView()

        // Do any additional setup after loading the view.
    }
    

   
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        self.navigationController?.pushViewController(VC!, animated: true)
    }

}

extension UIView {
    func customAnimtation() {
        
    }
}
