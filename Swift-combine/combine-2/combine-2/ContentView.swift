//
//  ContentView.swift
//  combine-2
//
//  Created by Dip Dutt on 2/3/23.
//


// debunce check typing seconds then run other code.

import SwiftUI
import Combine

class combineViewModel:ObservableObject {
    @Published var textFieldText:String = ""
    @Published var textisvalid:Bool = false
    var anycancellable = Set<AnyCancellable>()
    
    init() {
        textFieldSubscriber()
    }
    
    func textFieldSubscriber() {
        
        $textFieldText
            .debounce(for: .seconds(1.0), scheduler: DispatchQueue.main)
            .map {(text)-> Bool in
                
                if text.count > 3 {
                      return true
                }
                else {
                    return false
                }
            }
            .sink { [weak self](isvalid) in
                self?.textisvalid = isvalid
            }
           .store(in: &anycancellable)
    }
}


struct ContentView: View {
    
    @StateObject var vm = combineViewModel()
    
    var body: some View {
        VStack {
            
            
            TextField("Type something here", text: $vm.textFieldText)
                .padding()
                .frame(height: 55)
                .font(.headline)
                .foregroundColor(Color.mint)
                .background(Color.gray)
                .cornerRadius(10)
                .overlay (
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity( vm.textFieldText.count < 1 ? 0.0 : vm.textisvalid ? 0.0 : 1.0)
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .opacity(vm.textisvalid ? 1.0 : 0.0)
                    }
                        .padding()
                
                        , alignment:.trailing
                
                )
            
            Text(vm.textisvalid.description)
                
            
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
