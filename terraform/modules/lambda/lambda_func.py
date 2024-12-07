import boto3
import json
import os
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMODB_TABLE_NAME"]
item_name = os.environ["DYNAMODB_ITEM_NAME"]
table = dynamodb.Table(table_name)

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    res = table.update_item(
        Key={"Id": "1"},
        UpdateExpression=f"SET {item_name} = {item_name} + :val",
        ExpressionAttributeValues={':val': 1},
        ReturnValues="UPDATED_NEW"
    )
    return {
        "statusCode": 200,
        "body": json.dumps(res['Attributes']['view_count'], cls=DecimalEncoder),
        'headers': {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': 'Content-Type,Authorization',
            'Access-Control-Allow-Methods': 'POST,OPTIONS'
        }
    }