//
//  ViewController.swift
//  Test Product
//
//  Created by Abdula Magomedov on 09.02.2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var fetchImagesService: FetchImagesService?
    private var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashApiKey") as? String else {
            fatalError("Cannot find Unsplash Api Key")
        }
        
        fetchImagesService = FetchImagesService(apiKey: apiKey)
        fetchNextPage()
    }
    
    private func fetchNextPage() {
        
        fetchImagesService?.fetchNextPage(completion: { [weak self] (images) in
            self?.images.append(contentsOf: images)
            self?.collectionView.reloadData()
        })
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        if let url = URL(string: images[indexPath.row]) {
            cell.setImageFrom(url: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard fetchImagesService?.isLoading == false else { return }
        
        if indexPath.row > images.count - 5 {
            fetchNextPage()
        }
    }
}
