//
//  SelettoreProgrammazioneMenu_NuovoMenuSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/03/22.
//

import SwiftUI

struct CSLabel_1Picker: View {
    
    let placeHolder: String
    let imageName: String
    let labelColor: Color
    let pickerColor: Color
    
    @Binding var selectedProgram: AvailabilityMenu
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, pickerColor:Color? = nil, availabilityMenu: Binding<AvailabilityMenu>) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.labelColor = backgroundColor
        self.pickerColor = pickerColor ?? Color.clear

        _selectedProgram = availabilityMenu
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(labelColor.opacity(0.2))
            )
    
            Spacer()
            
            Picker(selection:$selectedProgram) {
                
                ForEach(AvailabilityMenu.allCases, id:\.self) {schedule in
                    
                    Text(schedule.shortDescription())
                    
                    
                }
                
                
            } label: {
                Text("Ciao Ciao")
            }
           
            .pickerStyle(SegmentedPickerStyle())
            //.fontWeight(.medium)
         //   .font(.system(.subheadline, design: .monospaced))
         /*   .background( RoundedRectangle(cornerRadius: 5.0)
                            .fill(Color.clear.opacity(0.1))
                            .padding(.vertical)
                                              ) */

            
        }
       
    }
}




/*struct SelettoreProgrammazioneMenu_NuovoMenuSubView: View {
    
    @Binding var selectedProgram: ScheduleServizio
    
    var body: some View {
        
        Picker("Test", selection:$selectedProgram) {
            
            ForEach(ScheduleServizio.allCases, id:\.self) { schedule in
                
                Text(schedule.rawValue)
                    
     
            }
            
            
        }.accentColor(Color.black)
    }
    
    // Method
    
     enum ScheduleServizio:String {
        
        static var allCases:[ScheduleServizio] = [.dataEsatta,.intervalloChiuso,.intervalloAperto]
        
        case dataEsatta = "Data Esatta"
        case intervalloChiuso = "Intervallo Chiuso"
        case intervalloAperto = "Intervallo Aperto"
        
    }
    
}
*/



struct SelettoreProgrammazioneMenu_NuovoMenuSubView_Previews: PreviewProvider {
    static var previews: some View {
        CSLabel_1Picker(placeHolder: "Programmazione", imageName: "circle", backgroundColor: Color.black, pickerColor: Color.green, availabilityMenu: .constant(AvailabilityMenu.defaultValue))
    }
}

