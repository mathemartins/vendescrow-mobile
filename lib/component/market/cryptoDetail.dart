class CryptoDetail {
  int id;
  String name;
  String symbol;
  String category;
  String description;
  String slug;
  String logo;
  String subreddit;
  String notice;
  List<String> tags;
  List<String> tagNames;
  List<String> tagGroups;
  String platform;
  String dateAdded;
  String twitterUsername;
  int isHidden;

  CryptoDetail(
      {this.id,
      this.name,
      this.symbol,
      this.category,
      this.description,
      this.slug,
      this.logo,
      this.subreddit,
      this.notice,
      this.tags,
      this.tagNames,
      this.tagGroups,
      this.platform,
      this.dateAdded,
      this.twitterUsername,
      this.isHidden});

  CryptoDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    category = json['category'];
    description = json['description'];
    slug = json['slug'];
    logo = json['logo'];
    subreddit = json['subreddit'];
    notice = json['notice'];
    tags = json['tags'].cast<String>();
    tagNames = json['tag-names'].cast<String>();
    tagGroups = json['tag-groups'].cast<String>();
    platform = json['platform'];
    dateAdded = json['date_added'];
    twitterUsername = json['twitter_username'];
    isHidden = json['is_hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['category'] = this.category;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['logo'] = this.logo;
    data['subreddit'] = this.subreddit;
    data['notice'] = this.notice;
    data['tags'] = this.tags;
    data['tag-names'] = this.tagNames;
    data['tag-groups'] = this.tagGroups;
    data['platform'] = this.platform;
    data['date_added'] = this.dateAdded;
    data['twitter_username'] = this.twitterUsername;
    data['is_hidden'] = this.isHidden;
    return data;
  }
}
