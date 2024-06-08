class Quote {
  String? q;
  String? a;
  String? h;

  Quote({this.q, this.a, this.h});

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        q: json['q'] as String?,
        a: json['a'] as String?,
        h: json['h'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'a': a,
        'h': h,
      };
}
