package app.smusy

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class SmusyApp: FlutterApplication() {
  override fun attachBaseContext(base: Context) {
    super.attachBaseContext(base)
    MultiDex.install(this)
  }
}
