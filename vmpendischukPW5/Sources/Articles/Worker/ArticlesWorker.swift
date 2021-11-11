//
//  ArticlesWorker.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

protocol ArticlesAPIWorkerLogic {
    func fetchNews(pageIndex: Int, completion: @escaping ([ArticleModel]?, Error?) -> ())
}

final class ArticlesWorker: ArticlesAPIWorkerLogic {
    private func getUrl(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)")
    }
    
    func fetchNews(pageIndex: Int, completion: @escaping ([ArticleModel]?, Error?) -> ()) {
        guard let url = getUrl(4, pageIndex) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = data {
                    var articlePage = try? JSONDecoder().decode(ArticlePage.self, from: data)
                    articlePage?.passTheRequestId()
                    completion(articlePage?.news, nil)
                }
            }
        }.resume()
    }
}
