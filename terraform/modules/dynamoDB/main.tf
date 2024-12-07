resource "aws_dynamodb_table" "site-stats-db" {
    name= var.dynamodb_table_name
    billing_mode = "PROVISIONED"
    read_capacity = 5
    write_capacity = 5
    hash_key = "Id"
    attribute {
      name="Id"
      type = "S"
    }
}

resource "aws_dynamodb_table_item" "count" {
    table_name = aws_dynamodb_table.site-stats-db.name
    hash_key = aws_dynamodb_table.site-stats-db.hash_key
    item = <<ITEM
    {
        "Id": {"S": "1"},
        "${var.dynamodb_item_name}": {"N": "0"}
    }
    ITEM

    #ignore changes to the count item
    lifecycle {
      ignore_changes = [ item ]
    }
}