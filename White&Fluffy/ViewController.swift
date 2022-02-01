//
//  ViewController.swift
//  White&Fluffy
//
//  Created by MUHAMMAD AZIZULLO on 30/01/22.
//

import UIKit
import Photos

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results:[Result]
}
struct Result: Codable {
    let id: String
    let urls: URLS
}
struct URLS: Codable {
    let regular: String
}




class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        

        
        
    
    let PhotoVC = PhotoViewController()
    
    let favourite = FavouriteViewController()
        tabBar.backgroundColor = .systemBackground

        
    
        PhotoVC.title = "Browser"
        favourite.title = "Favourite"
        
        self.setViewControllers([PhotoVC, favourite], animated: false)
        guard let items = self.tabBar.items else { return }
        
        let images = ["house", "heart"]
        for x in 0...1 {
            items[x].image = UIImage(systemName: images[x])
        }
        //chenge tint color
        self.tabBar.tintColor = .red
        
    }
    
    
    
    
}
    class PhotoViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
        

   
    private var collectionView: UICollectionView?
    
    var results: [Result] = []
        
    let searchBar = UISearchBar()
        
        @IBOutlet weak var nextButton: UIBarButtonItem!
        var photosLibraryArray = [UIImage]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
      
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        
        layout.minimumInteritemSpacing =  0
        
        layout.itemSize  = CGSize(width:  view.frame.size.width/2, height: view.frame.size.width/2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        
        self.collectionView = collectionView
        
        searchBar.delegate = self
    
        searchBar.backgroundColor = .white

        view.addSubview(searchBar)
      
    }
    override func viewDidLayoutSubviews() {
   
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 55)
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-55)
    }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            if let text = searchBar.text {
                results = []
                collectionView?.reloadData()
                fetchPhotos(query: text)
            
            }
            
        }
        
        func fetchPhotos(query: String){
            let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=50&query=\(query)&client_id=5FftyFPUvVZ_6Tkee-BYQBSqRIG06YcA-BVbXDoSdLg"
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]data,   _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                    
                }
                
            }
            catch {
                print(error)
            
            }
            
        }
        task.resume()
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell  = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLString)
        
         return cell
    }
    


}

class FavouriteViewController: UIViewController {
    let image = [(systemName: "house", "heart")]
    var imageView : UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        
        view.backgroundColor = .systemBackground

        title = "Favourite"
        
        

    }

}

