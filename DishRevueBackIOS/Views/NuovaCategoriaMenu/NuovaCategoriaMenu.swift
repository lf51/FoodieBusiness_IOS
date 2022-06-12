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
    
    @State private var nomeCategoria: String = ""
    @State private var image: String = "🍽"
    @State private var positionOrder: Int = 0
    
    var body: some View {
        
        CSZStackVB(title: "Categorie Menu", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                CSLabel_1Button(placeHolder: "Crea Nuova Categoria", imageNameOrEmojy: "🍽", backgroundColor: Color("SeaTurtlePalette_3"), toggleBottone: $creaNuovaCategoria)
                
                if creaNuovaCategoria! {
                    
                    CorpoNuovaCategoria(
                        nomeCategoria: $nomeCategoria,
                        image: $image) {
                            self.creaCategoria()
                        }
               
                }
                
                Text("Solo le categorie utilizzate appariranno nei menu; è possibile qui stabilire l'ordine di visualizzazione.")
                    .fontWeight(.light)
                    .font(.system(.caption, design: .rounded))
                
                CSLabel_conVB(
                    placeHolder: "Elenco Categorie (\(self.viewModel.categoriaMenuAllCases.count)):",
                    imageNameOrEmojy: "list.bullet.circle",
                    backgroundColor: Color("SeaTurtlePalette_3")) {
                        
                        Group {
                            Spacer()
                            CSButton_tight(
                                title: self.mode?.wrappedValue.isEditing ?? false ? "Chiudi" : "Ordina",
                                fontWeight: .semibold,
                                titleColor: Color("SeaTurtlePalette_4"),
                                fillColor: Color("SeaTurtlePalette_2")) {
                                  if self.mode?.wrappedValue.isEditing == true {
                                        
                                      self.mode?.wrappedValue = .inactive
                                  } else { self.mode?.wrappedValue = .active}
                            }
                        }

                        
                    }
                
                
                List {
                    
                    ForEach(viewModel.categoriaMenuAllCases) {categoria in
                            
                            HStack {
                              //  Text("\(categoria.listPositionOrder)")
                                csVbSwitchImageText(string: categoria.image)
                                Text(categoria.nome)
                                    .fontWeight(.semibold)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(Color("SeaTurtlePalette_4"))
                            }
       
                        }
                    .onDelete(perform: removeFromList)
                    .onMove(perform: makeOrder)
                    .listRowBackground(backgroundColorView)
      
                }
                .listStyle(PlainListStyle())
        
                Spacer()
            
            }
            .padding(.horizontal)
        }

    }
    // Method
    
    private func removeFromList(index:IndexSet) {

        self.viewModel.categoriaMenuAllCases.remove(atOffsets: index)
    }

    private func makeOrder(from:IndexSet, to:Int) {
        
        self.viewModel.categoriaMenuAllCases.move(fromOffsets: from, toOffset: to)
    }
    
    private func creaCategoria() {
        
        csHideKeyboard()
        let name = csStringCleaner(string: self.nomeCategoria.lowercased())
        let finalName = name.capitalized
        
        let new = CategoriaMenu(nome: finalName, image: self.image)
        
       // new.addNew()
        self.image = "🍽"
        self.nomeCategoria = ""
        self.viewModel.categoriaMenuAllCases.append(new)
        
    }
    
    
}

struct NuovaCategoriaMenu_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            
            NuovaCategoriaMenu(backgroundColorView: Color("SeaTurtlePalette_1"))
        }
        
       
    }
}



struct CorpoNuovaCategoria:View {
    
    @Binding var nomeCategoria: String
    @Binding var image: String
    
    let creAction: () -> Void
    
    var body: some View {
        
        Picker(selection: $image) {
            ForEach(csReturnEmojyCollection(), id:\.self) { emojy in
                
                Text(emojy)
                
                
            }
        } label: {
            Text("")
        }.pickerStyle(WheelPickerStyle())
           
        HStack {
            
            CSTextField_4b(
                textFieldItem: $nomeCategoria,
                placeHolder: "Associa un Nome..",
                showDelete: true) {
                    csVbSwitchImageText(string: self.image, size: .large)
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
                .opacity(self.nomeCategoria == "" ? 0.6 : 1.0)
                .disabled(self.nomeCategoria == "")
            
            
        }
  
        
        
        
    }
    
    
    
}



