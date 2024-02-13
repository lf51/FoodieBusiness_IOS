//
//  DishChangingIngredient_RowSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/09/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/*
 On Appear:
 • idIngredienteDaSostituire != nil && idSavedSubstitute != nil : Esiste un cambio temporaneo in essere
 • idIngredienteDaSostituire != nil && idSavedSubstitute == nil : Non esiste un cambio temporaneo in essere
 
 Opzioni:
 1. Mantieni con Cambio temporaneo (se presente) // default
 2. Sostituisci con idGlobale o Locale
 3. Sostituisci con Cambio Temporaneo (se presente)
 */
struct ModuloSP_RowSub: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var dish: ProductModel

    let nomeIngredienteCorrente: String
    let idIngredienteCorrente: String
    
    let idSostitutoGlobale: String?
    let nomeSostitutoGlobale: String?
   
    let mapArray: [IngredientModel]
    @State private var nomeSostitutoLocale: String?
    
    @Binding private var idProductsModified:[String]
    @Binding private var replaceWithTemporary:[String]
    
    init(dish: Binding<ProductModel>,idProductModified:Binding<[String]>,replaceWithTemporary:Binding<[String]>,nomeIngredienteCorrente: String, idSostitutoGlobale: String?,nomeSostitutoGlobale:String?, idIngredienteCorrente: String, mapArray:[IngredientModel]) {

        _dish = dish
        _idProductsModified = idProductModified
        _replaceWithTemporary = replaceWithTemporary
        
        self.nomeIngredienteCorrente = nomeIngredienteCorrente
        self.idSostitutoGlobale = idSostitutoGlobale
        self.nomeSostitutoGlobale = nomeSostitutoGlobale
        self.idIngredienteCorrente = idIngredienteCorrente
        self.mapArray = mapArray
        
    }

    var body: some View {
        
        VStack(alignment:.leading) {
                
            let hasToBeReplaceFromTemporary = self.replaceWithTemporary.contains(self.dish.id)
            
                GenericItemModel_RowViewMask(
                    model: self.dish,
                    pushImage: "arrow.left.arrow.right.circle") {
                    
                      /*  Button {
                            self.daNonSostituireAction()
                        } label: {
                            
                            HStack {
                                Text("Mantieni \(nomeIngredienteCorrente) ")
                                    .foregroundStyle(Color.black)
                                
                                Image(systemName: self.dish.idIngredienteDaSostituire == nil ? "checkmark.circle" : "circle")
                                
                            }
                        }*/

                    Button {
                        self.replaceFromTemporary()
                    } label: {
                        
                        HStack {
                            Text("Rendi Permanente il cambio temporaneo")
                                .foregroundStyle(Color.black)
                            
                            Image(systemName: hasToBeReplaceFromTemporary ? "checkmark.circle" : "circle")
                            
                        }
                    }.disabled(self.dish.offManager?.idSavedSubstitute == nil)
                    
                    
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
                        }
                        .disabled(isIngredientIn && !isIngredientSelected) // da capire
                        .disabled(hasToBeReplaceFromTemporary)
                    }
                }//.padding(.vertical,5)
                .overlay {
                    if self.idProductsModified.contains(dish.id) {
                        
                        CS_VelaShape()
                            .foregroundStyle(Color.yellow)
                            .cornerRadius(15.0)
                            .opacity(0.8)
                        
                    } else if self.replaceWithTemporary.contains(dish.id) {
                        
                        CS_VelaShape()
                            .foregroundStyle(Color.seaTurtle_4)
                            .cornerRadius(15.0)
                            .opacity(0.8)
                        
                    }
                        }
                
            HStack {
                //switchInfo()
                infoSostituzionePermamente()
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
        
        let hasToBeReplaceFromTemporary = self.replaceWithTemporary.contains(self.dish.id)
        
        guard !hasToBeReplaceFromTemporary else { return }
        
        self.dish.offManager?.elencoIngredientiOff[self.idIngredienteCorrente] = self.idSostitutoGlobale == nil ? self.dish.offManager?.idSavedSubstitute : self.idSostitutoGlobale
                
    }
    
   private func replaceFromTemporary() {
       
       let hasToBeReplaceFromTemporary = self.replaceWithTemporary.contains(self.dish.id)
       
       if hasToBeReplaceFromTemporary { self.reverseReplaceTemp() }
       else { self.replaceTempAction() }
    }
    
    private func replaceTempAction() {
        
        guard let savedSub = self.dish.offManager?.idSavedSubstitute else { return }
        
        if self.dish.offManager?.elencoIngredientiOff[self.idIngredienteCorrente] != savedSub {
            
            self.dish.offManager?.elencoIngredientiOff.updateValue(savedSub, forKey: self.idIngredienteCorrente)
        }
        
        self.replaceWithTemporary.append(self.dish.id)
        
      /* if self.idProductsModified.contains(self.dish.id) {
            self.idProductsModified.removeAll(where: {$0 == self.dish.id})
        }*/
    }
    
    private func reverseReplaceTemp() {
        
        self.replaceWithTemporary.removeAll(where: {$0 == self.dish.id})
        
    }
    
  /*  private func daNonSostituireAction() {
        
        if self.dish.idIngredienteDaSostituire == nil {
            
            self.dish.idIngredienteDaSostituire = idIngredienteCorrente
           
            self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = self.idSostitutoGlobale
       
        } else {
            self.dish.idIngredienteDaSostituire = nil
            
            if let savedValue = self.dish.idSavedSubstitute {
                
                self.dish.elencoIngredientiOff?.updateValue(savedValue, forKey: self.idIngredienteCorrente)
            } else {
                self.dish.elencoIngredientiOff?.removeValue(forKey: self.idIngredienteCorrente)
            }
            
            
           // self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = nil
            
        }
    
    }*/
    
    private func action(isIngredientSelected:Bool,idIngredient:String,nomeIngrediente:String) {
        
       /* if self.dish.idIngredienteDaSostituire == nil {
            self.dish.idIngredienteDaSostituire = idIngredienteCorrente
        }*/
        
        if isIngredientSelected {
            
            if let savedValue = self.dish.offManager?.idSavedSubstitute {
                
                self.dish.offManager?.elencoIngredientiOff.updateValue(savedValue, forKey: self.idIngredienteCorrente)
            } else {
                self.dish.offManager?.elencoIngredientiOff.removeValue(forKey: self.idIngredienteCorrente)
            }
            
            self.nomeSostitutoLocale = nil
            
        } else {
            
            self.dish.offManager?.elencoIngredientiOff.updateValue(idIngredient, forKey: self.idIngredienteCorrente)
            self.nomeSostitutoLocale = nomeIngrediente
        }
        
    }
    
    private func isInAndSelected(idIngredient:String) -> (isIn:Bool,isSelect:Bool) {
        
        let isIngredientIn = self.dish.checkIngredientsIn(idIngrediente: idIngredient)
        
        let isIngredientSelected = self.dish.offManager?.elencoIngredientiOff[self.idIngredienteCorrente] == idIngredient
 
        return (isIngredientIn,isIngredientSelected)
    }
    
   /* private func switchInfo() -> Text {
        
       return infoSostituzionePermamente()
       
    }*/
    
    private func infoSostituzionePermamente() -> Text {
        // non possono essere entrambe vere perchè nella logica o entra in uno o nell'altra o in nessuna
        let isModified = self.idProductsModified.contains(self.dish.id)
        let isFromTemp = self.replaceWithTemporary.contains(self.dish.id)
        
        if !isModified && !isFromTemp {
            
            if nomeSostitutoGlobale != nil &&
            idSostitutoGlobale == nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro sostituto o altrimenti l'ingrediente \(nomeIngredienteCorrente) non subirà modifiche.")
            } else {
                
                return Text(" In questo prodotto l'ingrediente \(nomeIngredienteCorrente) non ha subito modifiche. Restano in essere eventuali cambi temporanei.")
            }
        }
        
        else if isModified {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà rimosso e sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
            
        }
        
        else if isFromTemp {
            
            return Text(" In questo prodotto per l'ingrediente \(nomeIngredienteCorrente) il cambio temporaneo diverrà permanente.")
            
        }
        
        else {
            return Text(" ERROR_ERROR")
        }
        
      /*  else if self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] == nil {
            
            if idSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) sarà semplicemente rimosso dal piatto.")
            }
            
           else if nomeSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro sostituto o altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà semplicemente rimosso.")
                
            } else {
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto. Alternativamente sarà rimosso.")
            }
  
        }
        
        else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà rimosso e sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }*/
    }
    
   /* private func infoSostituzionePermamente() -> Text {
        
        if self.dish.idIngredienteDaSostituire == nil {
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) resterà fra gli ingredienti del piatto.")
        }
        
        else if self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] == nil {
            
            if idSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) sarà semplicemente rimosso dal piatto.")
            }
            
           else if nomeSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro sostituto o altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà semplicemente rimosso.")
                
            } else {
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto. Alternativamente sarà rimosso.")
            }
  
        }
        
        else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà rimosso e sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }
    }*/ // bckup 01_02_24
    
}

