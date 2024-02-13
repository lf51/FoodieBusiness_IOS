//
//  MapLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/02/23.
//

import SwiftUI
import MyPackView_L0

/*
public struct MapLabel: View {
    
  let letter:[String] = ["A","B","C","D","E","F","G","H"]
  let word:[String] = [
        "Ancora","Adesso","Arrivederci","Borsa","Borsetta","Borsone","Casa","Casetta","Casone","Donna","Donnetta","Donnone","Elegante","Elegantissima","Fresco","Freschissimo","Gatto","Gattino","Gattaccio","Ho","Ha","Hai","Hanno","Habemus","Hora","Horace"]

    @State var frames:[CGRect] = []
    
  public var body: some View {

      CSZStackVB(title: "Test", backgroundColorView: .seaTurtle_1) {
          
          VStack(alignment:.center) {
              
              CSDivider()
              
              ScrollView(showsIndicators:false) {
                  
                  TabView {
                      
                      ForEach(letter,id:\.self) { lettera in
                          
                          let mappedWord = word.filter({$0.hasPrefix(lettera)})
                          
                          
                          
                        //  vblabel(letter: lettera)
                          
                          VStack(alignment:.center) {
                              
                              vblabel(letter: lettera)
                              .sticky(frames, coordinateSpace: "TestScroll")
                                  
                                  VStack {
                                      
                                      ForEach(mappedWord,id:\.self) { word in
                                          
                                          Text(word)
                                              .frame(width: 400, height: 75)
                                              .background {
                                                  Color.green
                                                      .cornerRadius(10.0)
                                              }
                                      }
                                  }
             
                          }
     
                      }
                  }
                  .frame(height:750)
                  .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
              }
              .coordinateSpace(name: "TestScroll")
              .onPreferenceChange(FramePreference.self, perform: {
                              frames = $0.sorted(by: { $0.minY < $1.minY })
                          })

              
              
             
              
              
              
              
              
              
              
              
              CSDivider()
          }
          
          
          
          
          
          
      }
      
    
    }
    
    @ViewBuilder private func vblabel(letter:String) -> some View {
        
        Text(letter)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .frame(width: 400, height: 75)
            .background {
                Color.white
                    .cornerRadius(10.0)
            }
    }
    
}

struct MapLabel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MapLabel()
        }
    }
}
*/
/*
public struct TabLabel: View {
    
    @State private var tab:CS_TabSelector?
    
    public var body: some View {
        
        
        TabView(selection: $tab) {
            
            ExamP(color: .seaTurtle_1, text: "UNO")
                .tabItem {
                    Text("Uno")
                    Image(systemName: "circle")
                }
                .tag(CS_TabSelector.home)
            
            ExamP(color: .seaTurtle_2, text: "DUE")
                .tabItem {
                    Text("Due")
                    Image(systemName: "circle")
                }
                .tag(CS_TabSelector.ing)
            
            ExamP(color: .seaTurtle_3, text: "TRE")
                .tabItem {
                    Text("Tre")
                    Image(systemName: "circle")
                }
                .tag(CS_TabSelector.dish)
            
            
            ExamP(color: .seaTurtle_4, text: "QUATTRO")
                .tabItem {
                    Text("Quattro")
                    Image(systemName: "circle")
                }
                .tag(CS_TabSelector.menu)
            
            
            
        }
      
        
    }
}

struct ExamP:View {
    let color:Color
    let text:String
    var body: some View {
        
        ZStack {
            color
            Text(text)
            
        }
    }
    
}


struct MapLabel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabLabel()
        }
    }
}
*/
