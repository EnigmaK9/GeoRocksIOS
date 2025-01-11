import SwiftUI

struct MainRocksView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Welcome to Rocks!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DefaultTextColor"))
                        .padding()
                    
                    // Button to integrate EnhancedLoggerPro
                    Button("Test Logging") {
                        LoggingManager.shared.logUserAction(action: "Testing EnhancedLoggerPro", metadata: ["feature": "logger"])
                    }
                    .padding()
                    .background(Color("ButtonDefault"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    // Button to show IAPExampleView
                    NavigationLink(destination: IAPExampleView()) {
                        Text("Open Purchases")
                            .padding()
                            .background(Color("ButtonDefault"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    // Button to test local notifications
                    Button("Test Local Notification") {
                        let manager = LocalNotificationManager()
                        manager.scheduleNotification(title: "Hello", body: "From LocalNotificationBuddy", timeInterval: 5)
                    }
                    .padding()
                    .background(Color("ButtonDefault"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    // Button to test biometric auth
                    Button("Test Biometric Auth") {
                        BiometricAuthManager.shared.authenticateUser { success, errorMessage in
                            if success {
                                print("Biometric Success")
                            } else {
                                print("Biometric Error: \(errorMessage ?? "")")
                            }
                        }
                    }
                    .padding()
                    .background(Color("ButtonDefault"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    NavigationLink(destination: RocksListView()) {
                        Text("View All Rocks")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("ButtonDefault"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        authViewModel.signOut()
                    }) {
                        Text("Logout")
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding()
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Rocks List")
        }
    }
}
