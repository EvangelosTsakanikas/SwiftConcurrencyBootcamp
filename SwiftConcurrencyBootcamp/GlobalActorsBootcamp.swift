//
//  GlobalActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/3/25.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        return ["one", "two", "three", "four", "five"]
    }
}

//@MainActor
class GlobalActorsBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor
//    @MainActor
    func getData() async {
        
        // let's say here we were doing some
        // really heavy and complex methods
        
        
        let data = await manager.getDataFromDatabase()
        await MainActor.run {
            self.dataArray = data
        }
    }

}

struct GlobalActorsBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorsBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorsBootcamp()
}
