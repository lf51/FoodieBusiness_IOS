//
//  CSTextEditor_ModelDescription.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI

/// Abbiamo tolto il vincolo generic del Model e reso il textfield utilizzabile con qualsia binding String. Il salvataggio è gestito a monte tramite una escaping Closure
struct CSTextField_ExpandingBoxPlain: View {

    @EnvironmentObject var viewModel: AccounterVM
    let value: String
    @Binding var dismissButton: Bool
    var maxDescriptionLenght: Int?
    
    @State private var description: String = ""
    
    @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    let saveActionPlus:(_ :String) -> Void
    
    init(value: String, dismissButton: Binding<Bool>, maxDescriptionLenght: Int? = nil, saveAction:@escaping (_:String) -> Void) {
        
        self.value = value
        _dismissButton = dismissButton
        let newDescription = value
        _description = State(wrappedValue: newDescription)
        self.maxDescriptionLenght = maxDescriptionLenght ?? 300
        self.saveActionPlus = saveAction
    }
    
    var body: some View {
   
            VStack {
                         
                TextField("[+] Inserire testo", text: $description, axis: .vertical)
                    .font(.system(.body,design:.rounded))
                    .foregroundColor(isEditorActive ? Color.white : Color.black)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .lineLimit(0...10)
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
                        
                        if newValue != value {
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
                                            self.description = value
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
                                    self.saveAction()
                                }
                        }
                        .opacity(isTextChanged ? 1.0 : 0.6)
                        .disabled(!isTextChanged)
                    
                    }
 
                }
        }
    
    // Method
    
    private func saveAction() {
        
        self.isEditorActive = false
        csHideKeyboard()
       // let newDescription = csStringCleaner(string: description)
        self.saveActionPlus(description)
        self.dismissButton = false
       
    }
    
    private func cancelAction() {
        withAnimation {
            self.description = ""
        }
        
    }
    
}


///BoxTextField Espandibile fino a 5 lineel. Lunghezza di default 300 caratteri
 struct CSTextField_ExpandingBox<M:MyProDescriptionPack_L0>: View {
    // 15.09 Passa da M:MyProModelPackL0 a M:MyProToolPackL0
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M
    @Binding var dismissButton: Bool?
    var maxDescriptionLenght: Int?
    
    @State private var description: String = ""
    
    @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    init(itemModel: Binding<M>, dismissButton: Binding<Bool?>, maxDescriptionLenght: Int? = nil) {
        
        _itemModel = itemModel
        _dismissButton = dismissButton
        let newDescription = itemModel.descrizione.wrappedValue
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

                                    self.saveAction()
                                   /* self.isEditorActive = false
                                    csHideKeyboard()
                                    self.itemModel.descrizione = description */
                                  //  self.dismissButton.toggle()
                                    
                                }
                        }
                        .opacity(isTextChanged ? 1.0 : 0.6)
                        .disabled(!isTextChanged)
                    
                    }
 
                }
        }
    
    // Method
    
   /* private func saveText() {
        
        self.isEditorActive = false
        csHideKeyboard()

        viewModel.updateItemModel(messaggio: "Test") { () -> M in
            
            var varianteProperty = itemModel
            varianteProperty.descrizione = description
            return varianteProperty
        }
   
    } */ // Salvataggio spostato nella View MAdre in data 27.06
    
    private func saveAction() {
        
        self.isEditorActive = false
        csHideKeyboard()
        // 22.08
        let newDescription = csStringCleaner(string: description)
        self.itemModel.descrizione = newDescription
        self.dismissButton = false 
        //
       // self.itemModel.descrizione = description
       
    }
    
    private func cancelAction() {
        
     //   csHideKeyboard()
        
        withAnimation {
         //   self.isEditorActive = false
          //  self.showPlaceHolder = itemModel.descrizione == ""
          //  self.description = itemModel.descrizione
            self.description = ""
        
        }
        
    }
    
}



/*
///BoxTextField Espandibile fino a 5 lineel. Lunghezza di default 300 caratteri
struct CSTextField_ExpandingBox<M:MyModelProtocol>: View {
    
    @EnvironmentObject var viewModel: AccounterVM
    @Binding var itemModel: M
    var maxDescriptionLenght: Int?
    
    @State private var description: String = ""
    
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
    
}  */ // 27.06 Backup per Deprecazione

/*

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
*/
