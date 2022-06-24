//
//  ListTEST.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/06/22.
//

import SwiftUI




struct ListTEST: View {
    
   @State var test = ["Ciao", "Olas", "Hello"]
    
    init() {
        
    //    UITableView.appearance().backgroundColor = .green
        UICollectionView.appearance().backgroundColor = .yellow
       // UICollectionReusableView.appearance().backgroundColor = .orange
    }
    
    
    var body: some View {
        
        
        
       // CSZStackVB(title: "Ciao List", backgroundColorView: Color.red)
        ZStack {
            
            Color("SeaTurtlePalette_1").ignoresSafeArea()
            
            VStack(alignment:.leading) {
                
                Text("UP Side")
                    .bold()
                
               List {
                    
                        
                        ForEach(test, id:\.self) {text in
                            
                            Text(text)
                            Divider()
                          
                        
                            
                        }
                      //  .listRowBackground(Color("SeaTurtlePalette_1"))
                      
                        
                    
                        
                    
               }
              
            /*   .clipShape(
                RoundedRectangle(cornerRadius: 10.0)
                  
               ) */
             //  .scaledToFit()
              
          //     .listStyle(.plain)
               
               
                
                Text("Bottom Side")
                 
                
                Spacer()
            }.padding(.horizontal)
            
            Spacer()
            
            
        }
        
        
    }
}

struct ListTEST_Previews: PreviewProvider {
        
    static var previews: some View {
        
        NavigationStack {
            ListTEST()
        }
        
       
    }
}
