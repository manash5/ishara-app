/// Landmark normalisation spec version (recognition.md, spec v1). Must match
/// `ishara-systems/ml`; a spec change bumps it in both repos and retrains.
const int kLandmarkSpecVersion = 1;

/// MediaPipe hands: 21 landmarks per hand.
const int kLandmarkCount = 21;

/// x, y, z × 21 — the length of a normalised feature vector.
const int kFeatureLength = kLandmarkCount * 3;

/// Wrist and middle-finger MCP: the origin and the scale reference.
const int kWrist = 0;
const int kMiddleMcp = 9;
