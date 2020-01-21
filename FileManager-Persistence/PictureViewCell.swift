//
//  PictureViewCell.swift
//  FileManager-Persistence
//
//  Created by Lilia Yudina on 1/21/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit
import ImageKit

class PictureViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    
    
    func configureCell(for picture: Pictures) {
        
        pictureView.getImage(with: picture.previewURL) { [weak self] (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.pictureView.image = image
                }
            case .failure(let error):
                print("error\(error)")
            }
            
        }
        
    }
    
}
