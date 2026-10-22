#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#endif
#if canImport(CIsarCore)
import CIsarCore
#endif

public class IsarFlutterLibsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
    }

    public func dummyMethodToEnforceBundling() {
        // dummy call to prevent the Isar Core symbols from being stripped
        _ = isar_get_error(0)
    }
}
