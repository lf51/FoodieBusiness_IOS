//
//  ColoreTabViewTest.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/06/22.
//

import SwiftUI
import MyPackView_L0


struct ColorTabViewMain: View {
    
    var body: some View {
        
        TabView {
            
            ColoreTabViewTest()
                .tabItem {
                    Image(systemName: "trash")
                    Text("Ole")
                }
            
            
            ZStack{
                Color("SeaTurtlePalette_1")
                Text("HelloWorld")
            }
                .tabItem {
                    Image(systemName: "circle")
                    Text("Hi")
                }
            
            
            
            
        }
        .accentColor(Color("SeaTurtlePalette_3"))
        
        
        
    }
    
    
    
}



struct ColoreTabViewTest: View {
    var body: some View {
        
        CSZStackVB(title: "My Test", backgroundColorView: Color("SeaTurtlePalette_1")) {
            
            
           // Color("SeaTurtlePalette_1")
            
            VStack {
                
                CSDivider()
                
                ScrollView(showsIndicators:false) {
                    
                    ForEach(0..<100) { step in
                        
                        
                        Text("\(step)")
                        
                        
                    }
                    
                }
                
                CSDivider()
                
            }
            
            
            
        }
        .background(Color("SeaTurtlePalette_1").opacity(0.6))
        
        
    }
}

struct ColoreTabViewTest_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            
            ColorTabViewMain()
            
        }
        
    }
}
