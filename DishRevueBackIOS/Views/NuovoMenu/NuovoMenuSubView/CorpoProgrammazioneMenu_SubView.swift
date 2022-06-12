//
//  SelettoreProgrammazioneMenu_NuovoMenuSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/03/22.
//

import SwiftUI

struct CorpoProgrammazioneMenu_SubView: View {
    
    @Binding var nuovoMenu: MenuModel
    var valueTo:(disableDataInizio:Bool, disableDataFine:Bool, disableDays:Bool, disableOrari:Bool, titlePicker:String) {
         
         switch self.nuovoMenu.isAvaibleWhen {
             
         case .dataEsatta:
             return (false,true,true,false,"li:")
         case.intervalloAperto:
             return(false,true,false,false,"dal:")
         case .intervalloChiuso:
             return(false,false,false,false,"dal:")
         case .noValue:
             return(true,true,true,true,"dal")
             
         }
         
     }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                DatePicker(valueTo.titlePicker, selection: self.$nuovoMenu.dataInizio,in:Date()..., displayedComponents: .date)
                    .opacity(self.valueTo.disableDataInizio ? 0.6 : 1.0)
                    .disabled(self.valueTo.disableDataInizio)
                
                Text("  |  ")
                
                DatePicker("al:", selection: self.$nuovoMenu.dataFine, in:(self.nuovoMenu.dataInizio.advanced(by: 604800))... ,displayedComponents: .date)
                    .opacity(self.valueTo.disableDataFine ? 0.6 : 1.0)
                    .disabled(self.valueTo.disableDataFine)
                
            }
             
            PropertyScrollCases(cases: GiorniDelServizio.allCases, dishCollectionProperty: self.$nuovoMenu.giorniDelServizio, colorSelection: Color.mint)
                    .opacity(self.valueTo.disableDays ? 0.6 : 1.0)
                    .disabled(self.valueTo.disableDays)
                    
            HStack {
                
                DatePicker("dalle:", selection: self.$nuovoMenu.oraInizio, displayedComponents: .hourAndMinute)
                    .opacity(self.valueTo.disableOrari ? 0.6 : 1.0)
                    .disabled(self.valueTo.disableOrari)
                    
                Text("  |  ")
                
                DatePicker("alle:", selection: self.$nuovoMenu.oraFine, in: (self.nuovoMenu.oraInizio.addingTimeInterval(1800.0))... ,displayedComponents: .hourAndMinute)
                    .opacity(self.valueTo.disableOrari ? 0.6 : 1.0)
                    .disabled(self.valueTo.disableOrari)
                
            }
           // .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
           // .disabled(self.isThereAReasonToDisable.date)
            
            
        }
        
        
    }
    
}




/*struct CSLabel_1Picker_Previews: PreviewProvider {
    static var previews: some View {
        CSLabel_1Picker(placeHolder: "Programmazione", imageName: "circle", backgroundColor: Color.black, pickerColor: Color.green, availabilityMenu: .constant(AvailabilityMenu.defaultValue))
    }
} */

