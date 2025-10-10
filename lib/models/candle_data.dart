class CandleData {
  final DateTime time;
  final double open, high, low, close;

  CandleData(this.time, this.open, this.high, this.low, this.close);

  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      DateTime.parse(json['datetime']),
      double.parse(json['open']),
      double.parse(json['high']),
      double.parse(json['low']),
      double.parse(json['close']),
    );
  }
}
