//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by user274186 on 2/2/25.
//

import SwiftUI

actor MyDataManager {
    
    static let instance = MyDataManager()
    private init() {}
    
    var data: [String] = []
    
    nonisolated let myRandomText: String = "something"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
}

struct HomeView: View {
    
    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear {
            let newString = manager.getSavedData()
            let newString2 = manager.myRandomText
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            //            DispatchQueue.global(qos: .background).async {
            //                if let data = manager.getRandomData() {
            //                    DispatchQueue.main.async {
            //                        self.text = data
            //                    }
            //                }
            //            }
        }
    }
}

struct BrowseView: View {
    
    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8)
                .ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            //            DispatchQueue.global(qos: .default).async {
            //                if let data = manager.getRandomData() {
            //                    DispatchQueue.main.async {
            //                        self.text = data
            //                    }
            //                }
            //            }
        }
    }
}


struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Browse", systemImage: "magnifyingglass") {
                BrowseView()
            }
            
        }
    }
}

#Preview {
    ActorsBootcamp()
}
