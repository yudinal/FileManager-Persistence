//
//  ViewController.swift
//  FileManager-Persistence
//
//  Created by Lilia Yudina on 1/21/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var pictures = [Pictures]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var searchQuery = "" {
        didSet {
            DispatchQueue.main.async {
                self.loadPictures(for: self.searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
            collectionView.delegate = self
            searchBar.delegate = self
            loadPictures(for: searchQuery)
    }
    
    func loadPictures(for search: String) {
        PictureAPIClient.getPicture(search: search) { (result) in
            switch result {
            case .failure(let appError):
                print("appError: \(appError)")
            case .success(let countries):
                self.pictures = countries
            }
        }
    }
}

extension PictureViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureViewCell else {
            fatalError("Couldn't dequeue the PictureViewCell")
        }
        let picture = pictures[indexPath.row]
        cell.configureCell(for: picture)
        return cell
    }
}

extension PictureViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 10
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 3
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

extension PictureViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {
            return
        }
        searchQuery = searchText
    }
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            loadPictures(for: searchQuery)
            return
        }
        
        searchQuery = searchText.lowercased()
        
    }
}

