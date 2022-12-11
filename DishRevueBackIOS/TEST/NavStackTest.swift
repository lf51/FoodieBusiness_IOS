//
//  NavStackTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/06/22.
//

import SwiftUI
import MyFoodiePackage

struct TestViewForNavigation: View {
    
   // @State private var testItem:PropertyModel = PropertyModel(nome: "Osteria del Buco Nero")
    @ObservedObject var viewModel:AccounterVM
    @State private var testItem:PropertyModel
    
    init(testItem: PropertyModel? = PropertyModel(nome:"Trattoria del buco nero"), viewModel: AccounterVM) {
        _testItem = State(wrappedValue: testItem!)
        self.viewModel = viewModel
    }
    
    var body: some View {
        
      //  CSZStackVB(title: testItem.intestazione, backgroundColorView: Color.black) {
            
            VStack{
                
                Text("\(testItem.intestazione)")
                    .bold()
                   // .foregroundColor(Color.white)
                    
                
                Button {
                    
                    self.testItem.intestazione = "This is Better"
                    
                    
                } label: {
                    Text("Cambia Intestazione")
                }
                
                Text(testItem.descrizione)
                    .italic()
                
                
                Button {
                    self.testItem.descrizione = self.testItem.descrizione == "" ? "Try it!" : ""
                } label: {
                    Text("Cambia Descrizione")
                }

                Spacer()
                
                Button {
                    
                    let index = viewModel.allMyProperties.firstIndex(where: {$0.id == testItem.id})
                    viewModel.allMyProperties[index!] = testItem
                    
                    
                    
                } label: {
                    Text("Salva Modifiche")
                }

                
                
            }
           
     //   }
               
    }
    
}


struct NavStackTest: View {

    @StateObject var viewModel:AccounterVM = AccounterVM()
    
   
    
    var body: some View {
        
        NavigationStack {
            
               VStack {
                   
                   Text("property in: \(viewModel.allMyProperties.count)")
                   
                   ForEach(viewModel.allMyProperties) { property in
                       
                       NavigationLink {
                           TestViewForNavigation(testItem: property, viewModel: viewModel)
                       } label: {
                           Text("Edit \(property.intestazione) / \(property.id)")
                       }
 
                   }
                   
            
                   
               }
               
               
               
           }.onAppear { viewModel.allMyProperties.append(PropertyModel(nome: "Osteria Vera")) }
       }
        
        
    }


struct NavStackTest_Previews: PreviewProvider {
    static var previews: some View {
       
            
            NavStackTest()
            
        
    }
}
