//
//  CustomLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

/*
/// Label (Testo+Image/Emojy) con  ViewBuilder
struct CSLabel_conVB<Content:View>: View {
    
    var placeHolder: String
    var placeHolderColor: Color?
    var imageName: String?
    var backgroundColor: Color
    var backgroundOpacity: Double?
    
    @ViewBuilder var content: Content
    
    init(placeHolder: String,placeHolderColor:Color? = nil, imageNameOrEmojy: String? = nil, backgroundColor: Color, backgroundOpacity:Double? = nil, content: () -> Content) {
        
        self.placeHolder = placeHolder
        self.placeHolderColor = placeHolderColor
        self.imageName = imageNameOrEmojy
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity

        self.content = content()
        
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(placeHolderColor ?? .black)
                    .lineLimit(1)
            } icon: {
         
                csVbSwitchImageText(string: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(backgroundOpacity ?? 0.2))
            )
            .fixedSize() // introdotto il 16.09
            
          //  Spacer()
            
            content
        }
    }
} */ // 21.12.22 Migrata su MyPackView

/*
/// Label (Testo+Image/Emojy) con Bottone Optional (Richiede un Binding Bool)
struct CSLabel_1Button: View { // Deprecati in futuro. Sostituibile con CSLabel2Action
    
    var placeHolder: String
    var imageName: String?
    var imageColor: Color?
    var backgroundColor: Color
    var backgroundOpacity: Double?
    let disabledCondition: Bool?
    
    @Binding var toggleBottone: Bool?
    
    init(placeHolder: String, imageNameOrEmojy: String? = nil,imageColor:Color? = Color.black, backgroundColor: Color, backgroundOpacity:Double? = nil, toggleBottone: Binding<Bool?>? = nil, disabledCondition:Bool? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageNameOrEmojy
        self.imageColor = imageColor
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        
        _toggleBottone = toggleBottone ?? Binding.constant(nil)
        self.disabledCondition = disabledCondition
    } // VOGLIO TROVARE UN MODO PER OMETTERE IL TOGGLEBOTTONE INVECE DI PASSARE ESPLICITAMENTE NIL

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
         
                csVbSwitchImageText(string: imageName)
                    .foregroundColor(imageColor)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(backgroundOpacity ?? 0.2))
            )
            
            if toggleBottone != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottone!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottone! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottone! ? .red : Color.seaTurtle_3)
                }
                .opacity(disabledCondition ?? false ? 0.6 : 1.0)
                .disabled(disabledCondition ?? false)
            }
            
            Spacer()
        }
    }
} */ // 20.12.22 Migrata su MyPackView

/// Label (Testo + Image) con due Bottoni Optional (Uno PlusImage e Uno testuale)
struct CSLabel_2Button: View { // Deprecati in futuro. Sostituibile con CSLabel2Action
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    @Binding var toggleBottonePLUS: Bool? // optional perchè tutti e tre i valori inizializzano la View diversamente. Vero Falso e Nil
    @Binding var toggleBottoneTEXT: Bool?
    
    var testoBottoneTEXT: String?
    let disabledCondition:Bool?
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, toggleBottonePLUS: Binding<Bool?>? = nil, toggleBottoneTEXT: Binding<Bool?>? = nil, testoBottoneTEXT: String, disabledCondition:Bool? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor

        _toggleBottonePLUS = toggleBottonePLUS ?? Binding.constant(nil)
        _toggleBottoneTEXT = toggleBottoneTEXT ?? Binding.constant(nil)
        
        self.testoBottoneTEXT = testoBottoneTEXT
        self.disabledCondition = disabledCondition
    }

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(0.2))
                    
            )
            
            Spacer()
            
            if toggleBottonePLUS != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        toggleBottonePLUS!.toggle()
                    }
                    
                } label: {
                     
                    Image(systemName: toggleBottonePLUS! ? "minus.circle" : "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(toggleBottonePLUS! ? .red : Color.seaTurtle_3)
                    
                }
                .opacity(disabledCondition ?? false ? 0.6 : 1.0)
                .disabled(disabledCondition ?? false)
                .disabled(toggleBottoneTEXT ?? false)
            }
            
            Spacer()
            
            if toggleBottoneTEXT != nil {
      
                CSButton_tight(
                    title: testoBottoneTEXT ?? "",
                    fontWeight: .semibold,
                    titleColor: .white,
                    fillColor: Color.seaTurtle_2) {
                        withAnimation(.default) {
                            toggleBottoneTEXT!.toggle()
                        }
                    }
                    .opacity(disabledCondition ?? false ? 0.6 : 1.0)
                    .disabled(disabledCondition ?? false)
                    .disabled(toggleBottonePLUS ?? false)
    
            }
        }
    }
}

///Label (Testo + Image) con due Action Optional (Uno PlusImage e Uno testuale) 
struct CSLabel_2Action: View {
    
    var placeHolder: String
    var imageName: String
    var backgroundColor: Color
    
    var testoBottoneTEXT: String? = nil
    var actionPlusButton: (() -> Void)? = nil
    var actionTextButton: (() -> Void)? = nil


    init(placeHolder: String, imageName: String, backgroundColor: Color, testoBottoneTEXT: String? = nil, actionPlusButton: (() -> Void)? = nil, actionTextButton: (() -> Void)? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.backgroundColor = backgroundColor

        self.testoBottoneTEXT = testoBottoneTEXT
        self.actionPlusButton = actionPlusButton
        self.actionTextButton = actionTextButton
        
    }

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(backgroundColor.opacity(0.2))
                    
            )
            
            Spacer()
            
            if self.actionPlusButton != nil {
                
                Button {
                    withAnimation(.default) {
                        
                        self.actionPlusButton!()
                    }
                    
                } label: {
                     
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                        .foregroundColor(Color.seaTurtle_3)
                    
                }//.disabled(toggleBottoneTEXT ?? false)
            }
            
            Spacer()
            
            if self.actionTextButton != nil {
      
                Button {
                    withAnimation(.default) {
                        self.actionTextButton!()
                    }
                } label: {
                    Text(testoBottoneTEXT ?? "")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(.borderedProminent)
               // .brightness(toggleBottoneTEXT ?? false ? 0.0 : -0.05)
               // .disabled(toggleBottonePLUS ?? false)
    
            }
        }
    }
}


/// Label (Testo + Image) + Picker AvailabilityMenu
struct CSLabel_1Picker: View {
    
    let placeHolder: String
    let imageName: String
    let labelColor: Color
    let pickerColor: Color    
    
    @Binding var selectedProgram: AvailabilityMenu
    var isThereConditionToDisablePicker: Bool
    
    init(placeHolder: String, imageName: String, backgroundColor: Color, pickerColor:Color? = nil, availabilityMenu: Binding<AvailabilityMenu>, conditionToDisablePicker: Bool? = nil) {
        
        self.placeHolder = placeHolder
        self.imageName = imageName
        self.labelColor = backgroundColor
        self.pickerColor = pickerColor ?? Color.clear

        self.isThereConditionToDisablePicker = conditionToDisablePicker ?? false
        _selectedProgram = availabilityMenu
        
    }

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                Image(systemName: imageName)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(labelColor.opacity(0.2))
            )
    
            Spacer()
            
            Picker(selection:$selectedProgram) {
                
                ForEach(AvailabilityMenu.allCases, id:\.self) {schedule in
                    
                    Text(schedule.shortDescription()).tag(schedule as AvailabilityMenu?)
                    
                }
                
            } label: {Text("")}
            .pickerStyle(SegmentedPickerStyle())
            .opacity(isThereConditionToDisablePicker ? 0.6 : 1.0)
            .disabled(isThereConditionToDisablePicker)
          
        }
    }
}


// FUNZIONANTE DA SETTARE BENE SE LO SI VUOLE UTILIZZARE. IN data 07-05 creato ma non utilizzato
/// Label (testo + Image/Emojy) con Picker di un Array [M: MyModelProtcoll]
/*struct CSLabel_1GenericPicker<M:MyModelProtocol>: View {
    
    let placeHolder: String
    let imageNameOrEmojy: String
    let labelColor: Color
    let pickerColor: Color
    
    let allCases: Array<M>
   // var pickerStyle: stilePicker
    
   // @Binding var selectedProgram: M
    @State var selectedProgram: String = ""
    var isThereConditionToDisablePicker: Bool
    
    init(allCases:Array<M>, placeHolder: String, imageNameOrEmojy: String, backgroundColor: Color, pickerColor:Color? = nil, conditionToDisablePicker: Bool? = nil) {
        
        self.allCases = allCases
     //   self.pickerStyle = pickerStyle ?? (MenuPickerStyle() as! stilePicker)
        
        self.placeHolder = placeHolder
        self.imageNameOrEmojy = imageNameOrEmojy
        self.labelColor = backgroundColor
        self.pickerColor = pickerColor ?? Color.clear

        self.isThereConditionToDisablePicker = conditionToDisablePicker ?? false
      //  _selectedProgram = allCases[0]
        
    }

    var body: some View {
        
        HStack {
            
            Label {
                Text(placeHolder)
                    .fontWeight(.medium)
                    .font(.system(.subheadline, design: .monospaced))
            } icon: {
                csVbSwitchImageText(string: imageNameOrEmojy)
            }
            ._tightPadding()
            .background(
                
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(labelColor.opacity(0.2))
            )
    
            Spacer()
            
            Picker(selection:$selectedProgram) {
                
                ForEach(allCases) { model in
                    
                    Text(model.intestazione)
                    
                }
                
            } label: {Text("")}
            .pickerStyle(MenuPickerStyle())
            
            .opacity(isThereConditionToDisablePicker ? 0.6 : 1.0)
            .disabled(isThereConditionToDisablePicker)
          
        }
    }
} */


/*struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel()
    }
}*/

