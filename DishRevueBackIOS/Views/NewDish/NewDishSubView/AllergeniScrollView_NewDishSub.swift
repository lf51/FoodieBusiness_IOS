//
//  SelectionMenu_NewDishSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI

struct AllergeniScrollView_NewDishSub: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var newDish: DishModel
    let generalErrorCheck: Bool
    
    let allergeniIn:[AllergeniIngrediente]
    @Binding var areAllergeniOk: Bool
    
    init(newDish:Binding<DishModel>, generalErrorCheck:Bool, areAllergeniOk:Binding<Bool>) {
       
        _newDish = newDish
        self.generalErrorCheck = generalErrorCheck
        _areAllergeniOk = areAllergeniOk
    
        self.allergeniIn = AllergeniIngrediente.returnAllergeniIn(ingredients: newDish.wrappedValue.ingredientiPrincipali,newDish.wrappedValue.ingredientiSecondari)
    }

    var body: some View {
        
        VStack(alignment:.leading) {
            
            CSLabel_conVB(
                placeHolder: "Allergeni",
                imageNameOrEmojy: "exclamationmark.shield",
                backgroundColor: Color.black) {
                    
                    Toggle(isOn: self.$areAllergeniOk) {
                        
                        HStack {
                            Spacer()
                            Text(self.areAllergeniOk ? "Confermato" : "Da Confermare")
                                .font(.system(.callout, design: .monospaced))
                            
                            CS_ErrorMarkView(generalErrorCheck: generalErrorCheck, localErrorCondition: !self.areAllergeniOk)
   
                        }
                    }
                }
            
            ScrollView(.horizontal, showsIndicators: false) {

                    HStack {
                        
                        ForEach(self.allergeniIn) { allergene in
                            
                            CSText_tightRectangle(testo: allergene.simpleDescription(), fontWeight: .light, textColor: Color.red, strokeColor: Color.red, fillColor: Color.clear)
                            
                        }
                    }
            }
            
            VStack(alignment:.leading) {

                let string_1 = self.areAllergeniOk ? "Confermata" : "Non Confermata"
               
                let string_2 = self.allergeniIn.isEmpty ? "l'assenza" : "la presenza"
                    
                HStack(spacing:0) {
                    Text("\(string_1) \(string_2) ")
                        .bold(self.areAllergeniOk)
                        .underline(self.areAllergeniOk, color: Color.black)
                            
                         Text("di Allergeni negli Ingredienti.")
                   }
                    .italic()
                    .fontWeight(.light)
                    .font(.caption)
                    .foregroundColor(Color.black)

            }
      
        }
        .onChange(of: self.allergeniIn, perform: { _ in
            self.areAllergeniOk = false
        })
        .onChange(of: self.areAllergeniOk, perform: { newValue in
            
            if newValue {
             /*   let link = Link("Regolamento UE n.1169/2011", destination: URL(string: "https://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:304:0018:0063:it:PDF")!) */
              
                viewModel.alertItem = AlertModel(
                    title: "⚠️ Attenzione",
                    message: "Il Regolamento UE n.1169/2011, entrato in vigore il 13 dicembre 2014, ha introdotto l'obbligo per produttori ed esercizi commerciali di segnalare, nei cibi, la presenza di sostanze che possono provocare allergie o intolleranze.\n\nL'applicativo fornisce un elenco dei 14 allergeni obbligatori per legge, e l'utente ha l'obbligo di associare ad ogni ingrediente l'eventuale allergene contenuto.\n\nL'utente che conferma una lista allergeni incompleta se ne assume la piena responsabilità.\n\nIn nessun caso l'applicativo può essere ritenuto responsabile della mancata e/o incompleta segnalazione degli allergeni.\n\nQualora la lista allergeni dovesse risultare incompleta, l'utente è invitato a controllare la corretta indicazione degli allergeni negli ingredienti.\n\nQualora il problema persista per un errore imputabile all'applicativo, l'utente è tenuto a NON Pubblicare o a Rimuovere il piatto, ed a segnalare il disservizio all'indirizzo mail segnalaBug@foodies.com "
                )
                self.newDish.allergeni = self.allergeniIn
                
            } else {
                
                self.newDish.allergeni = []
            }
            
        })
        
    }
    
}
