#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#endif

// Isar Core ships as IsarCore.framework, which the app embeds through this
// plugin's dependency on it. Dart opens it directly, so nothing is done here.
public class IsarFlutterLibsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
    }
}
