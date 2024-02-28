//
//  SelettoreProgrammazioneMenu_NuovoMenuSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/03/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct CorpoProgrammazioneMenu_SubView: View {
    
    @Binding var nuovoMenu: MenuModel

    var body: some View {
        
        VStack {
            
            switchProgrammazione()
        
            HStack {
                
                DatePicker("dalle:", selection: self.$nuovoMenu.oraInizio, displayedComponents: .hourAndMinute)
                    
                Text("  |  ")
                
                DatePicker("alle:", selection: self.$nuovoMenu.oraFine, in: (self.nuovoMenu.oraInizio.addingTimeInterval(3600.0))... ,displayedComponents: .hourAndMinute)
                
            }
            
        }
        
    }

    // ViewBuilder
    
    @ViewBuilder private func switchProgrammazione() -> some View {
        
        let title = nuovoMenu.availability.titlePicker()
        let availability = nuovoMenu.availability
        
        switch availability {
        case .dataEsatta:
            programmaDataEsatta(title: title)
        case .intervalloChiuso:
            programmaChiuso(title: title)
        case .intervalloAperto:
            programmaAperto(title: title)
       /* case .noValue:
            EmptyView()*/
        }
        
    }
    
    @ViewBuilder private func programmaChiuso(title:String) -> some View {
        
        HStack {
           
            DatePicker(
                title,
                selection: self.$nuovoMenu.giornoInizio,
                in:Date()...,
                displayedComponents: .date)
            
            Text("  |  ")
            
            if let endDay = self.nuovoMenu.giornoFine {
                
                let dayToEnd = Binding {
                    endDay
                } set: { new in
                    self.nuovoMenu.giornoFine = new
                }

                DatePicker(
                    "al:",
                    selection: dayToEnd,
                    in:(self.nuovoMenu.giornoInizio.advanced(by: 604800))... ,
                    displayedComponents: .date)
            }
            
        }
         
            PropertyScrollCases(
                cases: GiorniDelServizio.allCases,
                dishCollectionProperty: self.$nuovoMenu.giorniDelServizio,
                colorSelection: Color.mint)
            
    }
    
    @ViewBuilder private func programmaAperto(title:String) -> some View {
        
        HStack {
         
            DatePicker(
                title,
                selection: self.$nuovoMenu.giornoInizio,
                in:Date()...,
                displayedComponents: .date)
            .fixedSize()
            Spacer()
        }
         
            PropertyScrollCases(
                cases: GiorniDelServizio.allCases,
                dishCollectionProperty: self.$nuovoMenu.giorniDelServizio,
                colorSelection: Color.mint)

    }
    
    @ViewBuilder private func programmaDataEsatta(title:String) -> some View {
        
        HStack {
           
            DatePicker(
                title,
                selection: self.$nuovoMenu.giornoInizio,
                in:Date()...,
                displayedComponents: .date)
            .fixedSize()
            
            Spacer()
        }
 
            let serviceDay = self.nuovoMenu.getGiornoServizioDataEsatta()
            
            HStack {
                
                CSText_tightRectangleVisual(fontWeight:.semibold,textColor: Color.white, strokeColor: Color.white, fillColor: Color.cyan) {
                    
                    HStack {
                        
                        csVbSwitchImageText(string: serviceDay.imageAssociated(), size: .large)
                        Text(serviceDay.simpleDescription())
                     //   Spacer()
                    }
                }
                Spacer()
            }
            
    }


}

/*struct CorpoProgrammazioneMenu_SubView: View {
    
    @Binding var nuovoMenu: MenuModel
    
    var valueFor:(disableDataInizio:Bool, disableDataFine:Bool, disableDays:Bool, disableOrari:Bool, titlePicker:String) {
         
         switch self.nuovoMenu.availability {
             
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
                
                DatePicker(
                    valueFor.titlePicker,
                    selection: self.$nuovoMenu.dataInizio,
                    in:Date()...,
                    displayedComponents: .date)
                    .opacity(self.valueFor.disableDataInizio ? 0.6 : 1.0)
                    .disabled(self.valueFor.disableDataInizio)
                
                Text("  |  ")
                
                DatePicker(
                    "al:",
                    selection: self.$nuovoMenu.dataFine,
                    in:(self.nuovoMenu.dataInizio.advanced(by: 604800))... ,
                    displayedComponents: .date)
                    .opacity(self.valueFor.disableDataFine ? 0.6 : 1.0)
                    .disabled(self.valueFor.disableDataFine)
                
            }
             
            if !self.valueFor.disableDays {
                
                PropertyScrollCases(cases: GiorniDelServizio.allCases, dishCollectionProperty: self.$nuovoMenu.giorniDelServizio, colorSelection: Color.mint)
                      //  .opacity(self.valueFor.disableDays ? 0.6 : 1.0)
                      //  .disabled(self.valueFor.disableDays)
            } else {
                
                let singleDay = setGiornoDataEsatta()
                
                HStack {
                    CSText_tightRectangleVisual(fontWeight:.semibold,textColor: Color.white, strokeColor: Color.white, fillColor: Color.cyan) {
                        
                        HStack {
                            
                            csVbSwitchImageText(string: singleDay.imageAssociated(), size: .large)
                            Text(singleDay.simpleDescription())
                         //   Spacer()
                        }
                    }
                    Spacer()
                }
            }
            
            HStack {
                
                DatePicker("dalle:", selection: self.$nuovoMenu.oraInizio, displayedComponents: .hourAndMinute)
                    .opacity(self.valueFor.disableOrari ? 0.6 : 1.0)
                    .disabled(self.valueFor.disableOrari)
                    
                Text("  |  ")
                
                DatePicker("alle:", selection: self.$nuovoMenu.oraFine, in: (self.nuovoMenu.oraInizio.addingTimeInterval(1800.0))... ,displayedComponents: .hourAndMinute)
                    .opacity(self.valueFor.disableOrari ? 0.6 : 1.0)
                    .disabled(self.valueFor.disableOrari)
                
            }
           // .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
           // .disabled(self.isThereAReasonToDisable.date)
            
            
        }
        
        
    }

    // Method
    
    private func setGiornoDataEsatta() -> GiorniDelServizio {
        
        let dataEsatta = self.nuovoMenu.dataInizio
        let serviceDay = GiorniDelServizio.giornoServizioFromData(dataEsatta: dataEsatta)
        
       // self.nuovoMenu.giorniDelServizio = [serviceDay]
        DispatchQueue.main.async {
            self.nuovoMenu.giorniDelServizio = [serviceDay]
        }
      //  handler(serviceDay)
        return serviceDay
    }
    
  /*  private func singleGiornoServizio() -> GiorniDelServizio {
        
        let calendario = Calendar(identifier: .gregorian)
        let weekDayComponent = calendario.dateComponents([.weekday], from: self.nuovoMenu.dataInizio)
        let giornoDelServizio = GiorniDelServizio.fromOrderValue(orderValue: weekDayComponent.weekday!)
       
        self.nuovoMenu.giorniDelServizio = [giornoDelServizio]
        
        return giornoDelServizio
        // Crea un doppio binario, ricava il giorno della data esatta, in quanto questo metodo viene eseguito solo in quel caso, lo copia nel nuovo menu, ma visivamente utilizza il valore di ritorno.
    } */

}*/ // backup 14.02.24

/*struct CSLabel_1Picker_Previews: PreviewProvider {
    static var previews: some View {
        CSLabel_1Picker(placeHolder: "Programmazione", imageName: "circle", backgroundColor: Color.black, pickerColor: Color.green, availabilityMenu: .constant(AvailabilityMenu.defaultValue))
    }
} */

