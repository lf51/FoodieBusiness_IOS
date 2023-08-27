//
//  QueryScrollView_NewPropertySubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/03/22.
//

import SwiftUI
import MapKit
import MyFoodiePackage

struct QueryScrollView_NewPropertySubView: View {
    //  @ObservedObject var vm: PropertyVM
      let queryResults: [MKMapItem]
      let queryRequest: String
      let screenHeight: CGFloat
      let action:(_ place:MKMapItem) -> Void
      
      var body: some View {
          
          VStack {
              
              if !queryResults.isEmpty && queryRequest != "" {
                  
                  ScrollView {
                      
                     VStack(spacing: 0) {
                          
                         ForEach(queryResults,id:\.self) { place in
                              
                              QueryRow_NewPropertySubView(place:place)
                                  .onTapGesture {
                                      action(place)
                                  }
                              
                              Divider()
                                  .shadow(radius: 1.0)
                                  .padding(.horizontal)
                                  .padding(.vertical,5)
                          }
                      }
                  }.padding(.vertical)
              }
          }
         // .padding(.horizontal,5)
          .frame(maxWidth:.infinity)
          .frame(height:screenHeight * 0.25)
          .background(queryResults.isEmpty ? Color.clear : Color(.secondarySystemFill))
          .shadow(radius: 0.5)
          .cornerRadius(5.0)
          .padding(.horizontal,5)
          
      }
}

/*
struct QueryScrollView_NewPropertySubView_Previews: PreviewProvider {
    static var previews: some View {
        QueryScrollView_NewPropertySubView()
    }
}
*/
