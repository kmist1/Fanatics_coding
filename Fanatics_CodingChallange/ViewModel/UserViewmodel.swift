//
//  UserViewmodel.swift
//  Fanatics_CodingChallange
//
//  Created by Krunal Mistry on 9/29/22.
//

import Foundation

class UserViewModel: ObservableObject {

    //MARK: Properties
    var apiHandler = APIHandler.shared
    @Published var users: [User] = []
    private var error: Error?

    //MARK: Methods
    ///We use this method to get User data from API
    func getData(completionHandler : @escaping (_ success: Bool) -> ()) {
        apiHandler.getAllPageThreeUsers(url: Endpoints.users.rawValue) { [weak self] data in
            switch data {
            case .failure(let error):
                self?.error = error
            case .success(let data):
                DispatchQueue.main.async {

                    completionHandler(true)

                    // sorting users by name
                    self?.users = data.sorted { $0.name < $1.name }
                    guard var users = self?.users else { return }

                    // logging name of last user after sort
                    NSLog(users[data.count - 1].name)

                    // update user and post data
                    users[data.count - 1].name = "Jenn Mistry"

                    // make update on users with updated name
                    self?.users = users
                }
            }
        }
    }

    // Update last user's data
    func updateUserData(with users: [User]) {
        let user = self.users[users.count - 1]
        print(user.name)
        apiHandler.updateUser(user: user, httpMethod: .PUT) { success in
            if success {
                // if user is updated, delete the user
                self.deleteUser(user: user)
            }
        }
    }

    // Delete last user
    func deleteUser(user: User) {
        apiHandler.deleteUser(user: user, httpMethod: .DELETE)
    }
}
