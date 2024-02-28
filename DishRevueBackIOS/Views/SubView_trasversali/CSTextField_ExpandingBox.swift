//
//  CSTextEditor_ModelDescription.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 07/05/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

// 08.03.23 La versione generic è in sostanza inutile, e sarebbe più pulito sostituirla con quellla string. Dovremmo valutare tale riorganizzazione che probabilmente richiederebbe delle modifiche al protocollo MyDescription, il quale probabilmente diverrebbe inutile

///BoxTextField Espandibile fino a 5 lineel. Lunghezza di default 300 caratteri
 struct CSTextField_ExpandingBox<M:MyProDescriptionPack_L0>: View {
    // 15.09 Passa da M:MyProModelPackL0 a M:MyProToolPackL0
    
    @EnvironmentObject var viewModel: AccounterVM
     
    @Binding var itemModel: M
    @Binding var dismissButton: Bool?
    var maxDescriptionLenght: Int
    
    @State private var description: String = ""
    
  //  @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    init(
        itemModel: Binding<M>,
        dismissButton: Binding<Bool?>,
        modelField:FocusState<ModelField?>.Binding,
        maxDescriptionLenght: Int = 300) {
        
        _itemModel = itemModel
        _dismissButton = dismissButton
        let newDescription = itemModel.descrizione.wrappedValue ?? ""
        _description = State(wrappedValue: newDescription)
        self.maxDescriptionLenght = maxDescriptionLenght
            _modelField = modelField
    }
    
     // upgrade 17.02
     
     @FocusState.Binding var modelField:ModelField?
     
    var body: some View {
   
            VStack {
                         
                TextField("[+] Inserire una descrizione", 
                          text: $description,
                          axis: .vertical)
                    .font(.system(.body,design:.rounded))
                    .foregroundStyle(/*isEditorActive ? Color.white :*/ Color.black)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .lineLimit(0...5)
                    .padding()
                    .background(Color.white.opacity(/*isEditorActive ? 0.2 : */0.05))
                    .cornerRadius(5.0)
                    .overlay(alignment: .trailing) {
                        CSButton_image(
                            frontImage: "x.circle.fill",
                            imageScale: .medium,
                            frontColor: Color.white) { cancelAction() }
                        .opacity(description == "" ? 0.4 : 1.0)
                        .disabled(description == "")
                        .padding(.trailing)
                    }
                    .onChange(of: description) { _, newValue in
                        
                        if newValue != itemModel.descrizione {
                            isTextChanged = true }
                        else { isTextChanged = false}
                        }
 
                }
            .toolbar {
                
                ToolbarItem(placement: .keyboard) {
                    
                    if self.modelField == .descrizione {
                        
                       vbKeyboardLogic()
                    }
                }
                
            }
        }
    
    // Method
     
     @ViewBuilder private func vbKeyboardLogic() -> some View {
         
       //  if isEditorActive {
                  
                  HStack {
                      
                      Button {
                          withAnimation {
                              self.description = itemModel.descrizione ?? ""
                          }
                      } label: {
                          Text("Undo")
                              .fontWeight(.heavy)
                              .foregroundStyle(Color.red)
                      }

                    
                      Spacer()
                      
                      let descriptionTooLong = self.description.count > self.maxDescriptionLenght
                      
                      HStack(spacing:0) {
                          
                          Text("\(description.count)")
                              .fontWeight(.semibold)
                              .foregroundStyle(descriptionTooLong ? Color.red : Color.blue)
                          Text("/\(maxDescriptionLenght)")
                              .fontWeight(.light)
                          
                      }

                      Button {
                          withAnimation {
                              self.saveAction()
                          }
                      } label: {
                          Text("Salva")
                              .fontWeight(.heavy)
                              .foregroundStyle(Color.green)
                      }
                      .opacity(descriptionTooLong ? 0.4 : 1.0)
                      .disabled(descriptionTooLong)

                  }
                  .opacity(isTextChanged ? 1.0 : 0.4)
                  .disabled(!isTextChanged)

     }
     
    
    private func saveAction() {
        
      // self.isEditorActive = false
        csHideKeyboard()
        // 22.08
        let newDescription = csStringCleaner(string: self.description)
        self.itemModel.descrizione = newDescription.isEmpty ? nil : newDescription
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

/// Abbiamo tolto il vincolo generic del Model e reso il textfield utilizzabile con qualsia binding String. Il salvataggio è gestito a monte tramite una escaping Closure
struct CSTextField_ExpandingBoxPlain: View {
// Nota 08.03.23 ExpandingBox
    @EnvironmentObject var viewModel: AccounterVM
    
    let value: String
    @Binding var dismissButton: Bool
    var maxDescriptionLenght: Int
    
    @State private var description: String = ""
    
    @State private var isEditorActive: Bool = false
    @State private var isTextChanged: Bool = false
   
    let saveActionPlus:(_ :String) -> Void
    
    init(
        value: String,
        dismissButton: Binding<Bool>,
        maxDescriptionLenght: Int = 300,
        modelField:FocusState<ModelField?>.Binding,
        saveAction:@escaping (_:String) -> Void) {
        
        self.value = value
        _dismissButton = dismissButton
        let newDescription = value
        _description = State(wrappedValue: newDescription)
        self.maxDescriptionLenght = maxDescriptionLenght
        _modelField = modelField
        self.saveActionPlus = saveAction
    }
    
    @FocusState.Binding var modelField:ModelField?
    
    var body: some View {
   
            VStack {
                         
                TextField("[+] Inserire testo", text: $description, axis: .vertical)
                    .font(.system(.body,design:.rounded))
                    .foregroundStyle(/*isEditorActive ? Color.white :*/ Color.black)
                    .autocapitalization(.sentences)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
                    .lineLimit(0...10)
                    .padding()
                    .background(Color.white.opacity(/*isEditorActive ? 0.2 : */0.05))
                    .cornerRadius(5.0)
                    .overlay(alignment: .trailing) {
                        CSButton_image(
                            activationBool:self.description == "",
                            frontImage: "arrow.uturn.left.circle",
                            backImage: "x.circle",
                            imageScale: .medium,
                            frontColor: Color.seaTurtle_4) {
                                withAnimation {
                                    cancelAction()
                                }
                            }
                       // .opacity(description == "" ? 0.6 : 1.0)
                       // .disabled(description == "")
                        .padding(.trailing)
                    }
                    /*.onTapGesture {
                        
                        withAnimation {
                            isEditorActive = true
                        }
                        
                    } */
                    .onChange(of: description) { _ , newValue in
                        
                        if newValue != value {
                            isTextChanged = true }
                        else { isTextChanged = false}
                        }
                
               /* if isEditorActive {
                        
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
                                    .foregroundStyle(description.count <= maxDescriptionLenght! ? Color.blue : Color.red)
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
                    
                    } */
 
            }.toolbar {
                ToolbarItem(placement: .keyboard) {
                    if self.modelField == .descrizione {
                        vbKeyboardLogic()
                    }
                }
            }
        }
    
    // Method
    
    @ViewBuilder func vbKeyboardLogic() -> some View {
        
        HStack {
            
              /*  CSButton_tight(
                    title: "Undo",
                    fontWeight: .heavy,
                    titleColor: .red,
                    fillColor: .clear) {
                        
                        withAnimation {
                            self.description = value
                        }
                    } */
          
            
            Button {
                withAnimation {
                    self.description = value
                }
            } label: {
                Text("Undo")
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.red)
            }

            Spacer()
            
            HStack(spacing:0) {
                
                Text("\(description.count)")
                    .fontWeight(.semibold)
                    .foregroundStyle(description.count <= maxDescriptionLenght ? Color.blue : Color.red)
                Text("/\(maxDescriptionLenght)")
                    .fontWeight(.light)
                
            }
            
            Button {
                withAnimation {
                    self.saveAction()
                }
            } label: {
                Text("Salva")
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.green)
            }
            
           /* CSButton_tight(
                title: "Salva",
                fontWeight: .heavy,
                titleColor: .green,
                fillColor: .clear) {
                    self.saveAction()
                } */
        }
        .opacity(isTextChanged ? 1.0 : 0.6)
        .disabled(!isTextChanged)
    }
    
    
    private func saveAction() {
        
      //  self.isEditorActive = false
        csHideKeyboard()
       // let newDescription = csStringCleaner(string: description)
        self.saveActionPlus(description)
        self.dismissButton = false
       
    }
    
    private func cancelAction() {
        
        if self.description == "" { self.dismissButton = false }
        else { self.description = "" }

    }
    
}

/*

struct CSTextField_ExpandingBox_Previews: PreviewProvider {
    
    @State static var itemSample:PropertyModel = PropertyModel()
    
    static var previews: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.seaTurtle_1)
                .ignoresSafeArea()
            
            
            CSTextField_ExpandingBox(
                itemModel: $itemSample,
                maxDescriptionLenght: 250)
        }
    }
}
*/
