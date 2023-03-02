// Autogenerated from Pigeon (v9.0.2), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.onegini.mobile.sdk.flutter.pigeonPlugin

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class PigeonUserProfile (
  val profileId: String,
  val isDefault: Boolean

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): PigeonUserProfile {
      val profileId = list[0] as String
      val isDefault = list[1] as Boolean
      return PigeonUserProfile(profileId, isDefault)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      profileId,
      isDefault,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object UserClientApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          PigeonUserProfile.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is PigeonUserProfile -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/**
 * Flutter calls native
 *
 * Generated interface from Pigeon that represents a handler of messages from Flutter.
 */
interface UserClientApi {
  fun fetchUserProfiles(callback: (Result<List<PigeonUserProfile>>) -> Unit)

  companion object {
    /** The codec used by UserClientApi. */
    val codec: MessageCodec<Any?> by lazy {
      UserClientApiCodec
    }
    /** Sets up an instance of `UserClientApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: UserClientApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.UserClientApi.fetchUserProfiles", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped = listOf<Any?>()
            api.fetchUserProfiles() { result: Result<List<PigeonUserProfile>> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
/**
 * Native calls Flutter
 *
 * Generated class from Pigeon that represents Flutter messages that can be called from Kotlin.
 */
@Suppress("UNCHECKED_CAST")
class NativeCallFlutterApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by NativeCallFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
  }
  fun testEventFunction(argumentArg: String, callback: (String) -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.NativeCallFlutterApi.testEventFunction", codec)
    channel.send(listOf(argumentArg)) {
      val result = it as String
      callback(result)
    }
  }
}
