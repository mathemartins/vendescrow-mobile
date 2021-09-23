class P2PTradeSettings {
  double escrowFee;

  P2PTradeSettings({this.escrowFee});

  P2PTradeSettings.fromJson(Map<String, dynamic> json) {
    escrowFee = json['escrow_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['escrow_fee'] = this.escrowFee;
    return data;
  }
}