//
//  NuovoMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import SwiftUI

struct NuovoMenuMainView: View {

    @State private var nuovoMenu: MenuModel
    
 //   @State private var wannaCreateNewMenu: Bool? = false
    @State private var nuovoNomeMenu: String = ""
 
  //  @State private var wannaDeleteMenuDelServizio:Bool? = false
    @Binding var dismissView:Bool?
    
    init(editMenu:MenuModel? = MenuModel(), dismissView: Binding<Bool?>? = nil) {
        
        _dismissView = dismissView ?? .constant(nil)
        _nuovoMenu = State(wrappedValue: editMenu!)
            
    }

    var timeFormatter: DateFormatter {
        
        let time = DateFormatter()
       // time.dateStyle = .none // Possiamo ometterlo
        time.timeStyle = .short
        
        return time
    }
    
    var isThereAReasonToDisable: (date: Bool, days: Bool, button:Bool) {

        return (false,false,false)
       
    }
    
    var valueTo:(disableDate:Bool, disableDays:Bool, titlePicker:String) {
        
        switch self.nuovoMenu.isAvaibleWhen {
            
        case .dataEsatta:
            return (true,true,"li:")
        case.intervalloAperto:
            return(true,false,"dal:")
        case .intervalloChiuso:
            return(false,false,"dal:")
            
        }
        
    }
    
    
    var body: some View {
        
        VStack {
            
            TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                .padding(.horizontal)
 
            VStack(alignment: .leading) {
                
                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (Interno)", imageLabel: "doc.badge.plus", coloreContainer: Color.red, itemModel: $nuovoMenu)
                
                CSLabel_1Button(placeHolder: "Tipologia", imageName: "dollarsign.circle", backgroundColor: Color.black)
                EnumScrollCases(cases: TipologiaMenu.allCases, dishSingleProperty: $nuovoMenu.tipologia, colorSelection: Color.brown)
                
                CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen)
                
                HStack {
                    
                    DatePicker(valueTo.titlePicker, selection: self.$nuovoMenu.dataInizio, displayedComponents: .date)
                    
                    Text("     -->     ")
                    
                    DatePicker("al:", selection: self.$nuovoMenu.dataFine, displayedComponents: .date)
                        .opacity(self.valueTo.disableDate ? 0.2 : 1.0)
                        .disabled(self.valueTo.disableDate)
                    
                }
                 
                EnumScrollCases(cases: GiorniDelServizio.allCases, dishCollectionProperty: self.$nuovoMenu.giorniDelServizio, colorSelection: Color.mint)
                        .opacity(self.valueTo.disableDays ? 0.4 : 1.0)
                        .disabled(self.valueTo.disableDays)
                        
                HStack {
                    
                    DatePicker("dalle:", selection: self.$nuovoMenu.oraInizio, displayedComponents: .hourAndMinute)
                        
                    Text("     -->     ")
                    
                    DatePicker("alle:", selection: self.$nuovoMenu.oraFine, in: (self.nuovoMenu.oraInizio.addingTimeInterval(1800.0))...,displayedComponents: .hourAndMinute)
                    
                }
                .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
                .disabled(self.isThereAReasonToDisable.date)
                
                
                
        
                        HStack {
                            
                            if !isThereAReasonToDisable.days {
                                
                                Text("Il menu \(nuovoMenu.intestazione) è attivo dalle \(timeFormatter.string(from: self.nuovoMenu.oraInizio)) alle \(timeFormatter.string(from: self.nuovoMenu.oraFine)) nei giorni di \(dayDescription(),format:.list(type: .and))")
                                    .italic().fontWeight(.light).font(.caption)
                            
                            }
                            
                            Spacer()
                            
                            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) {
                                
                                self.resetValue()
                                
                            }
                            .opacity(self.isThereAReasonToDisable.date ? 0.4 : 1.0)
                            .disabled(self.isThereAReasonToDisable.date)
                            
                         
                           CSButton_tight(title: "Done", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                            
                             //   self.sheduleANewService()
                               self.scheduleANewMenu()
                                
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

        self.nuovoMenu = MenuModel()

    }
    
    private func dayDescription() -> [String] {
        
        var giorniServizio: [String] = []
        
        for day in self.nuovoMenu.giorniDelServizio {
            
            giorniServizio.append(day.simpleDescription())
        }
        
        return giorniServizio
    }
    
    
    private func scheduleANewMenu() {
            
        print("Nome Menu: \(self.nuovoMenu.intestazione)")
        print("data Inizio:\(self.nuovoMenu.dataInizio.ISO8601Format())")
        print("data Fine: \(self.nuovoMenu.dataFine.ISO8601Format())")
        print("nei giorni di: \(self.nuovoMenu.giorniDelServizio.description)")
        print("dalle \(self.nuovoMenu.oraInizio.ISO8601Format()) alle \(self.nuovoMenu.oraFine.ISO8601Format())")
        
        
       print("Salvare MenuModel nel firebase e/o nell'elenco dei Menu in un ViewModel")
    }
 
    
}

struct NuovoMenuMainView_Previews: PreviewProvider {
    static var previews: some View {
        NuovoMenuMainView(dismissView: .constant(true))
    }
}


