class OtherAssetTransferResponseModel {
  final dynamic amount;
  final String address;
  final String message, error;

  OtherAssetTransferResponseModel(
      {this.amount, this.address, this.message, this.error});

  factory OtherAssetTransferResponseModel.fromJson(Map<String, dynamic> json) {
    return OtherAssetTransferResponseModel(
      amount: json["amount"] != null ? json["amount"] : "",
      address: json["address"] != null ? json["address"] : "",
      message: json["message"] != null ? json["message"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class OtherAssetTransferRequestModel {
  dynamic amount, networkFee;
  String receiverAddress, asset;

  OtherAssetTransferRequestModel(
      {this.amount, this.receiverAddress, this.asset, this.networkFee});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'amount': amount,
      'networkFee': networkFee,
      'receiverAddress': receiverAddress,
      'asset': asset,
    };

    return map;
  }
}
