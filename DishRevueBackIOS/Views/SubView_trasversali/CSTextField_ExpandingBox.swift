//
//  CSTextEditor_ModelDescription.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI

///BoxTextField Espandibile fino a 5 lineel. Lunghezza di default 300 caratteri
struct CSTextField_ExpandingBox<M:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M
    var maxDescriptionLenght: Int?
    
    @State private var description: String = ""
    
   // @State private var showPlaceHolder: Bool
    @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    init(itemModel: Binding<M>, maxDescriptionLenght: Int? = nil) {
        
        _itemModel = itemModel
        let newDescription = itemModel.descrizione.wrappedValue
       // _showPlaceHolder = State(wrappedValue: newDescription == "")
        _description = State(wrappedValue: newDescription)
        self.maxDescriptionLenght = maxDescriptionLenght ?? 300
    }
    
    var body: some View {
   
            VStack {
                         
                TextField("[+] Inserire una descrizione", text: $description, axis: .vertical)
                    .font(.system(.body,design:.rounded))
                    .foregroundColor(isEditorActive ? Color.white : Color.black)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .lineLimit(0...5)
                    .padding()
                    .background(Color.white.opacity(isEditorActive ? 0.2 : 0.05))
                    .cornerRadius(5.0)
                    .overlay(alignment: .trailing) {
                        CSButton_image(frontImage: "x.circle.fill", imageScale: .medium, frontColor: Color.white) { cancelAction() }
                        .opacity(description == "" ? 0.6 : 1.0)
                        .disabled(description == "")
                        .padding(.trailing)
                    }
                    .onTapGesture {
                        
                        withAnimation {
                            isEditorActive = true
                        }
                        
                    }
                    .onChange(of: description) { newValue in
                        
                        if newValue != itemModel.descrizione {
                            isTextChanged = true }
                        else { isTextChanged = false}
                        }
                
                if isEditorActive {
                        
                        HStack {
                                CSButton_tight(
                                    title: "Undo",
                                    fontWeight: .heavy,
                                    titleColor: .red,
                                    fillColor: .clear) {
                                        
                                        withAnimation {
                                            self.description = itemModel.descrizione
                                        }
                                    }
                          
                            Spacer()
                            
                            HStack(spacing:0) {
                                
                                Text("\(description.count)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(description.count <= maxDescriptionLenght! ? Color.blue : Color.red)
                                Text("/\(maxDescriptionLenght!)")
                                    .fontWeight(.light)
                                
                            }
                            
                            CSButton_tight(
                                title: "Salva",
                                fontWeight: .heavy,
                                titleColor: .green,
                                fillColor: .clear) {

                                    saveText()
                           
                                }
                        }
                        .opacity(isTextChanged ? 1.0 : 0.6)
                        .disabled(!isTextChanged)
                    
                    }
 
                }
        }
    
    // Method
    
    private func saveText() {
        
        self.isEditorActive = false
        csHideKeyboard()

        viewModel.updateItemModel(messaggio: "Test") { () -> M in
            
            var varianteProperty = itemModel
            varianteProperty.descrizione = description
            return varianteProperty
        }
   
    }
    
    private func cancelAction() {
        
        csHideKeyboard()
        
        withAnimation {
            self.isEditorActive = false
          //  self.showPlaceHolder = itemModel.descrizione == ""
            self.description = itemModel.descrizione
        
        }
        
    }
    
}


struct CSTextField_ExpandingBox_Previews: PreviewProvider {
    
    @State static var itemSample:PropertyModel = PropertyModel()
    
    static var previews: some View {
        
        ZStack {
            Rectangle()
                .fill(Color("SeaTurtlePalette_1"))
                .ignoresSafeArea()
            
            
            CSTextField_ExpandingBox(
                itemModel: $itemSample,
                maxDescriptionLenght: 250)
        }
    }
}
