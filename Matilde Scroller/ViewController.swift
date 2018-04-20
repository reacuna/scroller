//
//  ViewController.swift
//  Matilde Scroller
//
//  Created by Raúl Acuña on 4/19/18.
//  Copyright © 2018 Raúl Acuña. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var colors: [UIColor] = []
    private let rowHeight: CGFloat = 100
    private let initialNumberOfRows = 300
    private let numberOfRowsToAdd = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<initialNumberOfRows {
            colors.append(generateRandomColor())
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.scrollToRow(at: IndexPath(row: colors.count - numberOfRowsToAdd, section: 0), at: UITableViewScrollPosition.middle, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        colors = []
        addSomeMoreColors(36)
        tableView.reloadData()
    }

    private func addSomeMoreColors(_ more: Int) {
        let addCount = colors.count + more
        var currentCount = colors.count
        while (currentCount < addCount) {
            colors.append(generateRandomColor())
            currentCount += 1
        }
    }

    private func generateRandomColor() -> UIColor {
        let hue: CGFloat = ( CGFloat(arc4random() % 256) / 256.0)
        let saturation: CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let brightness: CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.8)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") ??
            UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "colorCell")
        if let colorView = cell.contentView.viewWithTag(1) {
            let color = colors[indexPath.row]
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 22
        }
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration.init(actions: [UIContextualAction.init(style: UIContextualAction.Style.normal, title: NSLocalizedString("Change Color", comment: "Change color"), handler: {
            [weak wSelf = self] _,_,completion in
            guard let strongSelf = wSelf else {
                completion(false)
                return
            }
            strongSelf.colors[indexPath.row] = strongSelf.generateRandomColor()
            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            completion(true)
        })])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration.init(actions: [UIContextualAction.init(style: UIContextualAction.Style.destructive, title: NSLocalizedString("Delete", comment: "delete"), handler: {
            [weak wSelf = self] (_, _, completion) in
            guard let strongSelf = wSelf else {
                completion(false)
                return
            }
            strongSelf.colors.remove(at: indexPath.row)
            strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        })])
    }

}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let threshold = contentHeight - rowHeight * CGFloat(numberOfRowsToAdd)
        if (actualPosition >= threshold) {
            addSomeMoreColors(numberOfRowsToAdd)
            tableView.reloadData()
        }
    }

}

