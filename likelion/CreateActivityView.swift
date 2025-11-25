import SwiftUI

struct CreateActivityView: View {
    let category: Activity.ActivityCategory
    @Binding var isPresented: Bool
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var locationName: String = ""
    @State private var startDateTime: Date = Date().addingTimeInterval(3600)
    @State private var endDateTime: Date = Date().addingTimeInterval(7200)
    @State private var maxParticipants: String = "5"
    @State private var showSuccessAlert: Bool = false
    @State private var errorMessage: String = ""

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        !locationName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !maxParticipants.trimmingCharacters(in: .whitespaces).isEmpty &&
        Int(maxParticipants) ?? 0 > 0
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.8))
                        .font(.system(size: 16))
                }

                Text("Create \(category.rawValue)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            ScrollView {
                VStack(spacing: 16) {
                    // Category Tag (Read-only)
                    HStack(spacing: 8) {
                        Text(category.emoji)
                            .font(.system(size: 20))

                        Text(category.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding(12)
                    .background(Color(red: 0.4, green: 0.3, blue: 0.8))
                    .cornerRadius(8)
                    .padding(16)

                    // Form Fields
                    VStack(spacing: 16) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Activity Title")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            TextField("e.g., CS330 Study Group", text: $title)
                                .font(.system(size: 14, weight: .regular))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            TextEditor(text: $description)
                                .font(.system(size: 14, weight: .regular))
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            TextField("e.g., BU Library - 3rd Floor", text: $locationName)
                                .font(.system(size: 14, weight: .regular))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        // Start Date & Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Start Date & Time")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            DatePicker(
                                "Select start date and time",
                                selection: $startDateTime,
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        // End Date & Time
                        VStack(alignment: .leading, spacing: 8) {
                            Text("End Date & Time")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            DatePicker(
                                "Select end date and time",
                                selection: $endDateTime,
                                in: startDateTime...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        // Max Participants
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Max Participants")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)

                            HStack {
                                TextField("5", text: $maxParticipants)
                                    .font(.system(size: 14, weight: .regular))
                                    .keyboardType(.numberPad)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)

                                Stepper("", value: Binding(
                                    get: { Int(maxParticipants) ?? 5 },
                                    set: { maxParticipants = String($0) }
                                ), in: 1...100)
                                .padding(.horizontal, 12)
                            }
                        }

                        // Category-specific fields
                        if category == .study {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Subject/Course")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.black)

                                TextField("e.g., Data Structures", text: Binding(
                                    get: { "" },
                                    set: { _ in }
                                ))
                                .font(.system(size: 14, weight: .regular))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        } else if category == .mealBuddy {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Cuisine Type")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.black)

                                TextField("e.g., Korean BBQ", text: Binding(
                                    get: { "" },
                                    set: { _ in }
                                ))
                                .font(.system(size: 14, weight: .regular))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        } else if category == .sports {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sport/Activity")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.black)

                                TextField("e.g., Basketball", text: Binding(
                                    get: { "" },
                                    set: { _ in }
                                ))
                                .font(.system(size: 14, weight: .regular))
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }

                        // Error Message
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.red)
                                .padding(12)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)

                    // Submit Button
                    Button(action: createActivity) {
                        Text("Create Activity")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(isFormValid ? Color(red: 0.4, green: 0.3, blue: 0.8) : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                    .padding(16)

                    Spacer()
                        .frame(height: 20)
                }
            }
        }
        .background(Color(.systemGray6))
        .navigationBarBackButtonHidden(true)
        .alert("Activity Created!", isPresented: $showSuccessAlert) {
            Button("Done") {
                isPresented = false
                dismiss()
            }
        } message: {
            Text("\(title) has been created successfully!")
        }
    }

    private func createActivity() {
        // Validate form
        if !isFormValid {
            errorMessage = "Please fill in all required fields"
            return
        }

        // In a real app, this would make an API call to create the activity
        // For now, we'll just show a success message
        showSuccessAlert = true
    }
}

#Preview {
    NavigationStack {
        CreateActivityView(category: .study, isPresented: .constant(true))
    }
}
