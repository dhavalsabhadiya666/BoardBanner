part of 'models.dart';

class TaskLocation {
  num? addedOn;
  String? address;
  num? addressBySelect;
  String? billBoardCompanyId;
  String? billboardImage;
  String? billBoardName;
  num? completionTime;
  String? facing;
  String? geopathPanelId;
  String? howToReach;
  String? hw;
  bool? isEnable;
  String? labelNo;
  double? lat;
  double? long;
  String? locationDescription;
  String? panelNo;
  String? panelRead;
  num? rewardAmount;
  int? status;
  String? storageImage;
  String? taskHeading;
  String? taskLocationId;
  String? userId;

  int? uploadedTaskStatus;
  DateTime? accepetedRejectedDate;

  TaskLocation({
    this.addedOn,
    this.address,
    this.addressBySelect,
    this.billBoardCompanyId,
    this.billboardImage,
    this.billBoardName,
    this.completionTime,
    this.facing,
    this.geopathPanelId,
    this.howToReach,
    this.hw,
    this.isEnable,
    this.labelNo,
    this.lat,
    this.long,
    this.locationDescription,
    this.panelNo,
    this.panelRead,
    this.rewardAmount,
    this.status,
    this.storageImage,
    this.taskHeading,
    this.taskLocationId,
    this.userId,
    this.uploadedTaskStatus,
    this.accepetedRejectedDate,
  });

  bool isAvailable() {
    return status == 0;
  }

  bool isAccepted(String userId) {
    return status == 1 && userId == this.userId;
  }

  bool forApproval(String userId) {
    return status == 2 && userId == this.userId;
  }

  bool isCompleted(String userId) {
    return status == 3 && userId == this.userId;
  }

  String getReward() {
    return '\$$rewardAmount';
  }

  factory TaskLocation.fromMap(Map<String, dynamic> data) {
    return TaskLocation(
      addedOn: int.parse(data['added_on']),
      address: data['address'],
      addressBySelect: data['address_by_select'],
      billBoardCompanyId: data['bill_board_company_id'],
      billboardImage: data['bill_board_image'],
      billBoardName: data['bill_board_name'],
      completionTime: data['completion_time'],
      facing: data['facing'],
      geopathPanelId: data['geopath_panel_id'],
      howToReach: data['how_to_reach'],
      hw: data['hw'],
      isEnable: data['is_enable'],
      labelNo: data['label_no'],
      lat: data['lat'],
      long: data['long'],
      locationDescription: data['location_description'],
      panelNo: data['panel_no'],
      panelRead: data['panel_read'],
      rewardAmount: data['reward_amount'],
      status: data['status'],
      storageImage: data['storage_image'],
      taskHeading: data['task_heading'],
      taskLocationId: data['task_location_id'],
      userId: data['userId'],
    );
  }

  @override
  String toString() {
    return 'TaskLocation(addedOn: $addedOn, address: $address, addressBySelect: $addressBySelect, billBoardCompanyId: $billBoardCompanyId, billboardImage: $billboardImage, billBoardName: $billBoardName, completionTime: $completionTime, facing: $facing, geopathPanelId: $geopathPanelId, howToReach: $howToReach, hw: $hw, isEnable: $isEnable, labelNo: $labelNo, lat: $lat, long: $long, locationDescription: $locationDescription, panelNo: $panelNo, panelRead: $panelRead, rewardAmount: $rewardAmount, status: $status, storageImage: $storageImage, taskHeading: $taskHeading, taskLocationId: $taskLocationId, userId: $userId)';
  }
}

class Distance {
  String? destinationAddresses;
  String? originAddresses;
  String? distance;
  num? distanceValue;
  String? duration;
  num? durationValue;

  Distance({
    this.destinationAddresses,
    this.originAddresses,
    this.distance,
    this.distanceValue,
    this.duration,
    this.durationValue,
  });

  factory Distance.fromMap(Map<String, dynamic> json) {
    var row = (json['rows'] as List).first['elements'];
    return Distance(
      destinationAddresses: (json['destination_addresses'] as List).first,
      originAddresses: (json['origin_addresses'] as List).first,
      distance: (row as List).first['distance']['text'],
      distanceValue: row.first['distance']['value'],
      duration: row.first['duration']['text'],
      durationValue: row.first['duration']['value'],
    );
  }

  @override
  String toString() {
    return 'Distance(destinationAddresses : $destinationAddresses, originAddresses : $originAddresses, distance : $distance, distanceValue : $distanceValue, duration : $duration, durationValue : $durationValue)';
  }
}
