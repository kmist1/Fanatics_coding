//
//  APIHandler.swift
//  Fanatics_CodingChallange
//
//  Created by Krunal Mistry on 9/29/22.
//

import Foundation

// Enum to handle Server errors
enum APIHandlerError: Error {
   case fetchError, httpError, decodeError
}

// Enum for HTTP methods
enum HTTPMethod: String {
    case GET, PATCH, DELET
}

class APIHandler {

    static let shared = APIHandler()
    var session = URLSession.shared

    init() {}

    typealias Completion<T: Codable> = ((Result<T, Error>) -> Void)?

    func getAllPageThreeUsers(url: String, completionHandler: @escaping (Result<[User], Error>) -> ()) {

        guard let url = URL(string: url + "page=3") else {
            debugPrint("Invalid URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = HTTPMethod.GET.rawValue

        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { (data, response, error) in

            guard let data = data, error == nil else {
                completionHandler(.failure(APIHandlerError.fetchError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                 if let pagesCount = httpResponse.allHeaderFields["x-pagination-pages"] as? String {
                    NSLog(pagesCount)
                 }
            }

            do {
                let deocodedData = try JSONDecoder().decode([User].self, from: data)
                completionHandler(.success(deocodedData))
            } catch {
               debugPrint(error)
            }
        }.resume()
    }


    func updateUser(user: User, httpMethod: HTTPMethod) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(user.id)") else {
            debugPrint("Invalid URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue

        request.httpBody = try? JSONEncoder().encode(user)

        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { (data, response, error) in

            guard let data = data, error == nil else {
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("update response code: \(httpResponse.statusCode)")
            }

            do {
                let deocodedData = try JSONDecoder().decode(User.self, from: data)
                print(deocodedData)
            } catch {
               debugPrint(error)
            }
        }.resume()
    }

    func deleteUser(user: User, httpMethod: HTTPMethod) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(user.id)") else {
            debugPrint("Invalid URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue

        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { (data, response, error) in

            guard let data = data, error == nil else {
                print("Error: \(error)")
                return
            }

            do {
                let deocodedData = try JSONDecoder().decode(User.self, from: data)
                print(deocodedData)
            } catch {
               debugPrint(error)
            }
        }.resume()
    }

    func getUser(with id: Int, httpMethod: HTTPMethod, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(id)") else {
            debugPrint("Invalid URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = httpMethod.rawValue

        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        session.dataTask(with: request) { (data, response, error) in

            guard error == nil else {
                print("Error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                completion(httpResponse.statusCode)
            }
        }.resume()
    }
}
