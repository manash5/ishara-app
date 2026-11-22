/// "just now", "5 min ago", "3 h ago", "2 days ago" — how long ago cached
/// data was fetched ([fetchedAt]) as of [now].
String formatUpdatedAgo(DateTime fetchedAt, {DateTime? now}) {
  final age = (now ?? DateTime.now()).difference(fetchedAt);
  if (age.inMinutes < 1) return 'just now';
  if (age.inHours < 1) return '${age.inMinutes} min ago';
  if (age.inDays < 1) return '${age.inHours} h ago';
  return age.inDays == 1 ? '1 day ago' : '${age.inDays} days ago';
}

/// The chip text on screens showing cached data offline:
/// "Offline · updated 3 h ago" (or just "Offline" with no timestamp).
String offlineUpdatedLabel(DateTime? fetchedAt, {DateTime? now}) =>
    fetchedAt == null
    ? 'Offline'
    : 'Offline · updated ${formatUpdatedAgo(fetchedAt, now: now)}';
