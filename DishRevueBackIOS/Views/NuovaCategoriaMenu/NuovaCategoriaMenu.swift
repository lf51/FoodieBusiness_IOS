//
//  NuovaCategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/06/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct NuovaCategoriaMenu: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.editMode) var mode
    let backgroundColorView:Color

    @State private var creaNuovaCategoria:Bool? = false
    @State private var nuovaCategoria: CategoriaMenu
    @State private var categoriaArchiviata: CategoriaMenu
    
    init(backgroundColorView: Color) {
       
        let categoriaVuota = CategoriaMenu()
        _nuovaCategoria = State(wrappedValue: categoriaVuota)
        _categoriaArchiviata = State(wrappedValue: categoriaVuota)
        
        self.backgroundColorView = backgroundColorView
        UICollectionView.appearance().backgroundColor = .clear // Toglie lo sfondo alla list
    }
    
    var body: some View {
        
        CSZStackVB(title: "Categorie dei Menu", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading,spacing: .vStackBoxSpacing) {
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                    
                    CSLabel_1Button(placeHolder: "Nome Categoria", imageNameOrEmojy: "🍽", backgroundColor: Color.seaTurtle_3, toggleBottone: $creaNuovaCategoria)
                    
                    if creaNuovaCategoria! {
                        
                        CorpoNuovaCategoria(
                            nuovaCategoria: $nuovaCategoria,
                            categoriaArchiviata: categoriaArchiviata) {
                                self.aggiungiButton()
                            }

                    }
                }
                
                VStack(alignment: .leading, spacing: .vStackLabelBodySpacing) {
                    
                    CSLabel_conVB(
                        placeHolder: "Elenco Categorie (\(self.viewModel.db.allMyCategories.count)):",
                        imageNameOrEmojy: "list.bullet.circle",
                        backgroundColor: Color.seaTurtle_3) {
                           
                           HStack {
                               
                               CSInfoAlertView(
                                imageScale: .large,
                                title: "Elenco Categorie",
                                message: .elencoCategorieMenu)
                               
                                Spacer()
                                CSButton_tight(
                                    title: self.mode?.wrappedValue.isEditing ?? false ? "Chiudi" : "Ordina",
                                    fontWeight: .semibold,
                                    titleColor: Color.seaTurtle_4,
                                    fillColor: Color.seaTurtle_2) {
                                        
                                        withAnimation {
                                            if self.mode?.wrappedValue.isEditing == true {
                                                self.mode?.wrappedValue = .inactive
                                                
                                            } else { self.mode?.wrappedValue = .active}
                                        }
                                        
                                    }
                            }
                        }

                        List {
          
                                ForEach(viewModel.db.allMyCategories) { categoria in
                                    
                                    let dishCount = categoria.dishPerCategory(viewModel: viewModel).count
                                    
                                    VStack(alignment:.leading,spacing: 5) {
                                        
                                        HStack {
                            
                                            csVbSwitchImageText(string: categoria.image)
                                                .font(.body)
                                            
                                            Text(categoria.intestazione)
                                                .fontWeight(.semibold)
                                                .font(.system(.body, design: .rounded))
                                                .foregroundStyle(Color.seaTurtle_4)
                                            
                                            if self.mode?.wrappedValue == .inactive {
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
                                        
                                        let description = categoria.descrizione == "" ? "No description yet" : categoria.descrizione
                                        
                                        Text(description)
                                            .font(.callout)
                                            .italic()
                                            .foregroundStyle(Color.black)
                                            .opacity(0.6)
                                    }
                                    
                                }
                                .onDelete(perform: removeFromList)
                                .onMove(perform: makeOrder)
                                .listRowBackground(backgroundColorView)
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .scrollDismissesKeyboard(.immediately)
                      //  .scaledToFit()
                        .listStyle(.plain)
                }
                    

               Spacer()
            
            }
            .csHpadding()
           // .padding(.horizontal)
        }

    }
    // Method
    
    private func removeFromList(index:IndexSet) {

        self.viewModel.db.allMyCategories.remove(atOffsets: index)
    }

    private func makeOrder(from:IndexSet, to:Int) {
        
        self.viewModel.db.allMyCategories.move(fromOffsets: from, toOffset: to)
    }
    
    private func pencilButton(categoria:CategoriaMenu) {
        
        self.nuovaCategoria = categoria
        self.categoriaArchiviata = categoria
        withAnimation {
            self.creaNuovaCategoria = true
        }
    }
    
    private func aggiungiButton() {
           
        csHideKeyboard()
        
        let name = csStringCleaner(string: self.nuovaCategoria.intestazione.lowercased())
        let finalName = name.capitalized
        
        let categoriaFinale = {
            var cat = self.nuovaCategoria
            cat.intestazione = finalName
            return cat
        }()
        
        if self.viewModel.isTheModelAlreadyExist(modelID: self.nuovaCategoria.id,path: \.db.allMyCategories) {  // Update
            
            self.viewModel.updateItemModel(itemModel:categoriaFinale)
            
        } else {  // Create
          
            self.viewModel.createItemModel(itemModel: categoriaFinale)
            }
        
        self.nuovaCategoria = CategoriaMenu()
      
       }
    
 /*   private func creaCategoria() {
        
        csHideKeyboard()
        let name = csStringCleaner(string: self.nomeCategoria.lowercased())
        let finalName = name.capitalized
        
        let new = CategoriaMenu(intestazione: finalName, image: self.image)
        
       // new.addNew()
        self.image = "🍽"
        self.nomeCategoria = ""
        self.viewModel.categoriaMenuAllCases.append(new)
        
    } */ // Bavkup 14.09
    
    
}

struct NuovaCategoriaMenu_Previews: PreviewProvider {
    static var user:UserRoleModel = UserRoleModel()
    static var previews: some View {
        
        NavigationStack {
            
            NuovaCategoriaMenu(backgroundColorView: Color.seaTurtle_1)
              //  .environmentObject(AccounterVM(userAuth:user))
                .environmentObject(AccounterVM(from: initServiceObject))
        }
        
       
    }
}

struct CorpoNuovaCategoria:View {
    
    @Binding var nuovaCategoria: CategoriaMenu
    let categoriaArchiviata: CategoriaMenu

    let creAction: () -> Void
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?
    
    var body: some View {
        
        let value:(isDisabled:Bool,opacity:CGFloat) = {
         
            guard self.nuovaCategoria.intestazione != "" else { return (true,0.6)}
            if self.nuovaCategoria == categoriaArchiviata { return (true,0.6)} // 16.09
            else { return (false,1.0)}
        }() // vedi NotaVocale 14.09
        
        VStack(alignment:.leading) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing:15) {
                    
                    ForEach(csReturnEmojyCollection(),id:\.self) { emojy in
                        
                        Text(emojy)
                            .font(.title)
                            .onTapGesture {
                               // self.image = emojy
                                self.nuovaCategoria.image = emojy
                            }
    
                    }
                }
                
            }
            .padding(.vertical,5)
            .scrollDismissesKeyboard(.immediately)
                        
         //   HStack {

     
                    
                    CSTextField_4b(
                        textFieldItem: $nuovaCategoria.intestazione,
                        placeHolder: "Nome Categoria",
                        showDelete: true) {
                            csVbSwitchImageText(string: self.nuovaCategoria.image, size: .large)
                                .padding(.leading,10)
                        }
                        .focused($modelField,equals: .intestazione)
                    
                 //   Spacer()
                    
              
       
              //  }
                
                BoxDescriptionModel_Generic(
                    itemModel: $nuovaCategoria,
                    labelString: "Descrizione (Optional)",
                    disabledCondition: false,
                    backgroundColor: .seaTurtle_3,
                    modelField: $modelField)
                .focused($modelField, equals: .descrizione)
                .fixedSize(horizontal: false, vertical:true)
                    
                    Button(action: {
                        creAction()
                    }, label: {
                        HStack {
                            
                           Spacer()
                            
                            Text("Aggiungi")
                                .fontWeight(.semibold)
                                .font(.system(.body, design: .rounded))
                                .padding(.vertical,10)
                                .foregroundStyle(Color.seaTurtle_4)
                            
                            Spacer()
                        }
                        .background(Color.seaTurtle_2)
                        .cornerRadius(5.0)
                    })
                        
                        .opacity(value.opacity)
                        .disabled(value.isDisabled)
                    
                    
                
            
            
          /*  CSButton_tight(
                title: "Aggiungi",
                fontWeight: .semibold,
                titleColor: Color.seaTurtle_4,
                fillColor: Color.seaTurtle_2) {
                   // self.creaCategoria()
                    creAction()

                } */
            
          
            
        }
    
    }
    
   // method
    
}
