//
//  DishChangingIngredient_RowSubView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/09/22.
//

import SwiftUI
import MyFoodiePackage

// deprecato in futuro
struct DishChangingIngredient_RowSubView: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var dish: ProductModel
    @Binding var isDeactive: Bool
    
    let isPermanente: Bool
    let nomeIngredienteCorrente: String
    let idIngredienteCorrente: String
    
    let idSostitutoGlobale: String?
    let nomeSostitutoGlobale: String?
   
    let mapArray: [IngredientModel]
    @State private var nomeSostitutoLocale: String?
    
    init(dish: Binding<ProductModel>,isDeactive:Binding<Bool>,isPermanente:Bool, nomeIngredienteCorrente: String, idSostitutoGlobale: String?,nomeSostitutoGlobale:String?, idIngredienteCorrente: String, mapArray:[IngredientModel]) {

        _dish = dish
        _isDeactive = isDeactive
        self.isPermanente = isPermanente
        self.nomeIngredienteCorrente = nomeIngredienteCorrente
        self.idSostitutoGlobale = idSostitutoGlobale
        self.nomeSostitutoGlobale = nomeSostitutoGlobale
        self.idIngredienteCorrente = idIngredienteCorrente
        self.mapArray = mapArray
        
    }

    var body: some View {
        
        VStack(alignment:.leading) {
                
                GenericItemModel_RowViewMask(model: self.dish,pushImage: "arrow.left.arrow.right.circle") {
                    
                    if isPermanente {
                        Button {
                            self.daNonSostituireAction()
                        } label: {
                            
                            HStack {
                                Text("!! Lascia Attivo !! ")
                                    .foregroundStyle(Color.black)
                                
                                Image(systemName: self.dish.idIngredienteDaSostituire == nil ? "checkmark.circle" : "circle")
                                
                            }
                        }

                    }
                    
                    
                    ForEach(mapArray,id:\.self) { ingredient in

                        let (isIngredientIn,isIngredientSelected) = isInAndSelected(idIngredient: ingredient.id)
                        
                        Button {
                            self.action(isIngredientSelected: isIngredientSelected, idIngredient: ingredient.id, nomeIngrediente: ingredient.intestazione)
                        } label: {
                            HStack {
                                Text(ingredient.intestazione)
                                    .foregroundStyle(Color.black)
                                
                                Image(systemName: isIngredientSelected ? "checkmark.circle" : "circle")
                                
                            }
                        }.disabled(isIngredientIn && !isIngredientSelected)
                    }
                }//.padding(.vertical,5)
  
            HStack {
                switchInfo()
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.leading)
                   
                Spacer()
                
            }
            .frame(width:.minimum((UIScreen.main.bounds.width - 40),650)) // 650 è il valore di default delle row. Al momento(02.09) non è un valore che cambia, per cui lo possiamo impostare statico. Qualora dovessimo cambiarlo nella CSZStack framed, dovremmo cambiarlo anche qui. Poco efficente, ma abbiamo provato a smanettare col geometry reader e non riusciamo. E per quello che vogliamo ottenere troppo smanettamento non vale la candela  
        }
        
       
     // .padding(.horizontal)
        .onAppear {

            self.dish.idIngredienteDaSostituire = self.idIngredienteCorrente
            if self.dish.elencoIngredientiOff != nil {
                
                self.dish.elencoIngredientiOff![self.idIngredienteCorrente] = self.idSostitutoGlobale
                
            } else {
                
                var dictionary:[String:String] = [:]
                dictionary[self.idIngredienteCorrente] = self.idSostitutoGlobale
                self.dish.elencoIngredientiOff = dictionary
   
            }
        }
        .onChange(of: self.isPermanente) { _ , newValue in
            if !newValue {
                self.dish.idIngredienteDaSostituire = idIngredienteCorrente
                self.dish.elencoIngredientiOff![self.idIngredienteCorrente] = self.idSostitutoGlobale
            }
        }
        
    }
    
    // Method
    private func daNonSostituireAction() {
        
        if self.dish.idIngredienteDaSostituire == nil {
            
            self.dish.idIngredienteDaSostituire = idIngredienteCorrente
            self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = self.idSostitutoGlobale
       
        } else {
            self.dish.idIngredienteDaSostituire = nil
            self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = nil
            
        }
    
    }
    
    private func action(isIngredientSelected:Bool,idIngredient:String,nomeIngrediente:String) {
        
        if self.dish.idIngredienteDaSostituire == nil {
            self.dish.idIngredienteDaSostituire = idIngredienteCorrente
        }
        
        self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] = isIngredientSelected ? nil : idIngredient
        self.nomeSostitutoLocale = isIngredientSelected ? nil : nomeIngrediente

    }
    
    private func isInAndSelected(idIngredient:String) -> (isIn:Bool,isSelect:Bool) {
        
        let isIngredientIn = self.dish.checkIngredientsIn(idIngrediente: idIngredient)
        let isIngredientSelected = self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] == idIngredient
 
        return (isIngredientIn,isIngredientSelected)
    }
    
    private func switchInfo() -> Text {
        
        if isPermanente { return infoSostituzionePermamente() }
        else { return infoSostituzioneTemporanea() }
    }
    
    private func infoSostituzioneTemporanea() -> Text {
        
        if self.dish.elencoIngredientiOff?[self.idIngredienteCorrente] == nil {
            
            if idSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeIngredienteCorrente) sarà mostrato in pausa senza un sostituto.")
            }
            
           else if nomeSostitutoGlobale != nil {
                
                return Text("L'ingrediente \(nomeSostitutoGlobale!) è già presente nel piatto. Selezionare un altro elemento altrimenti l'ingrediente \(nomeIngredienteCorrente) sarà mostrato in pausa senza un sostituto.")
                
            } else {
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto.")
            }
  
        } else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }
    }
    
    private func infoSostituzionePermamente() -> Text {
        
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
                
                return Text("In sostituzione del \(nomeIngredienteCorrente) selezionare un ingrediente non già presente nel piatto.")
            }
  
        }
        
        else {
            
            let nomeSostituto = nomeSostitutoLocale == nil ? nomeSostitutoGlobale : nomeSostitutoLocale
            
            return Text("L'ingrediente \(nomeIngredienteCorrente) sarà rimosso e sostituito dall'ingrediente \(nomeSostituto ?? "ErroreNomeSostituto").")
        }
    }
    
}  // BackUp 08.09
