//
//  HomeViewController.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 31/08/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// HomeView controller
class HomeViewController: UIViewController {

    // Credentials with FourSquare app secrets
    var credentials = Credentials(with: FOURSQUARE_CLIENT_ID, clientSecret: FOURSQUARE_CLIENT_SECRET)
    
    // ViewModel to handle the data for the homeviewcontroller
    lazy var recViewModel: RecViewModel = {
        return RecViewModel(with: credentials, locationController: UserLocationController())
    }()
    
    // ColectionView
    private lazy var homeCollectionView: UICollectionView = {
        let spacing: CGFloat = 16.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HOME_COLLECTION_VIEW_CELL)
        return collectionView
    }()
    
    // Error view
    lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        return errorView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCollectionView()
        setViewModel()
    }
    
    // Action to show the Filters
    @IBAction func showOptions(_ sender: Any) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: OPTIONS_VIEW_CONTROLLER) as! OptionsViewController
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.filterActionDelegate = self
        controller.selectedSort = recViewModel.selectedSort
        controller.selectedSection = recViewModel.selectedSection
        present(controller, animated: true, completion: nil)
        
    }
    
    // SetUp the collectionView
    fileprivate func setUpCollectionView() {

        self.view.addSubview(homeCollectionView)
        configureConstraints()
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.backgroundColor = .white
        
        if #available(iOS 10.0, *) {
            homeCollectionView.refreshControl = refreshControl
        } else {
            homeCollectionView.addSubview(refreshControl)
        }

        refreshControl.addTarget(self, action: #selector(refreshItemsData), for: .valueChanged)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)]
        
        refreshControl.attributedTitle = NSAttributedString(string: REFRESH_LOADER, attributes: attributes)
        refreshControl.beginRefreshing()
        self.homeCollectionView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height), animated: true)
        
        
        
        self.view.addSubview(errorView)
        errorView.isHidden = true
        
        errorView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150).isActive = true
        errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        errorView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        
        errorView.reloadViewClosure = { [unowned self] in
            
            self.errorView.isHidden = true
            self.refreshControl.beginRefreshing()
            self.homeCollectionView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl.frame.height-100), animated: true)
            self.recViewModel.fetchAllRecomendations(offset: 0)
        }
    }
    
    // refresh controller action
    @objc private func refreshItemsData() {
        self.errorView.isHidden = true
        recViewModel.fetchAllRecomendations(offset: 0)
    }
    
    // Add contraints
    private func configureConstraints() {
        let constraints = [
            homeCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // SetUp the Viewmodel methods
    func setViewModel() {
        
        recViewModel.reloadViewClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.homeCollectionView.reloadData()
                self?.errorView.isHidden = true
            }
        }
        
        recViewModel.showAlertClosure = { (meta, response, message) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                print(meta?.errorDetail ?? "",response, message)
                self.errorView.isHidden = false
            }
        }
    }
    
}

// CollectionView Datasource methods
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.recViewModel.recomsArray.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HOME_COLLECTION_VIEW_CELL, for: indexPath) as? HomeCollectionViewCell else {
            fatalError(ERROR_DEQUE_CELL_FAILURE)
        }
        
        cell.venueCellViewModel = VenueCellViewModel(with: self.recViewModel.recomsArray[indexPath.row], credentials: self.credentials)
        cell.setUpCell()
        return cell
    }
}

// Collectionview Delegate methods
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HomeCollectionViewCell else {
            return
        }
        
        if let url = cell.venueCellViewModel?.recommendations?.imageUrl {
            cell.venueImageView.getImageFromUrl(url: url)
        }
        
        if indexPath.row == self.recViewModel.recomsArray.count - 1 {  //numberofitem count
            self.recViewModel.fetchAllRecomendations(offset: self.recViewModel.offset + 1 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// Collectionview Flowlayout delegate method
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let horizontalInset = layout.sectionInset.left + layout.sectionInset.right
        
        return CGSize(width: collectionView.bounds.width - horizontalInset,
                      height: 100.0)
    }
    
}


// the transition delegate for the Filter action
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = OptionsPresentationController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }
}

// Filter selection action handler from Optionscontroller
extension HomeViewController: FilterActionDelegate {
    
    func selected(section: VenueSection, sort: VenueSort) {
        self.recViewModel.selectedSort = sort
        self.recViewModel.selectedSection = section
        self.recViewModel.fetchAllRecomendations(offset: 0)
    }
}
