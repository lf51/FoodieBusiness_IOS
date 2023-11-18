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
    @State private var allFastCategories:[CategoriaMenu]?
    @State private var allAlreadyExisting:[CategoriaMenu]?
    @State private var readyToSave:[CategoriaMenu]?
    @State private var isUpdateDisable: Bool = true
    
    var body: some View {
        
        CSZStackVB(title: "[+] Multi Categorie", backgroundColorView: backgroundColorView) {
            VStack(alignment:.leading) {
                
              //  CSDivider()
                
             //   ScrollView(showsIndicators:false) {
                    
                    VStack(alignment:.leading) {
                        
                        TextEditor(text: $text)
                            .font(.system(.body,design:.rounded))
                            .foregroundStyle(Color.black)
                            .autocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .csTextEditorBackground {
                                // non funziona
                                Color.white.opacity(0.2)
                            }
                            .cornerRadius(5.0)
                            .frame(height: 100)
                            .onChange(of: text) {
                             self.isUpdateDisable = false
                            }
                        
                        HStack {
                            
                            CSButton_tight(
                                title: "Estrai",
                                fontWeight: .semibold,
                                titleColor: Color.seaTurtle_4,
                                fillColor: Color.seaTurtle_2) {
                               
                                self.estrapolaStringhe()
                                self.postEstrapolaAction()
                             
                            }
                            .opacity(self.isUpdateDisable ? 0.3 : 1.0)
                            .disabled(self.isUpdateDisable)

                            CSInfoAlertView(imageScale: .large, title: "Guida Formato", message: .formattazioneInserimentoVeloceCategorie)
                            
                            Spacer()

                            Text("Complete:\(readyToSave?.count ?? 0)(\(allAlreadyExisting?.count ?? 0))/\(allFastCategories?.count ?? 0)")
                                .font(.system(.subheadline, design: .monospaced))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.white.opacity(0.6))
                            
                            let disableSave:Bool = {
                                guard let readyToSave,
                                let allFastCategories else {
                                    return true
                                }
                                return (readyToSave.count + (allAlreadyExisting?.count ?? 0)) != allFastCategories.count
                            }()
                            
                            CSButton_tight(
                                title: "Salva",
                                fontWeight: .semibold,
                                titleColor: .seaTurtle_4,
                                fillColor: .seaTurtle_2) {

                                        self.updateListIndex()
                                        self.saveCategories()
                                    
                            }
                                .opacity(disableSave ? 0.6 : 1.0)
                                .disabled(disableSave)
                            
                        }
                        
                        if let allFastCategories {
                            
                            // create new binding using unwrapped value
                           // let allFast = Binding { allFastCategories } set: {self.allFastCategories = $0 }
                            
                            CorpoCompilazioneCategorie(
                                allFastCategories: allFastCategories,
                                allAlreadyExisting: $allAlreadyExisting,
                                readyToSave: $readyToSave)
                                .id(allFastCategories)
                                
            
                        }
                        
                        Spacer()
                    }
              //  }
                
              //  CSDivider()
            }
            .csHpadding()
        }
    }
    
    // Method

    private func updateListIndex() {
        
        guard let readyToSave else { return }
        
        let remoteCacheCount = self.viewModel.db.allMyCategories.count
       
        var rigeneratedCategories:[CategoriaMenu] = []
        
         for (index,item) in readyToSave.enumerated() {
            
            var rigenerata = item
            rigenerata.listIndex = remoteCacheCount + index
            rigeneratedCategories.append(rigenerata)
            
        }
        
        self.readyToSave = rigeneratedCategories
        
    }
    
    private func saveCategories() {
        
        // salviamo le readyItems
        guard let readyToSave else { return }
        
        Task {
            try await self.viewModel.updateCategoriesListFromLocalCache(news: readyToSave, edited: [], removedId: [])
        }
        
        self.readyToSave = nil
        self.allFastCategories = nil
        self.allAlreadyExisting = nil
        self.isUpdateDisable = true
        self.text = ""
    }
    
    private func estrapolaStringhe() {
        
        var allNewCategories:[CategoriaMenu] = []
        
        let containerZero = self.text.split(separator: ",")
        
        let containerOne = containerZero.map({$0.lowercased()})
        let containerTwo = Set(containerOne)// elimina stringhe duplicate
        let containerThree = Array(containerTwo)
        
        for category in containerThree {
            
            let new:CategoriaMenu = {
                
                let title = String(category).lowercased()
                let cleanTitle = csStringCleaner(string: title)
                
                var local = CategoriaMenu()
                local.intestazione = cleanTitle
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
        
    }
    
}

struct CorpoCompilazioneCategorie:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let allFastCategories:[CategoriaMenu]
    
    @Binding var allAlreadyExisting:[CategoriaMenu]?
    @Binding var readyToSave:[CategoriaMenu]?
    
    @State private var focusCategory:CategoriaMenu?
        
    var body: some View {
        
        VStack {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing:15) {
                    
                    ForEach(csReturnEmojyCollection(),id:\.self) { emoji in
                        
                        Text(emoji)
                            .font(.title)
                            .onTapGesture {
                                   //self.focusCategory?.image = emojy
                                self.addEmoji(emoji: emoji)
                            }
                    }
                }
                
            }
            .padding(.vertical,5)
            .scrollDismissesKeyboard(.immediately)
            
            VStack {
                
                ScrollView(showsIndicators: false) {
                    
                    ForEach(allFastCategories) { category in
                        
                        let focusCheck:Bool = self.focusCategory?.id == category.id
                        let alreadyExist = self.viewModel.isTheModelAlreadyExist(modelID: category.id, path: \.db.allMyCategories)
                        
                        let currentValue:CategoriaMenu = {
                            
                            guard !alreadyExist else { return category }
                            
                            if focusCheck,
                            let focusCategory { return focusCategory }
                            
                            if let isReady = self.readyToSave?.first(where: {$0.id == category.id}) { return isReady }
                            
                            else { return category }
                            
                        }()

                        VStack(alignment:.leading) {
                            
                            HStack {
                                
                                HStack(spacing:10) {
                                    Text(currentValue.image)
                                        .font(.largeTitle)
                                        .opacity(alreadyExist ? 0.3 : 1.0)
                                    
                                    Text(currentValue.intestazione.capitalized)
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.seaTurtle_4)
                                        .opacity(alreadyExist ? 0.3 : 1.0)
                                        
                                }
                                .overlay(alignment: .bottomTrailing) {
                                    Text(currentValue.productType.rawValue)
                                        .foregroundStyle(Color.seaTurtle_1)
                                        .font(.caption)
                                        .italic()
                                        .bold()
                                        .offset(x: 20, y: 5)
                                }
                                
                                Spacer()
                                
                                if focusCheck {
                                     
                                    Menu {
                                        
                                        ForEach(ProductType.allCases,id:\.self) { type in
                                            
                                            Button {
                                                addType(type: type)
                                                
                                            } label: {
                                                HStack {
                                                    
                                                    if type != .noValue {
                                                        
                                                        Image(systemName: type.imageAssociated().system)
                                                    }
                                                    Text(type.rawValue)
                                                }
                                                .foregroundStyle(Color.black)
                                            }

                                        }

                                    } label: {
                                        
                                        HStack {
                                            
                                            Text(currentValue.productType.rawValue)
                                                .font(.headline)
                                                .bold()
                                                
                                            Image(systemName: "chevron.up.chevron.down")
                                            
                                        }
                                        .foregroundStyle(Color.seaTurtle_4)
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
                                //self.focusCategory = currentValue
                                tapAction(currentValue: currentValue)
                            }
                        }
                        .disabled(alreadyExist)
                    }
                }
            }

          //  CSDivider()
        }
        .onAppear {
            
            self.allAlreadyExisting = self.allFastCategories.compactMap({
                if self.viewModel.isTheModelAlreadyExist(modelID: $0.id, path: \.db.allMyCategories) {
                    // usiamo l'id perchè in estrapolazione viene già sostituito in base al nome
                    return $0
                } else { return nil }
            })
            
            if let newFocus = self.allFastCategories.first(where: {!self.viewModel.isTheModelAlreadyExist(modelID: $0.id, path: \.db.allMyCategories)}) {
                self.focusCategory = newFocus
            }
        }
 
    }
    
    // Method
    private func tapAction(currentValue:CategoriaMenu) {
        
        guard let focusCategory else { 
              self.focusCategory = currentValue
            return }
        
        if focusCategory.id == currentValue.id { return }
        else { self.focusCategory = currentValue }

    }
    
    private func addEmoji(emoji:String) {
        
        guard var currentFocus = focusCategory else { return }
        
        currentFocus.image = emoji
        withAnimation {
            self.focusCategory = currentFocus
        }
        manageFocus()
        
        
    }
    
    private func addType(type:ProductType) {
        
        guard var currentFocus = focusCategory else { return }
        
        currentFocus.productType = type
        withAnimation {
            self.focusCategory = currentFocus
        }
        manageFocus()
        
    }
    
    private func manageFocus() {

        guard let focusCategory else { return }
        
        let emoji = focusCategory.image
        let type = focusCategory.productType
        
        guard emoji != "#",
              type != .noValue else { return }
        
        var readyItem = readyToSave ?? []
        
        if let isEditedIndex = readyItem.firstIndex(where: {$0.id == focusCategory.id}) {
            
            readyItem[isEditedIndex] = focusCategory
            
        } else {
            
            readyItem.append(focusCategory)
            
        }

          let newFocus = self.allFastCategories.first { categoria in
              
              !readyItem.contains(where: {$0.id == categoria.id}) &&
              !(self.allAlreadyExisting?.contains(where: {$0.id == categoria.id}) ?? false)
              
          }

          withAnimation {
              self.readyToSave = readyItem
              self.focusCategory = newFocus
          }
        
    }
    
}




struct FastImport_Categorie_Previews: PreviewProvider {
    static var user:UserRoleModel = UserRoleModel()
    static var previews: some View {
        NavigationStack {
            FastImport_Categorie(backgroundColorView: .seaTurtle_1)
                .environmentObject(AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID")))//(AccounterVM(userAuth: user))
        }
    }
}

