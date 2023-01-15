//
//  PostController.swift
//  Reddit API Demo
//
//  Created by Stef Castillo on 1/14/23.
//

import Foundation
import UIKit

class PostController {
    
    //Base URL https://www.reddit.com/r/funny/.json
    static let baseURL = URL(string: "https://www.reddit.com")
    static let rComponent = "r"
    static let jsonExtension = "json"
    
    static func fetchPostsWith(searchTerm: String, completion: @escaping (Result<[Post], PostError>) -> Void) {
        
        //1. URL
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        
        //Adding the / into the base URL https://www.reddit.com/r
        let rURL = baseURL.appendingPathComponent(rComponent)
        
        //Add the search term into the the rURL https://www.reddit.com/r/funny
        let searchURL = rURL.appendingPathComponent(searchTerm)
        
        //Add the json at the end of the searchURL
        let finalURL = searchURL.appendingPathExtension(jsonExtension)
        
        print(finalURL)
        
        //2. Data Task **Dont forget the .resume()
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            //3.Error Handling
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            //Not necessary but very helpful for debugging **PLEASE USE
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("POST STATUS CODE: \(response.statusCode)")
                }
            }
            
            //4. Check for data
            guard let data = data else {return completion(.failure(.noData))}
            
            //5. Decode Data
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let secondLevelObject = topLevelObject.data
                let thirdLevelObject = secondLevelObject.children
                
                var arrayOfPosts: [Post] = []
                
                for dict in thirdLevelObject {
                    let post = dict.data
                    arrayOfPosts.append(post)
                }
                
                return completion(.success(arrayOfPosts))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchThumbnailFor(Post: Post, completion: @escaping (Result<UIImage , PostError>) -> Void) {
        
        guard let thumbnailURL = URL(string: Post.thumbnail) else {return completion(.failure(.invalidURL))}
            
        URLSession.shared.dataTask(with: thumbnailURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print("THUMBNAIL STATUS CODE: \(response.statusCode)")
                }
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            guard let thumbnail = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            
            return completion(.success(thumbnail))
            
            
        }.resume()
        
    }
    
}//End of class
