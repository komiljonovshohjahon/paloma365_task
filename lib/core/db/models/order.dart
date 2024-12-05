class OrderMd {
  final int? id;
  final int tableId;
  final String? tableName;
  final DateTime? orderDate;
  final double totalAmount;
  final String status;

  OrderMd({
    this.id,
    required this.tableId,
    this.tableName,
    this.orderDate,
    this.totalAmount = 0.0,
    this.status = 'paid',
  });

  factory OrderMd.fromMap(Map<String, dynamic> map) {
    return OrderMd(
      id: map['id'],
      tableId: map['table_id'],
      tableName: map['table_name'],
      orderDate:
          map['order_date'] != null ? DateTime.parse(map['order_date']) : null,
      totalAmount: map['total_amount'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'table_id': tableId,
      'order_date': orderDate?.toIso8601String(),
      'total_amount': totalAmount,
      'status': status,
    };
  }
}
