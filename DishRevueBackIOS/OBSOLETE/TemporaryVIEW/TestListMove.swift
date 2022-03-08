//
//  TestListMove.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/03/22.
//

import SwiftUI

struct TestListMove: View {
    
   // @State var editMode: EditMode = .inactive
    @Environment(\.editMode) var mode
    @State var listaA: [String] = ["Basilico","Prezzemolo","Aglio","Pomodoro","Olio","Aceto"]
    
    var body: some View {
        
        
        
        ZStack {
            
            Color.cyan.opacity(0.9).ignoresSafeArea()
            
            VStack {
                
                HStack {
                    
                    Button("Test") {
                        self.mode?.wrappedValue = .active
                    }
                    Spacer()
                    
                }.padding()
                
                    
                    List {
                        
                     //   VStack(alignment: .leading) {
                        
                        ForEach(listaA, id:\.self) { ing in
                            
                            
                            HStack {
                                
                                Text(ing)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                
                     
                               Spacer()
                                
                           
                  
                            }._tightPadding()
                          

                       //    Divider()
                    
                            
                        }
                        .onDelete { IndexSet in
                            listaA.remove(atOffsets: IndexSet)
                        }
                        .onMove { IndexSet, newPosition in
                            listaA.move(fromOffsets: IndexSet, toOffset: newPosition)
                        }
                       
                       
                       /* .onMove { indices, newPosition in
                            listaA.move(fromOffsets: indices, toOffset: newPosition)
                        } */
                        
                        
                    //   }
                        
                    }
                    .listStyle(.inset)
 
                
              //  .listStyle(PlainListStyle())
               
                
            }
        }
    }
}

struct TestListMove_Previews: PreviewProvider {
    static var previews: some View {
        TestListMove()
    }
}
