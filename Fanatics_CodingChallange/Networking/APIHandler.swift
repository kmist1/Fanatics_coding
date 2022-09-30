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
    case GET, PUT, DELETE
}

class APIHandler {

    // MARK: - Properties
    static let shared = APIHandler()
    var session = URLSession.shared

    init() {}

    typealias Completion<T: Codable> = ((Result<T, Error>) -> Void)?

    // MARK: - Methods
    // Getting all users from page 3
    func getAllPageThreeUsers(url: String, completionHandler: @escaping (Result<[User], Error>) -> ()) {

        guard let url = URL(string: url + "page=3") else {
            debugPrint("Invalid URL")
            return
        }

        // Creating the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        // Starting session data task
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

    // Updating user with given user id
    func updateUser(user: User, httpMethod: HTTPMethod, completionHandler : @escaping (_ success: Bool) -> ()) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(user.id)") else {
            debugPrint("Invalid URL")
            return
        }

        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(user) else {
            print("Error: Trying to convert model to JSON data")
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        // Starting session data task
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling PATCH")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                if let response = response as? HTTPURLResponse {
                    print("Error: Updating user response code: \(response.statusCode)")
                }
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }

                print(prettyPrintedJson)
                completionHandler(true)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }

    // Deleting user with user Id
    func deleteUser(user: User, httpMethod: HTTPMethod) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(user.id)") else {
            print("Error: cannot create URL")
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        // Starting session data task
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                if let response = response as? HTTPURLResponse {
                    print("Error: Deleting user response code: \(response.statusCode)")
                }
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }

                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }

    // Get user data with user id
    func getUser(with id: Int, httpMethod: HTTPMethod, completion: @escaping (Int) -> ()) {
        guard let url = URL(string: "https://gorest.co.in/public/v2/users/\(id)") else {
            debugPrint("Invalid URL")
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue(AuthToken.tocken, forHTTPHeaderField: "Authorization")

        // Starting session data task
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
