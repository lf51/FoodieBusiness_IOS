//
//  BottomNuovoMenu_SubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import SwiftUI

struct BottomNuovoMenu_SubView: View {
    
    @Binding var nuovoMenu: MenuModel
    @State private var showDialog: Bool = false
    let doneAction: () -> Void
    
    var isThereAReasonToDisable:(reset: Bool, done:Bool) {
        
        let disableReset = self.nuovoMenu.intestazione == ""
        
        let disableDone = self.nuovoMenu.isAvaibleWhen == .defaultValue
        
        return (disableReset,disableDone)
    }
    
    var body: some View {
       
        HStack {
                
          /*  Text("Il menu \(nuovoMenu.intestazione) è attivo dalle \(timeFormatter.string(from: self.nuovoMenu.oraInizio)) alle \(timeFormatter.string(from: self.nuovoMenu.oraFine)) nei giorni di \(dayDescription(),format:.list(type: .and))")
                    .italic().fontWeight(.light).font(.caption) */
            
            Text(self.nuovoMenu.isAvaibleWhen.extendedDescription() ?? "")
                .font(.caption)
                .fontWeight(.light)
                .italic()
                
                
            
            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) {
                
                self.resetValue()
                
            }
           .opacity(self.isThereAReasonToDisable.reset ? 0.6 : 1.0)
           .disabled(self.isThereAReasonToDisable.reset)
            
         
           CSButton_tight(title: "Done", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {

               self.showDialog = true // test
              // self.scheduleANewMenu()
                
           }
           .opacity(self.isThereAReasonToDisable.done ? 0.6 : 1.0)
           .disabled(self.isThereAReasonToDisable.done)
            
        }
        .padding(.vertical)
        .confirmationDialog(
                menuDescription(),
                isPresented: $showDialog,
                titleVisibility: .visible) {
                
                Button("Conferma Menu", role: .none) {self.doneAction()}
            }
        
    }
    
    // Method

 
    private func resetValue() {

        self.nuovoMenu = MenuModel()

    }
    
   private func menuDescription() -> Text {
        
           var giorniServizio: [String] = []
        
        for day in self.nuovoMenu.giorniDelServizio {
            
            giorniServizio.append(day.simpleDescription())
        }
        
           let nome = self.nuovoMenu.intestazione
           let dataInizio = myTimeFormatter().data.string(from:self.nuovoMenu.dataInizio)
           let dataFine = myTimeFormatter().data.string(from:self.nuovoMenu.dataFine)
           let oraInizio = myTimeFormatter().ora.string(from: self.nuovoMenu.oraInizio)
           let oraFine = myTimeFormatter().ora.string(from: self.nuovoMenu.oraFine)
           
       switch self.nuovoMenu.isAvaibleWhen {
           
       case .dataEsatta:
           return Text("Il menu \(nome) sarà attivo il giorno \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
       case .intervalloAperto:
           return Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
       case .intervalloChiuso:
           return Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(dataFine), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
       case .noValue:
           return Text("")
           
       }

                 
    }
    
    
  /*  private func scheduleANewMenu() {
            
        print("Nome Menu: \(self.nuovoMenu.intestazione)")
        print("data Inizio:\(self.nuovoMenu.dataInizio.ISO8601Format())")
        print("data Fine: \(self.nuovoMenu.dataFine.ISO8601Format())")
        print("nei giorni di: \(self.nuovoMenu.giorniDelServizio.description)")
        print("dalle \(self.nuovoMenu.oraInizio.ISO8601Format()) alle \(self.nuovoMenu.oraFine.ISO8601Format())")
        
        
       print("Salvare MenuModel nel firebase e/o nell'elenco dei Menu in un ViewModel")
    } */
}

/*struct BottomNuovoMenu_SubView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNuovoMenu_SubView()
    }
} */
