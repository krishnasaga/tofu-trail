import json
import os
import boto3

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ.get('DYNAMODB_TABLE')
table = dynamodb.Table(TABLE_NAME)

def handler(event, context):
    """
    Hit counter Lambda function
    Increments the visits counter in DynamoDB
    """
    
    print(f"Event: {json.dumps(event)}")
    
    try:
        # Atomic increment operation
        response = table.update_item(
            Key={'id': 'visits'},
            UpdateExpression='ADD #val :inc',
            ExpressionAttributeNames={'#val': 'value'},
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='UPDATED_NEW'
        )
        
        # Get the new value
        new_value = int(response['Attributes']['value'])
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST, OPTIONS',
                'Access-Control-Allow-Headers': 'Content-Type'
            },
            'body': json.dumps({'value': new_value})
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': str(e)})
        }
