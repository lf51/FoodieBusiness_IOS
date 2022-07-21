//
//  NewDishView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 25/01/22.
//

import SwiftUI

struct NuovoIngredienteMainView: View {

    @EnvironmentObject var viewModel: AccounterVM

    @State private var nuovoIngrediente: IngredientModel
    let backgroundColorView: Color
    
    let ingredienteArchiviato: IngredientModel // per il reset
    let destinationPath: DestinationPath
    
    @State private var generalErrorCheck: Bool = false
    
    @State private var isConservazioneOk: Bool = false
    @State private var areAllergeniOk: Bool = false
    @State private var wannaAddAllergeni: Bool = false
    
    init(nuovoIngrediente: IngredientModel,backgroundColorView: Color,destinationPath:DestinationPath) {
        
        _nuovoIngrediente = State(wrappedValue: nuovoIngrediente)
        self.backgroundColorView = backgroundColorView
        self.destinationPath = destinationPath
        
        self.ingredienteArchiviato = nuovoIngrediente
       
    }
    
    var body: some View {
        
        CSZStackVB(title:self.nuovoIngrediente.intestazione == "" ? "Nuovo Ingrediente" : self.nuovoIngrediente.intestazione, backgroundColorView: backgroundColorView) {
            
                VStack {
                    
                    CSDivider()
                    
                    ScrollView(showsIndicators: false) {
                      
                        VStack(alignment:.leading){
                            
                            IntestazioneNuovoOggetto_Generic(
                                itemModel: $nuovoIngrediente,
                                generalErrorCheck: generalErrorCheck,
                                minLenght: 3,
                                coloreContainer: Color("SeaTurtlePalette_3"))
                               
                            BoxDescriptionModel_Generic(
                                itemModel: $nuovoIngrediente,
                                labelString: "Descrizione (Optional)",
                                disabledCondition: wannaAddAllergeni)
                            
                            // Origine
                            OrigineScrollView_NewIngredientSubView(nuovoIngrediente: $nuovoIngrediente, generalErrorCheck: generalErrorCheck)
                           
                            
                            // Allergeni
                            AllergeniScrollView_NewIngredientSubView(
                                nuovoIngrediente: self.$nuovoIngrediente,
                                generalErrorCheck: generalErrorCheck,
                                areAllergeniOk: $areAllergeniOk,
                                wannaAddAllergene: $wannaAddAllergeni)
                            
                           ConservazioneScrollView_NewIngredientSubView(
                            nuovoIngrediente: $nuovoIngrediente,
                            generalErrorCheck: generalErrorCheck,
                            isConservazioneOk: $isConservazioneOk)
                            
                            ProduzioneScrollView_NewIngredientSubView(nuovoIngrediente: $nuovoIngrediente)
                            
                            ProvenienzaScrollView_NewIngredientSubView(nuovoIngrediente: $nuovoIngrediente, generalErrorCheck: generalErrorCheck)

                            BottomViewGeneric_NewModelSubView(
                                itemModel: $nuovoIngrediente,
                                generalErrorCheck: $generalErrorCheck,
                                itemModelArchiviato: ingredienteArchiviato,
                                destinationPath: destinationPath) {
                                    infoIngrediente()
                                } checkPreliminare: {
                                    checkPreliminare()
                                }

                            
                               /* BottomViewGeneric_NewModelSubView(
                                    generalErrorCheck: $generalErrorCheck,
                                    wannaDisableButtonBar: (nuovoIngrediente == ingredienteArchiviato)) {
                                        infoIngrediente()
                                    } resetAction: {
                                        csResetModel(modelAttivo: &self.nuovoIngrediente, modelArchiviato: self.ingredienteArchiviato)
                                    } checkPreliminare: {
                                        checkPreliminare()
                                    } saveButtonDialogView: {
                                       vbScheduleANuovoIngrediente()
                                    } */

                            
                        }.padding(.horizontal)
                      
                    }
                    .zIndex(0)
                    .opacity(wannaAddAllergeni ? 0.6 : 1.0)
                    .disabled(wannaAddAllergeni)

                    if wannaAddAllergeni {
               
                        SelettoreMyModel<_,AllergeniIngrediente>(
                            itemModel: $nuovoIngrediente,
                            allModelList: ModelList.ingredientAllergeniList,
                            closeButton: $wannaAddAllergeni,
                            backgroundColorView: backgroundColorView,
                            actionTitle: "Normativa") {
                                print("Inserire Link Normativa Allergeni")
                            }
                        
                    }
                    
                    
               CSDivider()
                    
                    }
    
       }
      // .csAlertModifier(isPresented: $viewModel.showAlert, item: viewModel.alertItem)
    }
    // Method
    
    private func infoIngrediente() -> Text {
        
        var stringaAlllergeni: String = "Presenza/assenza Allergeni non Confermata"
        var stringaCongeSurge: String = "Metodo di Conservazione non confermato"
        var metodoProduzione: String = ""
        
        if areAllergeniOk {
            
            if self.nuovoIngrediente.allergeni.isEmpty {
                stringaAlllergeni = "Questo ingrediente è privo di Allergeni."
            } else {
    
                let count = self.nuovoIngrediente.allergeni.count
                stringaAlllergeni = "Questo ingrediente contiene \(count > 1 ? "\(count) Allergeni" : "1 Allergene")."
            }
        }
        
        if isConservazioneOk {
            
             stringaCongeSurge = "Questo prodotto \( self.nuovoIngrediente.conservazione.extendedDescription() ?? "")."
            
        }
        
        if self.nuovoIngrediente.produzione == .biologico {
            metodoProduzione = "Prodotto BIO."
        }
        
        return Text("\(stringaAlllergeni)\n\(stringaCongeSurge)\n\(metodoProduzione)")
    }
    
    private func checkPreliminare() -> Bool {
        
        guard checkIntestazione() else { return false }
        
        guard checkOrigine() else { return false }
        
        guard self.areAllergeniOk else { return false }
        
        guard self.isConservazioneOk else { return false }
        
        guard checkLuogoProduzione() else { return false }
        
        self.nuovoIngrediente.status = .completo(.archiviato)
        return true 
    }
    
    private func checkLuogoProduzione() -> Bool {
        
        self.nuovoIngrediente.provenienza != .defaultValue
    }
    
    private func checkOrigine() -> Bool {
        
         self.nuovoIngrediente.origine != .defaultValue
        
    }
    
    private func checkIntestazione() -> Bool {
    
         self.nuovoIngrediente.intestazione != ""
   
    }
    
    /*
    @ViewBuilder private func vbScheduleANuovoIngrediente() -> some View {
        
        if self.ingredienteArchiviato.intestazione == "" {
            // crea un Nuovo Oggetto
            Group {
                
                Button("Salva e Crea Nuovo", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente)
                self.nuovoIngrediente = IngredientModel()
                    
                }
                
                Button("Salva ed Esci", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente,destinationPath: destinationPath)
                }

            }
        }
        
        else if self.ingredienteArchiviato.intestazione == self.nuovoIngrediente.intestazione {
            // modifica l'oggetto corrente
            
            Group { vbEditingSaveButton() }
        }
        
        else {
            
            Group {
                
                vbEditingSaveButton()
                
                Button("Salva come Nuovo Ingrediente", role: .none) {
                    
                self.viewModel.createItemModel(itemModel: self.nuovoIngrediente,destinationPath: destinationPath)
                }
            }
        }
    }
    
    @ViewBuilder private func vbEditingSaveButton() -> some View {
        
        Button("Salva Modifiche e Crea Nuovo", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoIngrediente)
        self.nuovoIngrediente = IngredientModel()
        }
        
        Button("Salva Modifiche ed Esci", role: .none) {
            
        self.viewModel.updateItemModel(itemModel: self.nuovoIngrediente, destinationPath: destinationPath)
        }
        
        
    } */
 
    
}

/*
struct NuovoIngredienteView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            Color.cyan.ignoresSafeArea()
            
            VStack {
                
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                Text("PROVA PROVA PROVA PROVA PROVA PROVA")
                
                
                
                
            }
            
            
            NuovoIngredienteMainView(backgroundColorView: Color.cyan)
              // .cornerRadius(20.0)
                //.padding(.vertical)
                
        }
     
    }
}
*/

















