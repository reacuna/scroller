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
    private let initialNumberOfRows = 100
    private let numberOfRowsToAdd = 32

    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<initialNumberOfRows {
            colors.append(generateRandomColor())
        }
        tableView.showsVerticalScrollIndicator = false;
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.scrollToRow(at: IndexPath(row: colors.count - numberOfRowsToAdd * 2, section: 0), at: UITableView.ScrollPosition.middle, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        colors = []
        let _ = addSomeMoreColors(initialNumberOfRows)
        tableView.reloadData()
    }
    
    func addColorsToTable(_ table: UITableView, _ more: Int) {
        let updatedIndexes = addSomeMoreColors(more)
        tableView.beginUpdates()
        tableView.insertRows(at: updatedIndexes, with: .bottom)
        tableView.endUpdates()
    }

    private func addSomeMoreColors(_ more: Int) -> [IndexPath] {
        let addCount = colors.count + more
        var currentCount = colors.count
        var updatedIndexPaths: [IndexPath] = [];
        while (currentCount < addCount) {
            colors.append(generateRandomColor())
            updatedIndexPaths.append(IndexPath(item: currentCount - 1, section: 0))
            currentCount += 1
        }
        return updatedIndexPaths;
    }

    private func generateRandomColor() -> UIColor {
        let hue: CGFloat = ( CGFloat(arc4random() % 256) / 256.0)
        let saturation: CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        let brightness: CGFloat = ( CGFloat(arc4random() % 128) / 256.0 ) + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.8)
    }
    
    private func updateColor(atIndexPath indexPath: IndexPath) {
        self.colors[indexPath.row] = generateRandomColor();
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") ??
            UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "colorCell")
        if let colorView = cell.contentView.viewWithTag(1) {
            let color = colors[indexPath.row]
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 22
        }
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    private func getUpdateActions(_ indexPath: IndexPath) -> Array<UIContextualAction> {
        let updateColorAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: NSLocalizedString("Change Color", comment: "Change color"), handler: {
            [weak wSelf = self] _,_,completion in
            guard let strongSelf = wSelf else {
                completion(false)
                return
            }
            strongSelf.updateColor(atIndexPath: indexPath);
            completion(true)
        });
        updateColorAction.backgroundColor = UIColor.init(white: 1, alpha: 0);
        return [updateColorAction];
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = getUpdateActions(indexPath)
        return UISwipeActionsConfiguration.init(actions: actions)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = getUpdateActions(indexPath);
        return UISwipeActionsConfiguration.init(actions: actions)
    }

}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let totalNumberOfRows = scrollView.contentSize.height / rowHeight
        let topMostVisibleRowIndex = floor(scrollView.contentOffset.y / rowHeight);
        let totalVisibleRows = ceil(scrollView.frame.height / rowHeight);
        let rowsLeftToShow = totalNumberOfRows - totalVisibleRows - topMostVisibleRowIndex;
        if (rowsLeftToShow <= CGFloat(2 * numberOfRowsToAdd)) {
            addColorsToTable(tableView, numberOfRowsToAdd)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.prepare()
        self.updateColor(atIndexPath: indexPath);
        feedbackGenerator.selectionChanged()
    }

}
