//
//  FetchImagesService.swift
//  Test Product
//
//  Created by Abdula Magomedov on 09.02.2021.
//

import Foundation

class FetchImagesService {
    
    private let apiKey: String
    private(set) var isAllPageLoaded: Bool = false
    private(set) var isLoading = false
    private var currentPage = 1
    
    func fetchNextPage(completion: @escaping ([String]) -> Void) {
        
        guard !isLoading else { return }
        
        guard let url = URL(string: "https://api.unsplash.com/photos/?client_id=\(apiKey)&page=\(currentPage)") else {
            return
        }
        
        isLoading = true
        
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            
            var images = [String]()
            
            defer {
                self.isLoading = false
                
                if images.count == 0 {
                    self.isAllPageLoaded = true
                }
                
                DispatchQueue.main.async {
                    completion(images)
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else { return }
            
            guard let responseArray = try? JSONDecoder().decode([ResponseArrayItem].self, from: data) else { return }
            
            if responseArray.count < 10 {
                self.isAllPageLoaded = true
            } else {
                self.currentPage += 1
            }
            
            images = responseArray.map({$0.urls.regular})
        }
        
        task.resume()
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension FetchImagesService {
    
    private struct ResponseArrayItem: Decodable {
        
        let urls: Urls
        
        struct Urls: Decodable {
            let regular: String
            let small: String
            let thumb: String
        }
    }
}
