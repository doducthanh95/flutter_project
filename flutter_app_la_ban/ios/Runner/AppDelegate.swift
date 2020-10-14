import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAAhV3gzsXMRUU-J7Je_P1k4ld4rCJ_j2s")
    GeneratedPluginRegistrant.register(with: self)
    
    FirebaseApp.configure()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
