package com.onegini.mobile.sdk.flutter.facade

import android.net.Uri

interface UriFacade {
  fun parse(string: String): Uri
  fun withAppendedPath(baseUri: Uri, pathSegment: String): Uri
}
