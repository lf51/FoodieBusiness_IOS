//
//  ModuloST_RowSub.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 26/01/24.
//  Created by Calogero Friscia on 01/09/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct ModuloST_RowSub: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var dish: ProductModel
    
    let nomeIngredienteCorrente: String
    let idIngredienteCorrente: String
    
    let idSostitutoGlobale: String?
    let nomeSostitutoGlobale: String?
   
    let mapArray: [IngredientModel]
    @State private var nomeSostitutoLocale: String?
    
    @Binding private var idProductsModified:[String]
    
    init(dish: Binding<ProductModel>,idProductModified:Binding<[String]>,nomeIngredienteCorrente: String, idSostitutoGlobale: String?,nomeSostitutoGlobale:String?, idIngredienteCorrente: String, mapArray:[IngredientModel]) {

        _dish = dish
        _idProductsModified = idProductModified
    
        self.nomeIngredienteCorrente = nomeIngredienteCorrente
        self.idSostitutoGlobale = idSostitutoGlobale
        self.nomeSostitutoGlobale = nomeSostitutoGlobale
        self.idIngredienteCorrente = idIngredienteCorrente
        self.mapArray = mapArray
        
    }

    var body: some View {
        
        VStack(alignment:.leading) {
                
                GenericItemModel_RowViewMask(model: self.dish,pushImage: "arrow.left.arrow.right.circle") {
  
                    ForEach(mapArray,id:\.self) { ingredient in

                        let (isIngredientIn,isIngredientSelected) = isInAndSelected(idIngredient: ingredient.id)
                        let image:String = isIngredientSelected ? "checkmark.circle" : "circle"
                        let isAsSaved = self.dish.offManager?.idSavedSubstitute == ingredient.id
                        
                        Button {
                            
                            self.action(
                                isIngredientSelected: isIngredientSelected,
                                idIngredient: ingredient.id,
                                nomeIngrediente: ingredient.intestazione)
                            
                        } label: {
              
                            let string1 = isAsSaved ? "📍" : ""
                            let string2 = ingredient.intestazione
                            let string3 = ingredient.statoScorteDescription()
                            
                            HStack {
                                Text("\(string1) \(string2) (\(string3))")
                                    .foregroundStyle(Color.black)
                              
                                Image(systemName: image)
                                
                            }
                        }.disabled(isIngredientIn && !isIngredientSelected)
                    }
                }//.padding(.vertical,5)
                .overlay {
                    
                    if self.idProductsModified.contains(dish.id) {
                        
                        CS_VelaShape()
                        .foregroundStyle(Color.yellow)
                        .cornerRadius(15.0)
                        .opacity(0.8)
                    }
    
                }
  
            HStack {
                //switchInfo()
                infoSostituzioneTemporanea()
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.leading)
                   
                Spacer()
                
            }
            .frame(width:.minimum((UIScreen.main.bounds.width - 40),650)) // 650 è il valore di default delle row. Al momento(02.09) non è un valore che cambia, per cui lo possiamo impostare statico. Qualora dovessimo cambiarlo nella CSZStack framed, dovremmo cambiarlo anche qui. Poco efficente, ma abbiamo provato a smanettare col geometry reader e non riusciamo. E per quello che vogliamo ottenere troppo smanettamento non vale la candela
        }
        
       
     // .padding(.horizontal)
        .onAppear { onAppearAction() }
        .onChange(of: self.dish) { _ , new in
            
            let value = new.offManager?.elencoIngredientiOff[self.idIngredienteCorrente]
            
            let changeAppen = value != self.dish.offManager?.idSavedSubstitute
            let isAlreadyIn = self.idProductsModified.contains(self.dish.id)
            
            let hasToBeNotified = changeAppen && !isAlreadyIn
            let hasToBeRemoved = !changeAppen && isAlreadyIn
            
            if hasToBeNotified {
                
                self.idProductsModified.append(self.dish.id)
            }
            
            if hasToBeRemoved {
                
                self.idProductsModified.removeAll(where: {$0 == self.dish.id})
            }
            
        }
        
    }
        
    // Method
    
    private func onAppearAction() {

      /* Casi:
       
       1. Il piatto ha elenco off nil // test ok
       2. Elenco off != nil con sostituto ingrediente corrente // test ok
       3. Elenco off != nil con sostuto di altro ingrediente // test ok 
       
       */
         
       /* guard self.dish.elencoIngredientiOff != nil else {
            
            let dictionary:[String:String] = [:]
            self.dish.elencoIngredientiOff = dictionary
            
            return
        }*/
        
        self.dish.offManager?.elencoIngredientiOff[self.idIngredienteCorrente] = self.idSostitutoGlobale == nil ? self.dish.offManager?.idSavedSubstitute : self.idSostitutoGlobale

    }
    
    private func action(isIngredientSelected:Bool,idIngredient:String,nomeIngrediente:String) {
        
        if isIngredientSelected {
            self.dish.offManager?.elencoIngredientiOff.removeValue(forKey: self.idIngredienteCorrente)
            self.nomeSostitutoLocale = nil
            
        } else {
            
            self.dish.offManager?.elencoIngredientiOff.updateValue(idIngredient, forKey: self.idIngredienteCorrente)
            self.nomeSostitutoLocale = nomeIngrediente
        }
        
      /*  self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = isIngredientSelected ? nil : idIngredient
        
        self.nomeSostitutoLocale = isIngredientSelected ? nil : nomeIngrediente*/

    }
    
    private func isInAndSelected(idIngredient:String) -> (isIn:Bool,isSelect:Bool) {
        
        let isIngredientIn = self.dish.checkIngredientsIn(idIngrediente: idIngredient)
        
        let isIngredientSelected = self.dish.offManager?.elencoIngredientiOff[self.idIngredienteCorrente] == idIngredient
 
        return (isIngredientIn,isIngredientSelected)
    }
    
    private func infoSostituzioneTemporanea() -> Text {
        
        let value = self.dish.offManager?.fetchSubstitute(for: self.idIngredienteCorrente) //.elencoIngredientiOff?[self.idIngredienteCorrente]
        
        guard value != self.dish.offManager?.idSavedSubstitute else {
            
            if value == nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) non ha un sostituto temporaneo.")
                
            } else {
                
                return Text("Il sostituto dell'ingrediente \(nomeIngredienteCorrente) non ha subito variazioni.")
            }
        }
        
        if value == nil {
            
            if idSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) manca di un sostituto temporaneo.")
            }
            
           else if nomeSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(nomeIngredienteCorrente) mancherà di un sostituto temporaneo.")
                
            } else {
                
                return Text("Il sostituto temporaneo dell'ingrediente \(nomeIngredienteCorrente) è stato rimosso.")
            }
  
        } else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà temporaneamente sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }
    }
    
}

