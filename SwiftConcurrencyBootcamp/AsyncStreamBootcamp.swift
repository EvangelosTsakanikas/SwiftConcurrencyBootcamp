//
//  AsyncStreamBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/4/25.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData(newValue: { value in
                continuation.yield(value)
            }, onFinish: { error in
                continuation.finish(throwing: error)
            })
        }
        
    }
    
    func getFakeData(
        newValue: @escaping (_ value: Int) -> (),
        onFinish: @escaping (_ error: Error?) -> ()
    ) {
        let items: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                newValue(item)
                print("New Data: \(item)")
                
                if item == items.last {
                    onFinish(nil)
                }
            })
        }
    }
}

@MainActor
final class AsyncStreamBootcampViewModel: ObservableObject {
    
    let manager = AsyncStreamDataManager()
    @Published private(set) var currentNumber: Int = 0
    
    func onViewAppear() {
        //        manager.getFakeData { [weak self] value in
        //            self?.currentNumber = value
        //        }
        
        let task = Task {
            do {
                for try await value in manager.getAsyncStream().dropFirst(2) {
                    currentNumber = value
                }
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            task.cancel()
            print("task cancelled")
        })
    }
}


struct AsyncStreamBootcamp: View {
    
    @StateObject private var viewModel = AsyncStreamBootcampViewModel()
    
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootcamp()
}
