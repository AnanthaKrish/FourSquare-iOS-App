//
//  OptionsViewController.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 02/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Filter action protocol
protocol FilterActionDelegate {
    func selected(section:VenueSection, sort:VenueSort)
}

// OptionsView controller to show the Filter options
class OptionsViewController: UIViewController {
    
    // MARK: variables
    @IBOutlet weak var sortOption: UISegmentedControl!
    @IBOutlet weak var sectionCell: UICollectionView!
    
    var selectedSection:VenueSection = .trending
    var selectedSort:VenueSort = .sortByDistance
    var filterActionDelegate: FilterActionDelegate?
    var selectedCell: OptionsCollectionViewCell?
    
    let options = ["trending", "topPicks","food","drinks", "coffee", "arts", "outdoors", "sights"]
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCell.delegate = self
        sectionCell.dataSource = self
        sectionCell.register(OptionsCollectionViewCell.self, forCellWithReuseIdentifier: OPTIONS_COLLECTION_VIEW_CELL)
        sortOption.selectedSegmentIndex = selectedSort.rawValue
        sortOption.sendActions(for: .valueChanged)
    }

    // Done button action
    @IBAction func selectAction(_ sender: UIButton) {
        dissmissAction()
    }
    
    // Reset button action
    @IBAction func resetAction(_ sender: UIButton) {
        selectedSection = .trending
        selectedSort = .sortByDistance
        sortOption.selectedSegmentIndex = selectedSort.rawValue
        sortOption.sendActions(for: .valueChanged)
        sectionCell.reloadData()
        dissmissAction()
    }
    
    // Dismiss the options controller
    fileprivate func dissmissAction() {
        filterActionDelegate?.selected(section: selectedSection, sort: selectedSort)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Sort segmet values change action
    @IBAction func SortAction(_ sender: UISegmentedControl) {
        selectedSort = VenueSort(rawValue: sender.selectedSegmentIndex)!
    }
}

// Sections collectionview datasource methods
extension OptionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OPTIONS_COLLECTION_VIEW_CELL, for: indexPath) as? OptionsCollectionViewCell else {
            fatalError(ERROR_DEQUE_CELL_FAILURE)
        }
        
        cell.optinsLabel.text = options[indexPath.row]
        
        if indexPath.row == selectedSection.rawValue {
            cell.isSelected = true
            selectedCell = cell
        } else {
            cell.isSelected = false
        }
        return cell
    }
    
    
}

// Collectionview delegate methods
extension OptionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell?.isSelected = false
        selectedSection = VenueSection(rawValue: indexPath.row)!
    }
}

// Collectionview flowLayout methods
extension OptionsViewController: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80,height: 80)
    }
}
