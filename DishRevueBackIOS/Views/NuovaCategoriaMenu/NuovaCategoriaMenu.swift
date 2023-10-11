//
//  NuovaCategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/06/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

enum SwitchCategoryEditCase {
    case creaNuova
    case modificaEsistente(_ :CategoriaMenu)
    
    var labelPlaceHolder:String {
        
        switch self {
        case .creaNuova:
            return "Nuova Categoria"
        case .modificaEsistente(let categoria):
            return categoria.intestazione.capitalized
        }
    }
    
    var labelImage:String {
        
        switch self {
        case .creaNuova:
            return "🍽️"
        case .modificaEsistente(let categoria):
            return categoria.image
        }
    }
    
    var labelAction:String {
        
        switch self {
        case .creaNuova:
            return "Chiudi"
        case .modificaEsistente:
            return "Esci"
        }
    }
    
    var disable:Bool {
        switch self {
        case .creaNuova:
            return false
        case .modificaEsistente:
            return true
        }
    }
    
    var addButton:String {
        
        switch self {
        case .creaNuova:
            return "Add New"
        case .modificaEsistente:
            return "Submit Change"
        }
        
    }
}




struct NuovaCategoriaMenu: View {
    
    @EnvironmentObject var viewModel: AccounterVM
   // @Environment(\.editMode) var editMode // deprecata
    let backgroundColorView:Color

    @State private var nuovaCategoria: CategoriaMenu?
    @State private var categoriaArchiviata: CategoriaMenu? // valutare utilità
    
    @State private var editCase:SwitchCategoryEditCase?
    @State private var localCache:[CategoriaMenu]?
        
    init(backgroundColorView: Color) {

        self.backgroundColorView = backgroundColorView
        UICollectionView.appearance().backgroundColor = .clear // Toglie lo sfondo alla list
        print("[INIT]_NuovaCategoriaMenu")
    }
    
    var body: some View {
        
        CSZStackVB(
            title: "Categorie dei Menu",
            backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading,spacing: .vStackBoxSpacing) {

              //  let isEditing = self.editMode?.wrappedValue.isEditing ?? false
                let isEditing = self.localCache != nil
                let modifiche = contaModifiche()
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                        
                    CSLabel_conVB(
                        placeHolder: editCase?.labelPlaceHolder ?? "Nuova Categoria",
                        imageNameOrEmojy: editCase?.labelImage ?? "🍽️",
                        backgroundColor: Color.seaTurtle_3) {
                            
                            HStack(spacing:20) {
                                
                                Button(editCase?.labelAction ?? "Crea" ) {
                                    
                                    withAnimation {
                                        self.labelAction()
                                    }
                                }
                                .disabled(!isEditing)
 
                                vbMenuImport()
                                    .opacity(isEditing ? 0.6 : 1.0)
                                    .disabled(isEditing)
                            }
                            
                            
                        }
                    
                    if let nuovaCategoria,
                    let categoriaArchiviata {
                        // create new binding using unwrapped value
                        let categoria = Binding { nuovaCategoria } set: {self.nuovaCategoria = $0 }
                        
                        CorpoNuovaCategoria(
                            nuovaCategoria: categoria,
                            editCase: $editCase,
                            categoriaArchiviata: categoriaArchiviata) {
                               
                                withAnimation {
                                    self.aggiungiButton()
                                }
                                
                            }

                    }
                }
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                    
                    let count = localCache?.count ?? self.viewModel.db.allMyCategories.count
                    
                    CSLabel_conVB(
                        placeHolder: "Elenco Categorie (\(count)):",
                        imageNameOrEmojy: "list.bullet.circle",
                        backgroundColor: Color.seaTurtle_3) {
                           
                           HStack {
                               
                               CSInfoAlertView(
                                imageScale: .large,
                                title: "Elenco Categorie",
                                message: .elencoCategorieMenu)

                               Spacer()
                               
                               let image:(name:String,color:Color) = {
                                  
                                   if let modifiche {
                                       
                                       return ("icloud.slash",Color.yellow)
                                       
                                   } else {
                                       return ("checkmark.icloud.fill",Color.seaTurtle_3)
                                   }
                                   
                               }()
                               
                               Image(systemName:image.name )
                                   .imageScale(.large)
                                   .foregroundStyle(image.color)
                                   .opacity(0.8)
                                   .csHpadding()

                               
                               
                             //  EditButton()
                               //    .csHpadding()
  
                            }
                        }

                     if let modifiche {
                        
                         let areNews = modifiche.nuovi > 0
                         let areEdited = modifiche.edited > 0
                         let areTrash = modifiche.removed > 0
                         
                        HStack {
                            
                            VStack(alignment:.leading) {
                                
                                HStack {
                                    
                                    Text("\(Image(systemName: "doc.badge.plus")): \(modifiche.nuovi)")
                                        .bold(areNews)
                                        .foregroundStyle(areNews ? Color.green : Color.gray)
                                    
                                    Divider()
                                        .bold()
                                        .fixedSize()
                                    
                                    Text("\(Image(systemName: "pencil")): \(modifiche.edited)")
                                        .bold(areEdited)
                                        .foregroundStyle(areEdited ? Color.yellow : Color.gray)
                                    
                                    Divider()
                                        .bold()
                                        .fixedSize()
                                    
                                    Text("\(Image(systemName: "trash")): \(modifiche.removed)")
                                        .bold(areTrash)
                                        .foregroundStyle(areTrash ? Color.seaTurtle_4 : Color.gray)
                                }
                                
                                Text("modifiche non salvate")
                                    .italic()
                                    .font(.caption)
                                    .foregroundStyle(Color.black)
                                    .opacity(0.75)
                            }
                            
                            Spacer()

                            Button {
                                saveOnCloud()
                            } label: {
                                Text("Salva Ora")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(Color.seaTurtle_3)
                            }

                            
                        }
                        .padding(.vertical,15)
                        .csHpadding()
                        .background { Color.yellow.opacity(0.15) }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                    }
                    
                        List {
                            
                            ForEach(localCache ?? self.viewModel.db.allMyCategories) { categoria in
                                   
                                    let dishCount = categoria.dishPerCategory(viewModel: viewModel).count
 
                                HStack(spacing:0) {
                                    
                                    Text("#\(categoria.listIndex ?? 999)")
                                        .padding(5)
                                        .background{Color.seaTurtle_4.opacity(0.6)}
                                        .clipShape(Circle())
                                        .offset(x:-10)
                                    
                                    VStack(alignment:.leading,spacing: 5) {
                                        
                                        HStack {
                            
                                            csVbSwitchImageText(string: categoria.image)
                                                .font(.body)
                                            
                                            Text(categoria.intestazione)
                                                .fontWeight(.semibold)
                                                .font(.system(.body, design: .rounded))
                                                .foregroundStyle(Color.seaTurtle_4)
                                            
                                        // temporaneo
                                            let isNew = self.viewModel.remoteStorage.modelRif_newOne.contains( categoria.id)
                                            let isEdited = self.viewModel.remoteStorage.modelRif_modified.contains(categoria.id)
                                            Text(isNew ? "New" : isEdited ? "Mod" : "Old")
                                            
                                            if isEditing {
                                                
                                                Button {
                                                    
                                                    withAnimation {
                                                        self.pencilButton(categoria: categoria)
                                                    }
                                                    
                                                } label: {
                                                    Image(systemName: "pencil")
                                                        .foregroundStyle(Color.seaTurtle_3)
                                                }

                                            }
                                            
                                            Spacer()

                                            Text("\(dishCount) 🍽️")
                                                    .foregroundStyle(Color.seaTurtle_4)

                                        }
 
                                        let description:String = {
                                            
                                            if let descrizione = categoria.descrizione,
                                               descrizione != "" {
                                                return descrizione
                                            } else {
                                                return "No description yet"
                                            }

                                        }()
                                        
                                        Text(description)
                                            .font(.callout)
                                            .italic()
                                            .foregroundStyle(Color.black)
                                            .opacity(0.6)
                                    }
                                }
                                
                                }
                            .onDelete(perform: onDeleteAction())
                            .onMove(perform: onMoveAction())
                            .listRowBackground(backgroundColorView)
                          
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .scrollDismissesKeyboard(.immediately)
                        .listStyle(.plain)
                       // .id(editMode?.wrappedValue)
                        .id(localCache)
 
                }

               Spacer()
            
            }
            .csHpadding()
           // .padding(.horizontal)
        }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    let(action,description) = editLogic()
                    
                    Button {
                        
                      action()
                        
                    } label: {
                        Text(description)
                    }

                }
            }
  
    }
    // Method
    
    private func editLogic() -> (action:() -> Void,description:String ) {
        // Edit Reset Chiudi
        print("[CALL]_editLogic()")
        let cloudCache = self.viewModel.db.allMyCategories
        let cache = localCache
        
        var description:String
        var action:() -> Void
        
        switch cache {
            
        case nil:
            action = editAction
            description = "Edit"
            
        case cloudCache: // non ci sono state modifiche
           action = resetAction
           description = "Cancel"
            
        default: // ci sono state modifiche
           action = resetAction
           description = "Reset"
        }
        
        return(action,description)
    }
    
    private func editAction() -> Void {
        self.localCache = self.viewModel.db.allMyCategories
    }
    
    private func resetAction() -> Void {
        self.nuovaCategoria = nil
        self.categoriaArchiviata = nil
        self.localCache = nil
    }
    
    private func contaModifiche() -> (nuovi:Int,edited:Int,removed:Int)? {
 
        let cloudCache = self.viewModel.db.allMyCategories
        
        guard let localCache,
        localCache != cloudCache else {
            return withAnimation {
                nil
            }
        }
        
        var nuovi:Int = 0
        var edited:Int = 0
      
        let cloudCacheID = cloudCache.map({$0.id})
        let localCacheID = localCache.map({$0.id})
        
        for categoria in localCache {
            
            if !cloudCacheID.contains(categoria.id) {
                // nuovi
                nuovi += 1
                
            } else if !cloudCache.contains(categoria) {
                // modificati
                edited += 1
            } // else { elemento non ha modifiche}
        }
 
       let removed = cloudCacheID.compactMap({
            if !localCacheID.contains($0) { return $0 }
            else { return nil }
        }).count
        
      return withAnimation {
            (nuovi,edited,removed)
        }
        
    }
    
    private func creaNuovaCategoria() {

            let newCategoria = CategoriaMenu()
            self.nuovaCategoria = newCategoria
            self.categoriaArchiviata = newCategoria
        
            self.editCase = .creaNuova
    }
    
    private func resetCreaNuovaCategoria() {
        self.nuovaCategoria = nil
        self.categoriaArchiviata = nil
        self.editCase = nil
    }

    private func labelAction() {
        
        let isNewCategoryNil:Bool = {
            self.nuovaCategoria == nil ||
            self.categoriaArchiviata == nil
        }()

        switch self.editCase {

        case .modificaEsistente:
          creaNuovaCategoria()
            
        default:
            if isNewCategoryNil {
                creaNuovaCategoria()
            } else {
                resetCreaNuovaCategoria()
            }

        }
    }
    
    private func pencilButton(categoria:CategoriaMenu) {
        
        self.nuovaCategoria = categoria
        self.categoriaArchiviata = categoria
        
        self.editCase = .modificaEsistente(categoria)

    }
    
    private func aggiungiButton() {
           
        csHideKeyboard()
        
        guard var localCache,
            var nuovaCategoria else { return }
                
        if localCache.contains(where: {$0.id == nuovaCategoria.id}) {
            
            // trattasi di una modifica
           let index = nuovaCategoria.listIndex ?? localCache.count
            print("[OLD]_\(localCache[index].intestazione)_new:\(nuovaCategoria.intestazione)")
           localCache[index] = nuovaCategoria
            
        } else {
            // trattasi di nuova Categoria
            let name = csStringCleaner(string: nuovaCategoria.intestazione.lowercased())
          
            let lastIndex = localCache.count // partendo da zero il numero di elementi rappresenta la prox posizione d'indice
            
            nuovaCategoria.intestazione = name
            nuovaCategoria.listIndex = lastIndex
            
            localCache.append(nuovaCategoria)
            
        }

        self.creaNuovaCategoria()
        self.localCache = localCache

       }
    
    private func removeAction(index:IndexSet) {
        
      //  guard let localCache else { return }
        
        var updatedCache:[CategoriaMenu] = self.localCache!
        updatedCache.remove(atOffsets: index)
        
        // ricaviamo l'elemento eliminato
        let eliminated = localCache!.first(where: {!updatedCache.contains($0)})
        
        guard let eliminated,
              eliminated.dishPerCategory(viewModel: self.viewModel).count == 0 else {
            
            // la categoria non può essere rimossa
            self.viewModel.alertItem = AlertModel(
                title: "Errore",
                message: "La categoria è in uso e quindi non può essere rimossa.")
            return
        }
        
        // la categoria non contiene piatti e può essere rimossa

        updateOrderIndexSet(of: &updatedCache)
        self.localCache = updatedCache
        
    }
    
    private func onDeleteAction() -> Optional<(IndexSet) -> Void> {

      //  guard self.editMode?.wrappedValue.isEditing else { return nil }
       /* guard let editMode = editMode?.wrappedValue,
              editMode.isEditing else { return nil } */
      
        guard self.localCache != nil else { return nil }
        
        return removeAction
   
     }

    private func updateOrderIndexSet(of cache:inout [CategoriaMenu]) {
        
        for (index,var element) in cache.enumerated() {
            // aggiorniamo il list index di ogni elemento
            element.listIndex = index
            cache[index] = element
        }
    }
    
    private func makeOrderAction(from:IndexSet, to:Int) {

       //muoviamo gli elementi in una cache speculare alla localchange
        var updatedCache:[CategoriaMenu] = self.localCache!
        updatedCache.move(fromOffsets: from, toOffset: to)

        updateOrderIndexSet(of: &updatedCache)
        // mandiamo l'update della localcache
        self.localCache = updatedCache
        
    }
    
    private func onMoveAction() -> Optional<(IndexSet, Int) -> Void> {
        
       /* guard let editMode = editMode?.wrappedValue,
              editMode.isEditing else { return nil }*/
        guard self.localCache != nil else { return nil }
        return makeOrderAction
    }
    
    private func saveOnCloud() {
        /*
         1. Nuova Categoria
         -> Check se esistente nella library
         -> Se NON esistente salva su:
         • Categories Library
         • SubCollection
         
         -> se esistente:
         Recupera ID e salva in:
         • SubCollection
         
         2. Modifica Categoria
         List Index e/o Descrizione
         • Salva in SubCollection
         
         3. Rimuovi Categoria
         • Elimina dalla subCollection
         
         */
        guard let localCache else { return }
        
    //    self.viewModel.isLoading = true
        
        let cloudCache:[CategoriaMenu] = self.viewModel.db.allMyCategories
        let cloudIDCache:[String] = cloudCache.map({$0.id})
        
        let localCacheID:[String] = localCache.map({$0.id})
        
        var allNews:[CategoriaMenu] = [] // i nuovi per la proprietà
        var allEdited:[CategoriaMenu] = []
      
        for element in localCache {
            
            if !cloudIDCache.contains(element.id) {
                // Nuova Categoria
                allNews.append(element)
            }
            else if !cloudCache.contains(element) {
                // modificato
                allEdited.append(element)
            } // else { elemento eisteva e non è stato modificato }
            
        }
        
        let removed:[String] = cloudIDCache.compactMap {
            if !localCacheID.contains($0) { return $0}
            else { return nil }
        }
        
        Task {
            
            if !allNews.isEmpty {
                // verificare se sono nuovi in assoluto o se presenti nella libreria
                print("[SAVE_CATEGORIES]_allNEWS_count:\(allNews.count)")
                try await self.viewModel.saveNewAfterCheckLibrary(news: allNews)
            }
            
            if !allEdited.isEmpty {
                // salviamo i modificati nella sub
                print("[SAVE_CATEGORIES]_allEDITED_count:\(allEdited.count)")
                try await self.viewModel.saveCategoriesMenu(localCache: allEdited)
            }
            
            if !removed.isEmpty {
                // rimuoviamo dalla sub
                print("[SAVE_CATEGORIES]_allREMOVED_count:\(removed.count)")
                try await self.viewModel.removeCategoriaMenu(localIDCache: removed)
            }

            self.localCache = nil
            self.nuovaCategoria = nil
            self.categoriaArchiviata = nil
          //  self.viewModel.isLoading = nil
        }
        
       // self.editMode?.wrappedValue = .inactive
       
    }


}

struct NuovaCategoriaMenu_Previews: PreviewProvider {
    static var user:UserRoleModel = UserRoleModel()
    static var previews: some View {
        
        NavigationStack {
            
            NuovaCategoriaMenu(backgroundColorView: Color.seaTurtle_1)
              //  .environmentObject(AccounterVM(userAuth:user))
                .environmentObject(AccounterVM(userManager: UserManager(userAuthUID: "TEST_USER_UID")))
        }
        
       
    }
}

/*
struct NuovaCategoriaMenu: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.editMode) var mode // deprecato
    let backgroundColorView:Color

    @State private var creaNuovaCategoria:Bool? = false
    @State private var nuovaCategoria: CategoriaMenu
    @State private var categoriaArchiviata: CategoriaMenu
    
    @State private var editCase:SwitchCategoryEditCase = .creaNuova(false)
    
    @State private var localCache:[CategoriaMenu]?
    
    @State private var itemToDelete:Set<String>? // deprecato?
    
    init(backgroundColorView: Color) {
       
        let categoriaVuota = CategoriaMenu()
        _nuovaCategoria = State(wrappedValue: categoriaVuota)
        _categoriaArchiviata = State(wrappedValue: categoriaVuota)
        
        self.backgroundColorView = backgroundColorView
        UICollectionView.appearance().backgroundColor = .clear // Toglie lo sfondo alla list
    }
    
    var body: some View {
        
        CSZStackVB(
            title: "Categorie dei Menu",
            backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading,spacing: .vStackBoxSpacing) {
                
                var cache:[CategoriaMenu] = {
                    
                    var container:[CategoriaMenu]
                    
                    if let localCache {
                        container = localCache
                    } else {
                        container = self.viewModel.db.allMyCategories
                    }
                    
                    return container.sorted(by: {$0.listIndex ?? 999 < $1.listIndex ?? 999 })
                }()
                
                let isEditing = localCache != nil
                let modifiche = contaModifiche()
              //  let isEditing = self.mode?.wrappedValue.isEditing ?? false
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                                        
                    CSLabel_conVB(
                        placeHolder: editCase.labelPlaceHolder,
                        imageNameOrEmojy: editCase.labelImage,
                        backgroundColor: Color.seaTurtle_3) {
                            
                            Button(editCase.labelAction ) {
                                
                                withAnimation {
                                   
                                    self.labelAction()
                                   
                                }
                                
                            }
                        }
                    
                    if creaNuovaCategoria! {
                        
                        CorpoNuovaCategoria(
                            nuovaCategoria: $nuovaCategoria,
                            editCase: $editCase,
                            categoriaArchiviata: categoriaArchiviata) {
                                Task {
                                    await self.aggiungiButton()
                                }
                            }

                    }
                }
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                    
                    CSLabel_conVB(
                        placeHolder: "Elenco Categorie (\(cache.count)):",
                        imageNameOrEmojy: "list.bullet.circle",
                        backgroundColor: Color.seaTurtle_3) {
                           
                           HStack {
                               
                               CSInfoAlertView(
                                imageScale: .large,
                                title: "Elenco Categorie",
                                message: .elencoCategorieMenu)
                               
                                Spacer()
                               
                               // temporaneo per Test
                               let color:Color = {
                                  
                                   if cache == localCache {
                                       return Color.green
                                   } else {
                                       return Color.yellow
                                   }
                               }()
                               
                               Image(systemName: "circle.fill")
                                   .imageScale(.small)
                                   .foregroundStyle(color)
                               
                               
                               //
                                CSButton_tight(
                                    title: isEditing ? "Annulla" : "Edit",
                                    fontWeight: isEditing ? .bold : .semibold,
                                    titleColor: isEditing ? Color.seaTurtle_4 : Color.seaTurtle_2,
                                    fillColor: Color.clear) {
                                        
                                        withAnimation {
                                          editAction()
                                        }
                                        
                                    }
                             //  EditButton()
    
                            }
                        }

                    if modifiche > 0 {
                        
                        HStack {
                            
                            Text("Categorie Modificate:")
                                .italic()
                                .foregroundStyle(Color.black)
                                .opacity(0.8)
                            
                            Text("\(modifiche)")
                                .foregroundStyle(Color.black)
                                .bold()
                            
                            Spacer()
                            
                            Button("Salva") {
                              saveOnCloud()
                            }
                           

                        }
                        
                    }
                    
                        List {
                            
                            ForEach(cache) { categoria in
                                   
                                    let dishCount = categoria.dishPerCategory(viewModel: viewModel).count
                                
                                
                                 //   let isInDeleting = self.itemToDelete?.contains(categoria.id) ?? false
                                    
                                    VStack(alignment:.leading,spacing: 5) {
                                        
                                        HStack {
                            
                                            csVbSwitchImageText(string: categoria.image)
                                                .font(.body)
                                            
                                            Text(categoria.intestazione)
                                                .fontWeight(.semibold)
                                                .font(.system(.body, design: .rounded))
                                                .foregroundStyle(Color.seaTurtle_4)
                                            Text("postion:\(categoria.listIndex ?? 999)")
                                            
                                            if !isEditing {
                                                Button {
                                                    
                                                  pencilButton(categoria: categoria)
                                                    
                                                } label: {
                                                    Image(systemName: "pencil")
                                                        .foregroundStyle(Color.seaTurtle_3)
                                                }

                                            }
                                            
                                            Spacer()
                                            Text("\(dishCount) 🍽️")
                                                .foregroundStyle(Color.seaTurtle_4)
                                            
                                        }
 
                                        let description:String = {
                                            
                                            if let descrizione = categoria.descrizione,
                                               descrizione != "" {
                                                return descrizione
                                            } else {
                                                return "No description yet"
                                            }

                                        }()
                                        
                                        Text(description)
                                            .font(.callout)
                                            .italic()
                                            .foregroundStyle(Color.black)
                                            .opacity(0.6)
                                    }
                                   // .opacity(isInDeleting ? 0.4 : 1.0)
                                   // .disabled(isInDeleting)
                                   
                                }
                            .onDelete(perform: onDeleteAction())
                            .onMove(perform: onMoveAction())
                            .listRowBackground(backgroundColorView)
                              
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .scrollDismissesKeyboard(.immediately)
                        .listStyle(.plain)
                        .id(localCache) // fa aggiornare la list in base all'editing status
                       
                        
                }
                    

               Spacer()
            
            }
            .csHpadding()
           // .padding(.horizontal)
        }

    }
    // Method

    private func contaModifiche() -> Int {
        
        var modifiche:Int = 0
        
        guard let localCache else {
            return modifiche
        }
        
        for categoria in self.viewModel.db.allMyCategories {
            
            if let categoriaIn = localCache.first(where: {$0 == categoria}) {
               // occorre controllare il listIndex
                if categoriaIn.listIndex != categoria.listIndex {
                    
                    modifiche += 1
                }
                
            } else {
                
                modifiche += 1
            }
        }
        
        return modifiche
        
    }
    
    private func editAction() {
        
        if self.localCache != nil {
            // Se attivo l'editing lo disattiviamo
            // riportiamo la localCache su Nil
            self.localCache = nil
            self.mode?.wrappedValue = .inactive
            
            
        } else {
            // se inattivo lo attiviamo
            // creiamo una localCache per le modifiche
            self.localCache = self.viewModel.db.allMyCategories
            self.mode?.wrappedValue = .active
            
        }
    }
    
    private func labelAction() {
        
        let toggle = self.creaNuovaCategoria ?? false
        
        switch self.editCase {

        case .modificaEsistente:
            self.nuovaCategoria = CategoriaMenu()
            self.editCase = .creaNuova(toggle)
            
        default:
            
            self.editCase = .creaNuova(!toggle)
            self.creaNuovaCategoria?.toggle()
        }
    }
        
    private func saveOnCloud() {
        
        guard let localCache else { return }
        
        var difference:[String] = self.viewModel.db.allMyCategories.compactMap({
            if !localCache.contains($0) {
                return $0.id
            } else {
                return nil
            }
        })
        
        Task {
            
            if !difference.isEmpty {
                try await self.viewModel
                    .removeCategoriaMenu(localIDCache: difference)
            }
            
           try await self.viewModel
                .saveCategoriesMenu(localCache: localCache)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.localCache = nil
            }
        }
       
    }
    
    private func removeAction(index:IndexSet) {
        
        var updatedCache = self.localCache!
        updatedCache.remove(atOffsets: index)
        updateOrderIndexSet(of: &updatedCache)
        
        self.localCache = updatedCache
        
    }
    
    private func onDeleteAction() -> Optional<(IndexSet) -> Void> {

        guard self.localCache != nil else { return nil }
        
        return removeAction
   
     }

    private func updateOrderIndexSet(of cache:inout [CategoriaMenu]) {
        
        for (index,var element) in cache.enumerated() {
            // aggiorniamo il list index di ogni elemento
            element.listIndex = index
            cache[index] = element
        }
    }
    
    private func makeOrderAction(from:IndexSet, to:Int) {

       //muoviamo gli elementi in una cache speculare alla localchange
        var updatedCache:[CategoriaMenu] = self.localCache!
        updatedCache.move(fromOffsets: from, toOffset: to)

        updateOrderIndexSet(of: &updatedCache)
        // mandiamo l'update della localcache
        
        self.localCache = updatedCache
        
    }
    
    private func onMoveAction() -> Optional<(IndexSet, Int) -> Void> {
        
        guard self.localCache != nil else { return nil }
        return makeOrderAction
    }
    
    private func pencilButton(categoria:CategoriaMenu) {
        
        self.nuovaCategoria = categoria
        self.categoriaArchiviata = categoria
        self.editCase = .modificaEsistente(categoria)
        withAnimation {
            self.creaNuovaCategoria = true
        }
    }
    
    private func aggiungiButton() async {
           
        csHideKeyboard()
        
        let name = csStringCleaner(string: self.nuovaCategoria.intestazione.lowercased())
       // let finalName = name.capitalized
        
        let categoriaFinale = {
            var cat = self.nuovaCategoria
            cat.intestazione = name
           // cat.listIndex = self.localCache?.count + 1
            return cat
        }()
        
        do {
           try await self.viewModel.saveCategoriaMenu(item: categoriaFinale)
            
        } catch let error as CSError {
            // mettere alert
            self.viewModel.alertItem = AlertModel(title: "Dati Corrotti", message: error.localizedDescription)
        } catch {
            
            self.viewModel.alertItem = AlertModel(title: "Errore Generico", message: "Categoria non salvata. Controllare e riavviare. Se il problema si ripete contattare info@foodies.com")
        }

        self.nuovaCategoria = CategoriaMenu()
      
       }
}*/ // backup 17.09.23
