//
//  NavStackTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 13/06/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct TEST_NewScroll: View {
    var body: some View {
    
        TabView {
            Group {
              
                    InsideTabView(color: .red)
                        .tabItem { Text("Red") }
                    
                
                
                InsideTabView(color: .green)
                    .tabItem { Text("Green") }
                   
                   // .toolbarBackground(.hidden, for: .tabBar)
                
                InsideTabView(color: .blue)
                    .tabItem { Text("Blue") }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.yellow, for: .tabBar)
        
        }
        
        .accentColor(.seaTurtle_3)
        
        
    }
}

struct InsideTabView:View {
    
    let color:Color
    var path:NavigationPath = NavigationPath()
    
    @State private var position:Int? = 0
    
    var body: some View {
        
        NavigationStack {
            
            CSZStackVB(title: color.description, backgroundColorView: .seaTurtle_1) {
            
                VStack {
                    
                   CSDivider()
                    
                    ScrollView(showsIndicators: false) {
                        
                       
                       // ScrollViewReader { proxy in
                            
                          Text("Barra Ricerca")
                                .id(0)
                            
                            ForEach(1..<100) { number in
                                
                                Text("\(number)")
                                    .id(number)
                                
                            }
  
                      //  }// chiusa reader
 
                    } // chiusa Scroll
                    
                    .scrollPosition(id: $position, anchor: .top)
                  // CSDivider()
                }// chiusa vstack intenro
                
            }// chiusa zstack
            .onAppear(perform: {
                position = 85
            })
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Ciao")
                }
            }
        }// chiusa navStacl
       // .clipped()
        
    }
}



#Preview {
    
        TEST_NewScroll()
    
}
