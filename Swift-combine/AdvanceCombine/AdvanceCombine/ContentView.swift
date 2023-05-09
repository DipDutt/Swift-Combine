//
//  ContentView.swift
//  AdvanceCombine
//
//  Created by Dip Dutt on 18/4/23.


// 1. create custom publisher to manipulate subsciber.

import SwiftUI
import Combine

class dataServiceManager {
    //@Published var array:String = ""
    let currentPublisher = CurrentValueSubject<String,Error>("Start")
    let passPublisher = PassthroughSubject<Int,Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    
    init () {
        downloadData()
    }
    
    func downloadData() {
        let items:[Int] = [1,2,3,4,5,6,7,8,9,10]
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline:.now() + Double(x) ) {
                self.passPublisher.send(items[x])
                
                if (x > 4 && x < 8) {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(90)
                }
                else {
                    self.boolPublisher.send(false)
                }
                
                if x == items.indices.last {
                    self.passPublisher.send(completion: .finished)
                }
            }
            
        }
    }
}

class advanceCombineViewModel:ObservableObject {
    @Published var data:[String] = []
    @Published var dataBool:[Bool] = []
    let dataservice = dataServiceManager()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
   
    private func addSubscriber() {
       
        
        // do some array sequences
        /*
        //.first()
        //first(where: {$0 > 4})
//            .tryFirst(where: { int in
//                if int == 30 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 4
//            })

           // .last()
            //.dropFirst()
        //.drop(while: {$0 > 5})
            //.tryDrop(while: {
                //if $0 == 15 {
                    //throw URLError(.badServerResponse)
                //}
                //return $0 < 5
            //})
        */
       
        // do some mathematical operation
        /*
            //.max()
//            .max(by: { int1, int2  in
//                return int1 < int2
//            })
//            .tryMax(by: )
//            .min()
//            .min(by: )
//            .tryMin(by:)
        */
        
        // filtering/ reduce/ map
        /*
//            .tryMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//
//                return String(int)
//            })
//            .compactMap({ int in
//                if int == 5 {
//                    return nil
//                }
//                 return String(int)
//            })
//           .filter({$0 > 3 && $0 < 8})
//           .scan(0, { firstvalue, newvalue in
//              return firstvalue + newvalue
//           })
           */
        
        // multiple publishers / subscribers
//            .combineLatest(dataservice.boolPublisher)
//            .compactMap({$1 ? String($0) : nil})
//            .removeDuplicates()
//            .merge(with: dataservice.intPublisher)
        let sharedPublisher = dataservice.passPublisher
            .share()
        sharedPublisher
            .map({String($0)})
            .sink { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                    print("Error is \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] returnValue in
                self?.data.append(returnValue)
            }
            .store(in: &cancellable)
        
        sharedPublisher
            .map({$0 > 5 ? true : false})
            .sink { completion in
                switch completion {
                case .finished:
                   break
                case .failure(let error):
                    print("error is \(error)")
                }
            } receiveValue: { [weak self] returnValue in
                self?.dataBool.append(returnValue)
            }
            .store(in: &cancellable)
        }
        
    }


struct ContentView: View {
    @StateObject private var vm = advanceCombineViewModel()
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(vm.data, id: \.self) {
                        Text($0)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
                }
                
                VStack {
                    ForEach(vm.dataBool, id: \.self) {
                        Text($0.description)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                    }
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
