//
//  InspectorView.swift
//  Mochi Diffusion
//
//  Created by Joshua Park on 12/19/22.
//

import SwiftUI
import StableDiffusion

struct InspectorView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let sdi = store.getSelectedImage(), let img = sdi.image {
                Image(img, scale: 1, label: Text(verbatim: String(sdi.prompt)))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.secondary, lineWidth: 4)
                    )
                    .padding()
                
                ScrollView(.vertical) {
                    Grid(alignment: .leading, horizontalSpacing: 4) {
                        InfoGridRow(
                            type: "Date",
                            text: sdi.generatedDate.formatted(date: .long, time: .standard),
                            showCopyToPromptOption: false)
                        InfoGridRow(
                            type: "Model",
                            text: sdi.model,
                            showCopyToPromptOption: false)
                        InfoGridRow(
                            type: "Size",
                            text: "\(sdi.width) x \(sdi.height)\(sdi.isUpscaled ? " (Converted to High Resolution)" : "")",
                            showCopyToPromptOption: false)
                        InfoGridRow(
                            type: "Include in Image",
                            text: sdi.prompt,
                            showCopyToPromptOption: true,
                            callback: store.copyPromptToPrompt)
                        InfoGridRow(
                            type: "Exclude from Image",
                            text: sdi.negativePrompt,
                            showCopyToPromptOption: true,
                            callback: store.copyNegativePromptToPrompt)
                        InfoGridRow(
                            type: "Scheduler",
                            text: sdi.scheduler.rawValue,
                            showCopyToPromptOption: true,
                            callback: store.copySchedulerToPrompt)
                        InfoGridRow(
                            type: "Seed",
                            text: String(sdi.seed),
                            showCopyToPromptOption: true,
                            callback: store.copySeedToPrompt)
                        InfoGridRow(
                            type: "Steps",
                            text: String(sdi.steps),
                            showCopyToPromptOption: true,
                            callback: store.copyStepsToPrompt)
                        InfoGridRow(
                            type: "Guidance Scale",
                            text: String(sdi.guidanceScale),
                            showCopyToPromptOption: true,
                            callback: store.copyGuidanceScaleToPrompt)
                        InfoGridRow(
                            type: "Image Index",
                            text: String(sdi.imageIndex),
                            showCopyToPromptOption: false)
                    }
                }
                .padding([.horizontal])
                
                HStack(alignment: .center) {
                    Button(action: store.copyToPrompt) {
                        Text("Copy Options to Sidebar",
                             comment: "Button to copy the currently selected image's generation options to the prompt input sidebar")
                    }
                    Button(action: {
                        let info = getHumanReadableInfo(sdi: sdi)
                        let pb = NSPasteboard.general
                        pb.declareTypes([.string], owner: nil)
                        pb.setString(info, forType: .string)
                    }) {
                        Text("Copy",
                             comment: "Button to copy the currently selected image's generation options to the clipboard")
                    }
                }
                .padding()
            }
            else {
                Text("No Info",
                     comment: "Placeholder text for image inspector")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct InfoGridRow: View {
    var type: LocalizedStringKey
    var text: String
    var showCopyToPromptOption: Bool
    var callback: (() -> ())? = nil
    
    var body: some View {
        GridRow {
            Text("")
            Text(type)
                .helpTextFormat()
        }
        GridRow {
            if showCopyToPromptOption {
                Button(action: {
                    guard let callbackFn = callback else { return }
                    callbackFn()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(Color.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .help("Copy Option to Sidebar")
            }
            else {
                Text("")
            }
            
            Text(text)
                .selectableTextFormat()
        }
        Spacer().frame(height: 12)
    }
}

struct InspectorView_Previews: PreviewProvider {
    static var previews: some View {
        InspectorView()
    }
}
