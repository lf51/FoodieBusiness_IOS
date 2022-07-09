//
//  BottomNuovoMenu_SubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/03/22.
//

import SwiftUI

/*struct BottomNuovoMenu_SubView<Content: View>: View {
    
    @Binding var nuovoMenu: MenuModel
    @State private var showDialog: Bool = false
    let resetAction: () -> Void
    @ViewBuilder var dialogView:Content
    
   var isThereAReasonToDisable:Bool {

        let disableDone = self.nuovoMenu.isAvaibleWhen == nil
        
        return disableDone
    }

    var body: some View {
       
        HStack {
                
            menuDescription()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()
            
            CSButton_tight(title: "Reset", fontWeight: .light, titleColor: Color.red, fillColor: Color.clear) { self.resetAction() }

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {

               self.showDialog = true
                
           }
           .opacity(self.isThereAReasonToDisable ? 0.6 : 1.0)
           .disabled(self.isThereAReasonToDisable)
            
        }
        .padding(.vertical)
        .confirmationDialog(
                menuDescription(),
                isPresented: $showDialog,
                titleVisibility: .visible) { dialogView }
        
    }
    
    // Method
    
   private func menuDescription() -> Text {
        
           var giorniServizio: [String] = []
        
        for day in self.nuovoMenu.giorniDelServizio {
            
            giorniServizio.append(day.simpleDescription())
        }
        
           let nome = self.nuovoMenu.intestazione
           let dataInizio = csTimeFormatter().data.string(from:self.nuovoMenu.dataInizio)
           let dataFine = csTimeFormatter().data.string(from:self.nuovoMenu.dataFine)
           let oraInizio = csTimeFormatter().ora.string(from: self.nuovoMenu.oraInizio)
           let oraFine = csTimeFormatter().ora.string(from: self.nuovoMenu.oraFine)
           
       switch self.nuovoMenu.isAvaibleWhen {
           
       case .dataEsatta:
           return Text("Il menu \(nome) sarà attivo il giorno \(dataInizio), dalle ore \(oraInizio) alle ore \(oraFine)")
       case .intervalloAperto:
           return Text("Il menu \(nome) sarà attivo a partire dal giorno \(dataInizio), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
       case .intervalloChiuso:
           return Text("Il menu \(nome) sarà attivo dal \(dataInizio) al \(dataFine), nei giorni di \(giorniServizio,format: .list(type: .and)), dalle ore \(oraInizio) alle ore \(oraFine)")
     //  case .noValue:
       //    return Text("")
       case nil:
           return Text("Nessuna Info")
           
       }

                 
    }

} */// Deprecata 09.07 in favore di una generics

/*struct BottomNuovoMenu_SubView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNuovoMenu_SubView()
    }
} */
