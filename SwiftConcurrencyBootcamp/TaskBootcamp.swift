//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/1/25.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
//        for x in array { // if task is really long it might continue doing work after cancellation.
//            try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image returned successfully")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click me") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task { // automatically cancels the task
            await viewModel.fetchImage()
        }
        /*
        .onDisappear(perform: {
            fetchImageTask?.cancel()
        })
        .onAppear {
            fetchImageTask = Task {
                await viewModel.fetchImage()
            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            /*
            Task(priority: .high) {
//                try? await Task.sleep(nanoseconds: 2_000_000_000)
                await Task.yield()
                print("hight: \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .userInitiated) {
                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
                 
                // not recommended by Apple
                Task.detached {
                    print("detached: \(Thread.current) : \(Task.currentPriority)")

                }
            }
             */
        }
         */
    }
}

#Preview {
    TaskBootcamp()
}
