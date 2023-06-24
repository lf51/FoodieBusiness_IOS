//
//  FastImport_Categorie.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 17/06/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct FastImport_Categorie: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    let backgroundColorView: Color
    
    @State private var text: String = ""
    @State private var allFastCategories:[CategoriaMenu] = []
    @State private var isUpdateDisable: Bool = true
    @Binding var disabilitaPicker:Bool
    
    var body: some View {
        
       // VStack {
            
           // CSDivider()
            
            ScrollView(showsIndicators:false) {
                
                VStack(alignment:.leading) {
                    
                    TextEditor(text: $text)
                        .font(.system(.body,design:.rounded))
                        .foregroundColor(Color.black)
                        .autocapitalization(.sentences)
                        .disableAutocorrection(true)
                        .keyboardType(.default)
                        .csTextEditorBackground {
                            Color.white.opacity(0.2)
                        }
                        .cornerRadius(5.0)
                        .frame(height: 150)
                        .onChange(of: text) { _ in
                         self.isUpdateDisable = false
                        }
                    
                    HStack {
                        
                        CSButton_tight(title: "Estrai", fontWeight: .semibold, titleColor: Color.seaTurtle_4, fillColor: Color.seaTurtle_2) {
                           
                            self.estrapolaStringhe()
                            self.postEstrapolaAction()
                         
                        }
                        .opacity(self.isUpdateDisable ? 0.3 : 1.0)
                        .disabled(self.isUpdateDisable)

                        CSInfoAlertView(imageScale: .large, title: "Guida Formato", message: .formattazioneInserimentoVeloceCategorie)
                        
                        Spacer()

                        Text("N°Categorie:\(allFastCategories.count)")
                            .font(.system(.subheadline, design: .monospaced))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white.opacity(0.6))
                        
                    }
                    
                    if !allFastCategories.isEmpty {
                        
                        CorpoCompilazioneCategorie(allFastCategories: $allFastCategories, disabilitaPicker: $disabilitaPicker)
                            .id(allFastCategories)
                            
        
                    }
                }
            }
            
       // }
        .csHpadding()
    }
    
    // Method
    
    private func estrapolaStringhe() {
        
        var allNewCategories:[CategoriaMenu] = []
        
        let containerZero = self.text.split(separator: ",")
        
        for category in containerZero {
            
            let new:CategoriaMenu = {
                
                let title = String(category).lowercased()
                let cleanTitle = csStringCleaner(string: title)
                
                var local = CategoriaMenu()
                local.intestazione = cleanTitle.capitalized
                return local
                
            }()

            if let alreadyExist = viewModel.checkExistingUniqueModelName(model: new).1 {
                
                allNewCategories.append(alreadyExist)
            } else {
                allNewCategories.append(new)
            }
            
        }
        
        self.allFastCategories = allNewCategories
        
        
    }
    
    private func postEstrapolaAction() {
        
        csHideKeyboard()
        self.isUpdateDisable = true
       /* viewModel.alertItem = AlertModel(
            title: "⚠️ Attenzione",
            message: SystemMessage.allergeni.simpleDescription()) */
        
    }
    
}

struct CorpoCompilazioneCategorie:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @Binding var allFastCategories:[CategoriaMenu]
    @State private var focusCategory:CategoriaMenu = CategoriaMenu()
    @Binding var disabilitaPicker:Bool
        
    var body: some View {
        
        VStack {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing:15) {
                    
                    ForEach(csReturnEmojyCollection(),id:\.self) { emojy in
                        
                        Text(emojy)
                            .font(.title)
                            .onTapGesture {
                                    self.focusCategory.image = emojy
                            }
                    }
                }
                
            }
            .padding(.vertical,5)
            .scrollDismissesKeyboard(.immediately)
            
            ForEach(allFastCategories) { category in
                
                let focusCheck:Bool = self.focusCategory.id == category.id
                let alreadyExist = self.viewModel.isTheModelAlreadyExist(modelID: category.id, path: \.allMyCategories)
                
                VStack(alignment:.leading) {
                    
                    HStack(spacing:10) {
                        
                        Text(focusCheck ? focusCategory.image : category.image)
                            .font(.largeTitle)
                            .opacity(alreadyExist ? 0.3 : 1.0)
                        Text(category.intestazione)
                            .font(.largeTitle)
                            .foregroundColor(.seaTurtle_4)
                            .opacity(alreadyExist ? 0.3 : 1.0)
                        Spacer()
                        
                        if focusCheck {
                            
                            CSButton_image(
                                frontImage: "square.and.arrow.down",
                                imageScale: .large,
                                frontColor: .seaTurtle_4
                                ) {
                                   addNewCategory()
                                }
                        }
                            
                    }
                }
                .padding(.vertical,10)
                .csHpadding()
                .background {
                    Color.seaTurtle_3
                        .cornerRadius(5.0)
                        .opacity(focusCheck ? 0.6 : 0.1)
                }
                .onTapGesture {
                    withAnimation{
                        self.focusCategory = category
                    }
                }
                .disabled(alreadyExist)
            }
            
          //  CSDivider()
        }
        .onAppear {
            
            if let newFocus = self.allFastCategories.first(where: {!self.viewModel.isTheModelAlreadyExist(modelID: $0.id, path: \.allMyCategories)}) {
                self.focusCategory = newFocus
            }
        }
 
    }
    
    // Method
    
    private func addNewCategory() {
        
        self.viewModel.createItemModel(itemModel: self.focusCategory)
        self.allFastCategories.removeAll(where: {$0.id == self.focusCategory.id})
        self.allFastCategories.append(self.focusCategory)//perchè modifichiamo la state focus e dunque va rimossa quella nell'array allfast e va sostituita con quella nel focus che ha la nuova immagine
        
        if let newFocus = self.allFastCategories.first(where: {!self.viewModel.isTheModelAlreadyExist(modelID: $0.id, path: \.allMyCategories)}) {
            self.focusCategory = newFocus
        } else {
            self.focusCategory = CategoriaMenu()
            self.disabilitaPicker = false
        }
       
        
    }
    
}




struct FastImport_Categorie_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FastImport_Categorie(backgroundColorView: .seaTurtle_1, disabilitaPicker: .constant(true))
                .environmentObject(AccounterVM())
        }
    }
}

