//
//  MovieAPIClient.swift
//  Moviepedia
//
//  Created by Max on 11.12.2024.
// türkçeleştirme mi olur, reviewları çekmek mi olur, ekstra feature getir.



import Foundation

//where the magic happens
class MovieAPIClient: MovieService {
    
    static let sharedInstance = MovieAPIClient()
    private init() {}
    
    private let apiKey = "f5560e20236e0f9ffb9045c13db964ac"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let apiURLSession = URLSession.shared
    private let apiJSONDecoder = Utils.customJSONDecoder
    
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie] {
        print("API çağrısı başlatılıyor: \(endpoint.rawValue)")
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            throw MovieError.invalidEndpoint
        }
        let movieResponse: MovieResponse = try await self.loadURLAndDecode(url: url)
        print("API çağrısı başarılı: \(endpoint.rawValue), Toplam Film Sayısı: \(movieResponse.results.count)")
        return movieResponse.results
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, params: [
            "append_to_response": "videos,credits"
        ])
    }
    
    func searchMovie(query: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            throw MovieError.invalidEndpoint
        }
        let movieResponse: MovieResponse = try await self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ])
        
        return movieResponse.results
    }
    
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil) async throws -> D {
        guard var apiURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw MovieError.invalidEndpoint
        } // used : false since url is already absolute, no need for resolving (like scheme, host, path, queryItems)
        // why even put url in urlComponents? so queryItems can be added dynamicly and safely, without typos and mistakes
        
        // created queryItems list so api_key can be called first in the url
        var baseQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        // check if params is nil or not, then map params's keys and values and append them to queryItems
        if let additionalQueryItems = params {
            baseQueryItems.append(contentsOf: additionalQueryItems.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        // add queryItems, which are api_key and params merged, to base url
        apiURLComponents.queryItems = baseQueryItems
        
        // .url belongs to URLComponents (swift) class, it merges all url components into it's final shape
        guard let finalURL = apiURLComponents.url else {
            throw MovieError.invalidEndpoint
        }
        
        let (data, response) = try await apiURLSession.data(from: finalURL)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.invalidResponse
        }
        
        return try self.apiJSONDecoder.decode(D.self, from: data)
    }

}
