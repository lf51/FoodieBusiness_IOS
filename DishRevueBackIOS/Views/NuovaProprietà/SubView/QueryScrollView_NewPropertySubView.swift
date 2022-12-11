//
//  QueryScrollView_NewPropertySubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/03/22.
//

import SwiftUI
import MyFoodiePackage

struct QueryScrollView_NewPropertySubView: View {
    //  @ObservedObject var vm: PropertyVM
      @Binding var queryResults: [PropertyModel]
      @Binding var queryRequest: String
      let screenHeight: CGFloat
      var action:(_ place:PropertyModel) -> Void
      
      var body: some View {
          
          VStack {
              
              if !queryResults.isEmpty && queryRequest != "" {
                  
                  ScrollView {
                      
                     VStack(spacing: 0) {
                          
                          ForEach(queryResults) { place in
                              
                              QueryRow_NewPropertySubView(place:place)
                                  .onTapGesture {
                                      action(place)
                                  }
                              
                              Divider()
                                  .shadow(radius: 1.0)
                                  .padding()
                          }
                      }
                  }.padding(.vertical)
              }
          }
          .frame(maxWidth:.infinity)
          .frame(height:screenHeight * 0.25)
          .background(queryResults.isEmpty ? Color.clear : Color(.secondarySystemFill))
          .shadow(radius: 0.5)
          .cornerRadius(5.0)
          .padding(.horizontal)
          
      }
}

/*
struct QueryScrollView_NewPropertySubView_Previews: PreviewProvider {
    static var previews: some View {
        QueryScrollView_NewPropertySubView()
    }
}
*/
