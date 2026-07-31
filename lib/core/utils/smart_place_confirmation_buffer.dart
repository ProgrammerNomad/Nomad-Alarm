/// Tracks consecutive high-confidence evaluations for the same place.
class SmartPlaceConfirmationBuffer {
  int? placeId;
  int ticks = 0;

  /// Records a leading place above threshold. Returns true when ready to create.
  bool recordLeadingPlace(int leadingPlaceId) {
    if (placeId != leadingPlaceId) {
      placeId = leadingPlaceId;
      ticks = 1;
      return false;
    }

    ticks++;
    return ticks >= 3;
  }

  void reset() {
    placeId = null;
    ticks = 0;
  }
}
