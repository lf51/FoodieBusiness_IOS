//
//  MonitorModelView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/10/22.
//

import SwiftUI

struct MonitorModelView: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let currentDate:String
    let currentDay:String

    init() {
        let date = Date.now
        self.currentDate = csTimeFormatter().data.string(from: date)
        let giornoDelServizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: date)
        self.currentDay = giornoDelServizio.simpleDescription()
    }
    var body: some View {
        
        CSZStackVB_Framed(frameWidth:500,backgroundOpacity: 0.05,shadowColor: .clear) {
            
            VStack(alignment:.leading) {
                let(menuOn,dishVisible,ingredientsNeeded) = self.viewModel.monitorServizio()
                
                HStack {
                    Text("Servizio di:")
                        .foregroundColor(Color.black)
                       Spacer()
                    Text("\(currentDay) \(currentDate)")
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                        Spacer()
                }
                .font(.system(.subheadline, design: .monospaced, weight: .bold))
                .padding(5)
             //   Spacer()
          
                HStack {
                    
                    VStack {
                        Text("Menu")
                        Text("\(menuOn.count)")
                            .fontWeight(.bold)
                        
                    }
                    Spacer()
                    VStack {
                        Text("Piatti")
                        Text("\(dishVisible.count)")
                            .fontWeight(.bold)
                        
                    }
                    Spacer()
                    VStack {
                        Text("Ingredienti")
                        Text("\(ingredientsNeeded.count)")
                            .fontWeight(.bold)
                        
                    }
                    
                }
                .font(.system(.subheadline, design: .monospaced))
                .padding(.horizontal,5)
           
                
                
                
              
                
                
               Spacer()
            }
            
            
            
        }
        .frame(height:150)
    }
}

struct MonitorModelView_Previews: PreviewProvider {
    static var previews: some View {
        CSZStackVB(title: "Monitor", backgroundColorView: Color("SeaTurtlePalette_1")) {
            MonitorModelView()
        }.environmentObject(testAccount)
    }
}
