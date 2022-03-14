//
//  schedulePropertyService.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/03/22.
//

import SwiftUI

struct SchedulePropertyService: View {
    
  //  @Environment(\.dismiss) var dismiss
    
    @State private var wannaCreateNewMenu: Bool? = false
    @State private var nuovoNomeMenu: String = ""
    
    @State private var nuovoMenuDelServizio: MenuDelServizio = .defaultValue
    @State private var scheduleMenuEServizio: [MenuDelServizio] = [] // Essendo il propertyModel passato per copia, invece di lavorare su di esso direttamente, lavoriamo su questo array State qui creato, e una volta che i servizi sono definiti li salviamo copiando questo array nella variabile di riferimento del propertyModel
    
    @State private var oraInizioServizio: Date = Date()
    @State private var oraFineServizio: Date = Date()
    @State private var giorniDelServizio: [GiorniDelServizio] = []
    
    @State private var wannaDeleteMenuDelServizio:Bool? = false
    @Binding var dismissView:Bool?
    
    var timeFormatter: DateFormatter {
        
        let time = DateFormatter()
       // time.dateStyle = .none // Possiamo ometterlo
        time.timeStyle = .short
        
        return time
    }
    
    var isThereAReasonToDisable: (date: Bool, days: Bool, button:Bool) {
        
        let disableDateIf:Bool = nuovoMenuDelServizio == .defaultValue
        let disableDaysIf:Bool = oraInizioServizio.distance(to: oraFineServizio) < 1800.0 // 30 minuti
        let disableButtonIf:Bool = giorniDelServizio == []
        
       return (disableDateIf,disableDaysIf,disableButtonIf)
       
    }
    
    var body: some View {
        
        VStack {
            
          TopBar_3BoolPlusDismiss(title: nuovoMenuDelServizio.nome == "" ? "Nuovo Menu" : "\(nuovoMenuDelServizio.nome)", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                .padding(.horizontal)
 
            VStack(alignment: .leading) {
                
                CustomGrid_GenericsView(wannaDeleteItem: $wannaDeleteMenuDelServizio, genericDataToShow: $scheduleMenuEServizio, baseColor: Color.yellow)
                
                CSLabel_1Button(placeHolder: "Nuovo Menu", imageName: "calendar.badge.clock", backgroundColor: Color.black, toggleBottone: $wannaCreateNewMenu)
                
                if !(wannaCreateNewMenu ?? false) {
                    
                    EnumScrollCases(cases: MenuDelServizio.allCases, dishSingleProperty: $nuovoMenuDelServizio, colorSelection: Color.mint)
                    
                }  else {
                    
                    CSTextField_3(textFieldItem: $nuovoNomeMenu, placeHolder: "example: Cenone di Natale") {
                        MenuDelServizio.allCases.insert(.custom(nome: nuovoNomeMenu, inizio: "", fine: "", giorni: []), at: 0)
                        self.nuovoNomeMenu = ""
                        self.wannaCreateNewMenu = false
                    }
                    
                }
                    
                        HStack {
                            
                            DatePicker("Dalle:", selection: $oraInizioServizio, displayedComponents: .hourAndMinute)
                                
                            Text("     -->     ")
                            
                            DatePicker("Alle:", selection: $oraFineServizio, in: (oraInizioServizio.addingTimeInterval(1800.0))...,displayedComponents: .hourAndMinute)
                            
                        }
                        .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
                        .disabled(self.isThereAReasonToDisable.date)
                        
                      /*  HStack {
                            
                            DatePicker("Da", selection: $oraFineServizio, displayedComponents: .date)
                            
                            DatePicker("a", selection: $oraFineServizio, displayedComponents: .date)
                            
                        } */
                        
                        
                        EnumScrollCases(cases: GiorniDelServizio.allCases, dishCollectionProperty: $giorniDelServizio, colorSelection: Color.mint)
                        .opacity(self.isThereAReasonToDisable.days ? 0.4 : 1.0)
                        .disabled(self.isThereAReasonToDisable.days)
                        
        
                        HStack {
                            
                            if !isThereAReasonToDisable.days {
                                
                                Text("Il menu \(nuovoMenuDelServizio.simpleDescription()) è attivo dalle \(timeFormatter.string(from: oraInizioServizio)) alle \(timeFormatter.string(from: oraFineServizio)) nei giorni di \(dayDescription(),format:.list(type: .and))")
                                    .italic().fontWeight(.light).font(.caption)
                            
                            }
                            
                            Spacer()
                            
                            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) {
                                
                                self.resetValue()
                                
                            }
                            .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
                            .disabled(self.isThereAReasonToDisable.date)
                            
                         
                           CSButton_tight(title: "Done", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                            
                                self.sheduleANewService()
                                
                           }
                           .opacity(self.isThereAReasonToDisable.button ? 0.4 : 1.0)
                           .disabled(self.isThereAReasonToDisable.button)
                            
                        }.padding(.vertical)
 
            }.padding(.horizontal)
            
            
        }
        .padding(.top)
        .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
        .contrast(1.2)
        .brightness(0.08)
        
    }
    
    // Method
    
    private func resetValue() {
        
        self.nuovoMenuDelServizio = .defaultValue
        self.oraInizioServizio = Date()
        self.oraFineServizio = self.oraInizioServizio
        self.giorniDelServizio = []
        
    }
    
    private func dayDescription() -> [String] {
        
        var giorniServizio: [String] = []
        
        for day in giorniDelServizio {
            
            giorniServizio.append(day.simpleDescription())
        }
        
        return giorniServizio
    }
    
    
    private func sheduleANewService() {
        
        switch nuovoMenuDelServizio {
            
        case .colazione:
            let servizio = MenuDelServizio.colazione(inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        case .brunch:
            let servizio = MenuDelServizio.brunch(inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        case .pranzo:
            let servizio = MenuDelServizio.pranzo(inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        case .aperitivo:
            let servizio = MenuDelServizio.aperitivo(inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        case .cena:
            let servizio = MenuDelServizio.cena(inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        case .custom:
            let servizio = MenuDelServizio.custom(nome:nuovoNomeMenu,inizio: oraInizioServizio.ISO8601Format(), fine: oraFineServizio.ISO8601Format(), giorni: self.giorniDelServizio)
            self.scheduleMenuEServizio.append(servizio)
        }
        
        withAnimation {
            self.resetValue()
        }
        
    
    }
    
    
    
}

struct SchedulePropertyService_Previews: PreviewProvider {
    static var previews: some View {
        SchedulePropertyService(dismissView: .constant(true))
    }
}
