//
//  CustomLabel.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 14/02/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

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
                        .foregroundStyle(toggleBottonePLUS! ? .red : Color.seaTurtle_3)
                    
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
                        .foregroundStyle(Color.seaTurtle_3)
                    
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
                        .foregroundStyle(Color.white)
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


/*struct CustomLabel_Previews: PreviewProvider {
    static var previews: some View {
        CustomLabel()
    }
}*/

