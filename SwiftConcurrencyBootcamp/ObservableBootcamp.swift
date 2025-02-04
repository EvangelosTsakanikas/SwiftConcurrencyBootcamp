//
//  ObservableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/4/25.
//

import SwiftUI

actor TitleDatabase {
    
    func getNewTitle() -> String {
        "Some new title!"
    }
}

// NEW UPDATED WAY
//@Observable @MainActor
//class ObservableViewModel {
//    
//    @ObservationIgnored let database = TitleDatabase()
//    var title: String = "Starting title"
//    
//    func updateTitle() async {
//        title = await database.getNewTitle()
//        print(Thread.current)
//    }
//}

@Observable
class ObservableViewModel {
    
    @ObservationIgnored let database = TitleDatabase()
    @MainActor var title: String = "Starting title"
    
//    @MainActor
    func updateTitle() /*async*/ {
        Task { @MainActor in
            title = await database.getNewTitle()
            print(Thread.current)

        }
        
//        let title = await database.getNewTitle()
//        await MainActor.run {
//            self.title = title
//        }
//        print(Thread.current)
    }
}

struct ObservableBootcamp: View {
    
    @State private var viewModel = ObservableViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .onAppear {
                viewModel.updateTitle()
            }
//            .task {
//                await viewModel.updateTitle()
//            }
    }
}

#Preview {
    ObservableBootcamp()
}
