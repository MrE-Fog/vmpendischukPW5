//
//  ArticlesWorker.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticlesAPIWorkerLogic

/// _ArticlesAPIWorkerLogic_ is a protocol for articles list API worker logic.
protocol ArticlesAPIWorkerLogic {
    /// Fetches the news articles on page with given index via API
    /// and passes data to the completion function afterwards.
    ///
    /// - parameter pageIndex: Index of the page on the server.
    /// - parameter completion: Function that handles the response.
    func fetchNews(pageIndex: Int, completion: @escaping ([ArticleModel]?, Error?) -> ())
}

// MARK: - ArticlesWorker

/// _ArticlesWorker_ is a default API worker class for the articles list interactor
/// responsible for API requests execution.
final class ArticlesWorker {
    /// Forms the URL for API news articles fetch request based on given parameters.
    ///
    /// - parameter rubric: News rubric ID.
    /// - parameter pageIndex: News page index.
    private func getUrl(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)")
    }
}

// MARK: - ArticlesAPIWorkerLogic extension

extension ArticlesWorker: ArticlesAPIWorkerLogic {
    /// Fetches the news articles on page with given index via API
    /// and passes data to the completion function afterwards.
    ///
    /// - parameter pageIndex: Index of the page on the server.
    /// - parameter completion: Function that handles the response.
    func fetchNews(pageIndex: Int, completion: @escaping ([ArticleModel]?, Error?) -> ()) {
        // Froming the request URL.
        guard let url = getUrl(4, pageIndex) else { return }
        
        // Request via URL session.
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                // Error handling.
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                // Passing the data to decoder and the completion handler.
                if let data = data {
                    var articlePage = try? JSONDecoder().decode(ArticlePageModel.self, from: data)
                    articlePage?.passTheRequestId()
                    completion(articlePage?.news, nil)
                }
            }
        }.resume()
    }
}
