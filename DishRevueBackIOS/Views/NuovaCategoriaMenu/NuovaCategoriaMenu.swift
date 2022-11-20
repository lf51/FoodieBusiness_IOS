//
//  NuovaCategoriaMenu.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 01/06/22.
//

import SwiftUI

struct NuovaCategoriaMenu: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Environment(\.editMode) var mode
    let backgroundColorView:Color

    @State private var creaNuovaCategoria:Bool? = false
    @State private var nuovaCategoria: CategoriaMenu
    @State private var categoriaArchiviata: CategoriaMenu
    
   // @State private var nomeCategoria: String = ""
  //  @State private var image: String = "🍽"
  //  @State private var positionOrder: Int = 0
    
    init(backgroundColorView: Color) {
       
        let categoriaVuota = CategoriaMenu()
        _nuovaCategoria = State(wrappedValue: categoriaVuota)
        _categoriaArchiviata = State(wrappedValue: categoriaVuota)
        
        self.backgroundColorView = backgroundColorView
        UICollectionView.appearance().backgroundColor = .clear // Toglie lo sfondo alla list
    }
    
    var body: some View {
        
        CSZStackVB(title: "Categorie dei Menu", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                CSLabel_1Button(placeHolder: "Crea Nuova Categoria", imageNameOrEmojy: "🍽", backgroundColor: Color("SeaTurtlePalette_3"), toggleBottone: $creaNuovaCategoria)
                
                if creaNuovaCategoria! {
                    
                    CorpoNuovaCategoria(
                        nuovaCategoria: $nuovaCategoria,
                        categoriaArchiviata: categoriaArchiviata) {
                            self.aggiungiButton()
                        }
                    
                  /*  CorpoNuovaCategoria(
                        nomeCategoria: $nomeCategoria,
                        image: $image) {
                            self.creaCategoria()
                        } */
               
                }
                
              /*  Text("Al pubblico saranno visibili solo le categorie che contengono dei piatti; qui è possibile eliminare quelle superflue e stabilire l'ordine di visualizzazione.")
                    .fontWeight(.light)
                    .font(.system(.caption, design: .rounded)) */ // mod.16.09
                
                CSLabel_conVB(
                    placeHolder: "Elenco Categorie (\(self.viewModel.allMyCategories.count)):",
                    imageNameOrEmojy: "list.bullet.circle",
                    backgroundColor: Color("SeaTurtlePalette_3")) {
                       
                       HStack {
                           
                           CSInfoAlertView(
                            imageScale: .large,
                            title: "Elenco Categorie",
                            message: .elencoCategorieMenu)
                           
                            Spacer()
                            CSButton_tight(
                                title: self.mode?.wrappedValue.isEditing ?? false ? "Chiudi" : "Ordina",
                                fontWeight: .semibold,
                                titleColor: Color("SeaTurtlePalette_4"),
                                fillColor: Color("SeaTurtlePalette_2")) {
                                    
                                    withAnimation {
                                        if self.mode?.wrappedValue.isEditing == true {
                                            self.mode?.wrappedValue = .inactive
                                            
                                        } else { self.mode?.wrappedValue = .active}
                                    }
                                    
                                }
                        }
                    }

                    List {
      
                            ForEach(viewModel.allMyCategories) { categoria in
                                
                                let dishCount = categoria.dishPerCategory(viewModel: viewModel).count
                                
                                HStack {
                                    //  Text("\(categoria.listPositionOrder)")
                                    
                                    csVbSwitchImageText(string: categoria.image)
                                    Text(categoria.intestazione)
                                        .fontWeight(.semibold)
                                        .font(.system(.body, design: .rounded))
                                        .foregroundColor(Color("SeaTurtlePalette_4"))
                                    
                                    if self.mode?.wrappedValue == .inactive {
                                        Button {
                                            
                                          pencilButton(categoria: categoria)
                                            
                                        } label: {
                                            Image(systemName: "pencil")
                                                .foregroundColor(Color("SeaTurtlePalette_3"))
                                        }

                                    }
                                    
                                    Spacer()
                                    Text("\(dishCount) 🍽️")
                                        .foregroundColor(Color("SeaTurtlePalette_4"))
                                    
                                }
                                
                            }
                            .onDelete(perform: removeFromList)
                            .onMove(perform: makeOrder)
                            .listRowBackground(backgroundColorView)
                        
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                  //  .scaledToFit() 
                    .listStyle(.plain)
                       
                
               Spacer()
            
            }
            .padding(.horizontal)
        }

    }
    // Method
    
    private func removeFromList(index:IndexSet) {

        self.viewModel.allMyCategories.remove(atOffsets: index)
    }

    private func makeOrder(from:IndexSet, to:Int) {
        
        self.viewModel.allMyCategories.move(fromOffsets: from, toOffset: to)
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
        
        if self.viewModel.isTheModelAlreadyExist(model: self.nuovaCategoria) {  // Update
            
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

    static var previews: some View {
        
        NavigationStack {
            
            NuovaCategoriaMenu(backgroundColorView: Color("SeaTurtlePalette_1")).environmentObject(AccounterVM())
                
        }
        
       
    }
}



struct CorpoNuovaCategoria:View {
    
    @Binding var nuovaCategoria: CategoriaMenu
    let categoriaArchiviata: CategoriaMenu

   // @Binding var nomeCategoria: String
   // @Binding var image: String
    
    let creAction: () -> Void
    
    var body: some View {
        
        let value:(isDisabled:Bool,opacity:CGFloat) = {
         
            guard self.nuovaCategoria.intestazione != "" else { return (true,0.6)}
            if self.nuovaCategoria == categoriaArchiviata { return (true,0.6)} // 16.09
            else { return (false,1.0)}
        }() // vedi NotaVocale 14.09
        
      /*  Picker(selection: $image) {
            ForEach(csReturnEmojyCollection(), id:\.self) { emojy in
                
                Text(emojy)
                
                
            }
        } label: {
            Text("")
        }.pickerStyle(WheelPickerStyle()) */
        
        VStack {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing:10) {
                    
                    ForEach(csReturnEmojyCollection(),id:\.self) { emojy in
                        
                        Text(emojy)
                            .onTapGesture {
                               // self.image = emojy
                                self.nuovaCategoria.image = emojy
                            }
    
                    }
                }
                
            }.padding(.vertical)
            
         /*   Grid(alignment:.center) {
                
               // let emojySubArray = [["a","b"],["c","f"]]
                let emojySubArray = disponiRowEmojy()
                
                ForEach(emojySubArray,id:\.self) { subArray in

                    GridRow {
                        Text("\(subArray.count)")
                        ForEach(subArray,id:\.self) { emojy in
                            csVbSwitchImageText(string: emojy)
                            }
                   
                        }
                    }
                } */
            
            HStack {
                
               
                
                CSTextField_4b(
                    textFieldItem: $nuovaCategoria.intestazione,
                    placeHolder: "Associa un Nome..",
                    showDelete: true) {
                        csVbSwitchImageText(string: self.nuovaCategoria.image, size: .large)
                    }
                
                Spacer()
                CSButton_tight(
                    title: "Aggiungi",
                    fontWeight: .semibold,
                    titleColor: Color("SeaTurtlePalette_4"),
                    fillColor: Color("SeaTurtlePalette_2")) {
                       // self.creaCategoria()
                        creAction()

                    }
                    .opacity(value.opacity)
                    .disabled(value.isDisabled)
                  //  .opacity(self.nuovaCategoria.intestazione == "" ? 0.6 : 1.0)
                  //  .disabled(self.nuovaCategoria.intestazione == "")
                
                
            }
            
            BoxDescriptionModel_Generic(
                itemModel: $nuovaCategoria,
                labelString: "Descrizione (Optional)",
                disabledCondition: false,
                backgroundColor: Color("SeaTurtlePalette_3"))
            
        }
    
    }
    
   // method
    
}
