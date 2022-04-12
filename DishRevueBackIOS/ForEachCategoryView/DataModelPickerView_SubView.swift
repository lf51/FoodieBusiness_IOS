//
//  DataModelPickerView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 05/04/22.
//

import SwiftUI

struct DataModelPickerView_SubView: View {
    
    @Binding var selectedMapCategory: MapCategoryContainer
    @Binding var statusFilter: ModelStatus
    let dataContainer:[MapCategoryContainer]
    
    var body: some View {

        HStack {
            
            HStack {
                
              Image(systemName: "eye")
                
                Picker(selection:$selectedMapCategory) {
                              
                    ForEach(dataContainer, id:\.self) {filter in
                                  
                            Text(filter.simpleDescription())
                                  
                              }
                              
                          } label: {Text("")}
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.black)
                          .padding(.horizontal)
                          .background(
                        
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.white.opacity(0.8))
                            .shadow(radius: 1.0)
                    )
                    
            }
            .padding(.leading)
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke()
                    .fill(Color.white.opacity(0.5))
                    
            )
       // .padding(.bottom)
            
            Spacer()
     
            Picker(selection: $statusFilter) {
                
                ForEach(ModelStatus.allCases,id:\.self) { status in
                    
                    Text(status.rawValue)
                    
                    
                }
                
                
            } label: {
                Text("")
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(Color.black)
            .padding(.horizontal)

            
            
          /*  Toggle(isOn: $showOnlyPublished) {
                
                Text("Mostra Tutti")
                    .fontWeight(.semibold)
  
            }
            .padding(.leading)
            .background(
                
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke()
                    .fill(Color.white.opacity(0.5))
                    
            ) */
        
        }
        .padding(.bottom)
    }
    
}

struct DataModelPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            DataModelPickerView_SubView(selectedMapCategory: .constant(.provenienza), statusFilter: .constant(.all), dataContainer: MapCategoryContainer.allIngredientMapCategory)
        }
    }
}

