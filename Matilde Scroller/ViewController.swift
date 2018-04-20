//
//  ViewController.swift
//  Matilde Scroller
//
//  Created by Raúl Acuña on 4/19/18.
//  Copyright © 2018 Raúl Acuña. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var colors: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        colors = Array(repeating: 3, count: 20)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") ??
            UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "colorCell")
        if let colorView = cell.contentView.viewWithTag(1) {
            colorView.backgroundColor = UIColor.init(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.8)
            colorView.layer.cornerRadius = 30
            
        }
        return cell
    }


}

extension ViewController: UITableViewDelegate {

}

