//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/3/25.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some data"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some data"
    }
}

@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    /*@MainActor*/ @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
//    @MainActor
    func onCallToActionButtonPressed() {
        let task = Task { /*@MainActor*/
            do {
//                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel = MVVMBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
            Button("") {
                
            }
        }
        .onDisappear()
    }
}

#Preview {
    MVVMBootcamp()
}
