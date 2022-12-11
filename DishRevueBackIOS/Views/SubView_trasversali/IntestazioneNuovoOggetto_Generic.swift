//
//  IntestazioneNuovoOggetto.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/03/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct IntestazioneNuovoOggetto_Generic<T:MyProToolPack_L0> : View where T.VM == AccounterVM {
    // 15.09 passa da T:MyModelStatusConformity a T:MyProStarterPack_L2

    @EnvironmentObject var viewModel: AccounterVM
    
    @Binding var itemModel: T
    let generalErrorCheck: Bool
    let minLenght: Int
    let coloreContainer: Color
    
    let placeHolderItemName: String
    let imageLabel: String
    var imageColor: Color? = nil
    
    @State private var nuovaStringa: String = ""
    @State private var editNuovaStringa: Bool = false
    
    init(itemModel:Binding<T>,generalErrorCheck:Bool, minLenght:Int, coloreContainer: Color) {
        
        _itemModel = itemModel
        self.generalErrorCheck = generalErrorCheck
        self.minLenght = minLenght
        self.coloreContainer = coloreContainer
        
        let wrappedModel = itemModel.wrappedValue
        
        self.placeHolderItemName = wrappedModel.modelStatusDescription()
        self.imageLabel = wrappedModel.status.imageAssociated()
        self.imageColor = wrappedModel.status.transitionStateColor()
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            CSLabel_1Button(placeHolder: placeHolderItemName, imageNameOrEmojy: imageLabel,imageColor: imageColor, backgroundColor: Color.black)
        
            if self.itemModel.intestazione == "" || self.editNuovaStringa {
    
                CSTextField_3b(
                    textFieldItem: self.$nuovaStringa,
                    placeHolder: self.itemModel.intestazione == "" ? "Nuovo Nome" : "Cambia Nome",
                    visualConten: {
                       csVisualCheck(
                        testo: self.nuovaStringa,
                        staticImage: "square.and.pencil",
                        editingImage: "rectangle.and.pencil.and.ellipsis",
                        imageScale: .large,
                        conformeA: .stringa(minLenght: minLenght))
                    },
                    action: { checkAndSubmit() }
                )
                .csWarningModifier(isPresented: generalErrorCheck) {
                    return self.itemModel.intestazione == ""
                  //  return !csCheckStringa(testo: self.nuovaStringa,minLenght: minLenght)
                }
        
            }
            
            if self.itemModel.intestazione != "" {
                
                if !editNuovaStringa {
                    
                        CSText_tightRectangle(testo: self.itemModel.intestazione, fontWeight: .bold, textColor: Color.white, strokeColor: Color.blue, fillColor: coloreContainer)
                            .onLongPressGesture {
                                self.editNuovaStringa = true
                            }

                } else {
                        
                        CSText_RotatingRectangleDynamicDeletingFace(testo: self.itemModel.intestazione, fontWeight: .bold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.blue, fillColor: coloreContainer.opacity(0.4), showDeleteImage: false)
                            .onTapGesture {
                                self.editNuovaStringa = false
                            }
                    }
                
                Text(editNuovaStringa ? "Click per annullare" : "Premi a lungo per modificare")
                    .font(.caption)
                    .fontWeight(.light)
                    .italic()
                
                }

        }
    }
    
    private func checkAndSubmit() {
        
        let newText = csStringCleaner(string: self.nuovaStringa)
        
        // 1° Check
        guard csCheckStringa(testo: newText, minLenght: minLenght) else {
            
            self.viewModel.alertItem = AlertModel(title: "Errore", message: "Il nome non raggiunge la lunghezza minima di \(minLenght) caratteri.")
            
            return }
        
        // 2° Check Unicità del nome
        
        let temporaryModel = {
           
            var temporary = self.itemModel
            temporary.intestazione = newText
            return temporary
        }()
        
        let nomeOggetto = self.itemModel.basicModelInfoInstanceAccess().nomeOggetto
        let isAlreadyIN = self.viewModel.checkExistingUniqueModelName(model: temporaryModel).0
         
        guard !isAlreadyIN else {
            
            self.viewModel.alertItem = AlertModel(title: "Errore", message: "Esiste già un \(nomeOggetto) con questo nome.")
            
            return }

        self.itemModel.intestazione = newText
    //    self.itemModel.status = .bozza // vedi Nota Consegna 17.07
        self.nuovaStringa = ""
        self.editNuovaStringa = false
        
    }
}

/*struct IntestazioneNuovoOggetto_Previews: PreviewProvider {
    static var previews: some View {
        IntestazioneNuovoOggetto_Generic()
    }
} */
