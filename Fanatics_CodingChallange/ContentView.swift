//
//  ContentView.swift
//  Fanatics_CodingChallange
//
//  Created by Krunal Mistry on 9/29/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var vm = UserViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            vm.getData()
        }
        .onChange(of: vm.users) { newValue in
            vm.updateUserData(with: newValue)
            vm.deleteUser()
            vm.apiHandler.getUser(with: 5555, httpMethod: .GET) { code in
                NSLog("\(code)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
