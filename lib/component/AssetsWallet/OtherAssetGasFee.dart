class OtherAssetGasFeeResponseModel {
  final dynamic estimatedFee;

  OtherAssetGasFeeResponseModel({this.estimatedFee});

  factory OtherAssetGasFeeResponseModel.fromJson(Map<String, dynamic> json) {
    return OtherAssetGasFeeResponseModel(
      estimatedFee: json["estimated_gas"] != null ? json["estimated_gas"] : "",
    );
  }
}

class OtherAssetGasFeeTransferRequestModel {
  String asset, receiverAddress, amount;

  OtherAssetGasFeeTransferRequestModel(
      {this.amount, this.receiverAddress, this.asset});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'amount': amount,
      'receiverAddress': receiverAddress,
      'asset': asset,
    };

    return map;
  }
}
