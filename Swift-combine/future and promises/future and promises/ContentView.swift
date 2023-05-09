//
//  ContentView.swift
//  future and promises
//
//  Created by Dip Dutt on 16/4/23.
//

import SwiftUI
import Combine

class FutureModelView:ObservableObject {
    
    @Published var title = "first tittle"
    var cancellable = Set<AnyCancellable>()
    let url = URL(string: "https://www.google.com")!
    
    
    
    init () {
        downloadData()
    }
    
    func getCombineData()->AnyPublisher<String, URLError> {
        
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1.0, scheduler: DispatchQueue.main)
            .map({ _ in
                return " new title "
            })
            .eraseToAnyPublisher()
    }
    
    
    func escapingData(completionhandeler: @escaping(String,Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionhandeler("new string", nil)
        }
        .resume()
    }
    
    
    func Futurepublisher()-> Future<String, Error> {
        
        Future { promise in
            self.escapingData { returnValue, error in
                if let error = error {
                    promise(.failure(error))
                }
                else {
                    promise(.success(returnValue))
                }
            }
        }
        
    }
    
    
    func downloadData() {
        
//        escapingData { [weak self ] returnvalue, error in
//            self?.title = returnvalue
//        }
        
        //        getCombineData()
        
        //
                  Futurepublisher()
                    .sink { _ in
        
                    } receiveValue: {  [weak self] returnvalue in
                        self?.title = returnvalue
                    }
                    .store(in: &cancellable)
        }
    }
    

   
    




struct ContentView: View {
    @StateObject private var vm = FutureModelView()
    var body: some View {
        VStack {
            Text(vm.title)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
