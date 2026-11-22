/// Whether the device holds a session (tokens). A cleared session — logout,
/// a failed token refresh, a deleted account — reports [signedOut].
enum AuthStatus { signedIn, signedOut }
