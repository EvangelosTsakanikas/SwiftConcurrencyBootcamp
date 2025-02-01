//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 1/31/25.
//

import SwiftUI

class DoTryCatchThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text2")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
//        if isActive {
//            return "New Text3"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}

class DoTryCatchThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoTryCatchThrowsBootcampDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            text = newTitle
        } else if let error = returnedValue.error {
            text = error.localizedDescription
        }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            text = newTitle
        case .failure(let error):
            text = error.localizedDescription
        }
         */
        
//        let newTitle = try? manager.getTitle3()
//        if let newTitle = newTitle {
//            text = newTitle
//        }
        
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            text = finalTitle
        } catch {
            text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var vm = DoTryCatchThrowsBootcampViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
