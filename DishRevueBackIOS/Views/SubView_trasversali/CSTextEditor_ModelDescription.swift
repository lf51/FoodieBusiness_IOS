//
//  CSTextEditor_ModelDescription.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI

///BoxEditor per i Model. Lunghezza di default 300 caratteri
struct CSTextEditor_ModelDescription<M:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M
    var maxDescriptionLenght: Int?
    
    @State private var description: String
    
    @State private var showPlaceHolder: Bool
    @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    init(itemModel: Binding<M>, maxDescriptionLenght: Int? = nil) {
        
        _itemModel = itemModel
        let newDescription = itemModel.descrizione.wrappedValue
        _showPlaceHolder = State(wrappedValue: newDescription == "")
        _description = State(wrappedValue: newDescription)
        self.maxDescriptionLenght = maxDescriptionLenght ?? 300
    }
    
    var body: some View {

        CSZStackVB_Framed(frameWidth: 400, backgroundOpacity: 0.0) {
            
            VStack {
                
                TextEditor(text: $description)
                    .font(.system(.body,design:.rounded))
                    .foregroundColor(isEditorActive ? Color.blue : Color.black)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .csTextEditorBackground {
                        Color.white.opacity(isEditorActive ? 0.2 : 0.05)
                    }
                    .cornerRadius(5.0)
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
                    .overlay {
                    
                        ZStack {
                        
                            if showPlaceHolder {
                                // E' Per qui che serve lo ZStack Madre
                                Color.black.opacity(0.2).cornerRadius(5.0)
                                Text("[+] Inserire una descrizione")
                                .font(.system(.title,design:.rounded))
                                .foregroundColor(Color.white)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.4)) {
                                        self.showPlaceHolder = false
                                    }
                                }
                            }
                            
                            if isEditorActive {
                                      
                                VStack(alignment:.trailing) {
                                    
                                    CSButton_image(frontImage: "x.circle.fill", imageScale: .large, frontColor: Color.white) {
                                        
                                        cancelAction()
                                        
                                    }
                                    .padding()
       
                                    Spacer()
                                    
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
                        } // Chiusa ZStack
                    } // Chiusa Overlay
                }
            } // Chiusa CSZStackMadre
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
            self.showPlaceHolder = itemModel.descrizione == ""
            self.description = itemModel.descrizione
        
        }
        
    }
    
}

/*
struct CSTextEditor_ModelDescription_Previews: PreviewProvider {
    static var previews: some View {
        CSTextEditor_ModelDescription(itemModel: <#Binding<_>#>)
    }
} */
