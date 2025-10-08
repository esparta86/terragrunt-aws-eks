import json
def lambda_handler(event, context):
    message = json.loads(event['Records'][0]['Sns']['Message'])
    print(f"Budget Alert: {message}")
    return {
        'statusCode': 200,
        'body': json.dumps('Budget alert processed.')
    }
