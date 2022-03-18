//
//  NuovoMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/03/22.
//

import SwiftUI

struct NuovoMenuMainView: View {

    @State private var nuovoMenu: MenuModel
    @Binding var dismissView:Bool?
    @State private var nuovaIntestazioneMenu: String = ""
    
    init(editMenu:MenuModel? = MenuModel(), dismissView: Binding<Bool?>? = nil) {
        
        _dismissView = dismissView ?? .constant(nil)
        _nuovoMenu = State(wrappedValue: editMenu!)
            
    }
    
    var isThereAReasonToDisable: (tipologia:Bool, programmazione: Bool) {

      let disableTipologia = self.nuovoMenu.intestazione == ""
      let disableProgrammazione = self.nuovoMenu.tipologia == .defaultValue
        
      return (disableTipologia,disableProgrammazione)
    }
 
    var body: some View {
        
        VStack {
            
            TopBar_3BoolPlusDismiss(title: nuovoMenu.intestazione != "" ? nuovoMenu.intestazione : "Crea Menu", exitButton: $dismissView, exitButtonTitle: "Chiudi")
                .padding(.horizontal)
 
            VStack(alignment: .leading) {
                
                IntestazioneNuovoOggetto_Generic(placeHolderItemName: "Menu (Interno)", imageLabel: "doc.badge.plus", coloreContainer: Color.red, itemModel: $nuovoMenu)
                
                CSLabel_1Button(placeHolder: "Tipologia", imageName: "dollarsign.circle", backgroundColor: Color.black)
                
                SpecificTipologiaNuovoMenu_SubView(newMenu: $nuovoMenu)
                    .opacity(isThereAReasonToDisable.tipologia ? 0.6 : 1.0)
                    .disabled(isThereAReasonToDisable.tipologia)

                CSLabel_2Button(placeHolder: "Ristoranti", imageName: "circle", backgroundColor: Color.black, toggleBottoneTEXT: .constant(false), testoBottoneTEXT: "Scegli")
                    .opacity(0.4)
                    .disabled(true)
                
         
                
                CSLabel_1Picker(placeHolder: "Programmazione", imageName: "calendar.badge.clock", backgroundColor: Color.black, availabilityMenu: self.$nuovoMenu.isAvaibleWhen, conditionToDisablePicker: isThereAReasonToDisable.programmazione)
                    
                CorpoProgrammazioneMenu_SubView(nuovoMenu: $nuovoMenu)

                BottomNuovoMenu_SubView(nuovoMenu: $nuovoMenu)
 
            }.padding(.horizontal)
            
            
        }
        .padding(.top)
        .background(RoundedRectangle(cornerRadius: 20.0).fill(Color.cyan.opacity(0.9)).shadow(radius: 5.0))
        .contrast(1.2)
        .brightness(0.08)
        .alert(item:$nuovoMenu.alertItem) { alert -> Alert in
           Alert(
             title: Text(alert.title),
             message: Text(alert.message)
           )
         } // non funziona
    }
}

struct NuovoMenuMainView_Previews: PreviewProvider {
    static var previews: some View {
        NuovoMenuMainView(dismissView: .constant(true))
    }
}


