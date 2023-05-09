//
//  ContentView.swift
//  combineJson
//
//  Created by Dip Dutt on 26/2/23.
//

import SwiftUI
import Combine

struct Welcome:  Identifiable, Codable {
    let id: Int
    let title:String
    let body: String
}

class combineJsonView:ObservableObject {
    @Published var posts:[Welcome] = []
    var cancallable = Set<AnyCancellable>()
    
    init() {
        downloadData()
    }
    
    func downloadData() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
        // sign up for subscription to deliver.
        URLSession.shared.dataTaskPublisher(for: url)
        // receive the product on the main door.
            .receive(on: DispatchQueue.main)
            //check the box to show wheather any damage happen
            .tryMap(handleOutPut)
        // open the box item is correct item found.
            .decode(type: [Welcome].self, decoder: JSONDecoder())
            .replaceError(with: [])
        // use the item
            .sink { (Faliure) in
                print("completion is:\(Faliure)")
            } receiveValue: {  [weak self](receiveData) in
                self?.posts = receiveData
            }
        // cancellable at any time.
            .store(in: &cancallable)
    }
    
    func handleOutPut(output: Publishers.SubscribeOn<URLSession.DataTaskPublisher, DispatchQueue>.Output)throws -> Data {
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return  output.data
    }
}

struct ContentView: View {
    @StateObject private var vm = combineJsonView()
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack() {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
