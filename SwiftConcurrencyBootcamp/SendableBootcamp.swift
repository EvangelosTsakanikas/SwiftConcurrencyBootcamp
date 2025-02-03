//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/3/25.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
}

struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

// dangerous to use unchecked. Needs the queue to make it thread safe!!!

//final class MyClassUserInfo: @unchecked Sendable {
//    var name: String
//    let queue = DispatchQueue(label: "com.learning.MyClassUserInfo")
//    
//    init(name: String) {
//        self.name = name
//    }
//
//    func updateName(name: String) {
//        queue.async {
//            self.name = name
//        }
//    }
//    
//}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassUserInfo(name: "info")
        
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await viewModel.updateCurrentUserInfo()
            }
    }
}

#Preview {
    SendableBootcamp()
}
