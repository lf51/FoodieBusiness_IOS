//
//  NavStackTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/06/22.
//

import SwiftUI

struct ViewDue:View {
    
    var title: String
    
    var body: some View {
        
        VStack {
            
            NavigationLink {
                Text("End")
            } label: {
                Text(title)
            }

            
        }
        
        
    }
    
}

struct ViewUno:View {
    
    var title: String
    
    var body: some View {
        
        VStack {
            
       
                NavigationLink(value: "Come Mai") {
                    Text("+ Modifier")
                }
            
            
            
            
        }.navigationDestination(for: String.self) { string in
            ViewDue(title: string)
        }
        
        
    }
    
}

struct NavStackTest: View {
    
  /*  @State private var menuItem: MenuModel = MenuModel(nome: "Test", tipologia: .allaCarta, giorniDelServizio: [.lunedi,.martedi]) */
    let menuItem:StatusModel = .bozza
    let backgroundColorView = Color("SeaTurtlePalette_1")
    @State private var activeEditMenuLink = false
    
    var body: some View {
        
        NavigationStack {
            
            CSZStackVB(title: "Test View", backgroundColorView: Color("SeaTurtlePalette_1")) {
                
                VStack {
                    
                    NavigationLink(value: activeEditMenuLink) {
                        Text("isValueActive or Not")
            
                    }
                    
                    Menu {
                        
                        Button("Active") {
                            self.activeEditMenuLink = true
                        }
                        
                        NavigationLink(value: activeEditMenuLink) {
                            Text("isValueActive or Not")
                
                        }
                        
                        
                    } label: {
                        Text("Open Menu")
                    }

                    
              
                }.navigationDestination(for: Bool.self) { value in
                    Text("isValueActive:\(value.description)")
                }
                
                
            }
     
        }
        
        
    }
}

struct NavStackTest_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            
            NavStackTest()
            
        }
    }
}
