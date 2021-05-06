class EthereumTransferResponseModel {
  final dynamic amount;
  final String address;
  final String message, error;

  EthereumTransferResponseModel(
      {this.amount, this.address, this.message, this.error});

  factory EthereumTransferResponseModel.fromJson(Map<String, dynamic> json) {
    return EthereumTransferResponseModel(
      amount: json["amount"] != null ? json["amount"] : "",
      address: json["address"] != null ? json["address"] : "",
      message: json["message"] != null ? json["message"] : "",
      error: json["error"] != null ? json["error"] : "",
    );
  }
}

class EthereumTransferRequestModel {
  dynamic amount, networkFee;
  String address;

  EthereumTransferRequestModel({this.amount, this.address});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'amount': amount,
      'networkFee': networkFee,
      'address': address,
    };

    return map;
  }
}
