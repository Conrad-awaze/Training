# Import-Module AWSPowershell
# Set-AWSCredentials -AccessKey <> -SecretKey <> -StoreAs DynamoDB
Initialize-AWSDefaults -ProfileName DynamoDB -Region eu-west-2

$exampleSchema = New-DDBTableSchema | Add-DDBKeySchema -KeyName "Name" -KeyDataType "S"
$exampleTable = New-DDBTable "myExample" -Schema $exampleSchema -ReadCapacity 5 -WriteCapacity 5

$regionName = 'eu-west-2'
$regionEndpoint=[Amazon.RegionEndPoint]::GetBySystemName($regionName)
$dbClient = New-Object Amazon.DynamoDBv2.AmazonDynamoDBClient($regionEndpoint)

function putDDBItem{
    param (
          [string]$tableName,
          [string]$key,
          [string]$val,
          [string]$key1,
          [string]$val1
          )
    $req = New-Object Amazon.DynamoDBv2.Model.PutItemRequest
    $req.TableName = $tableName

    $req.Item = New-Object 'system.collections.generic.dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
    #------------------------------------------------------------------------------
    $valObj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
        $valObj.S = $val
        $req.Item.Add($key, $valObj)
    #------------------------------------------------------------------------------
    $val1Obj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
        $val1Obj.S = $val1
        $req.Item.Add($key1, $val1Obj)
    #------------------------------------------------------------------------------
    $output = $dbClient.PutItemAsync($req)

}

putDDBItem -tableName 'myExample' -key 'Name' -val 'Bob' -key1 'Age' -val1 '21'
putDDBItem -tableName 'myExample' -key 'Name' -val 'Bert' -key1 'Age' -val1 '22'
putDDBItem -tableName 'myExample' -key 'Name' -val 'Sid' -key1 'Age' -val1 '23'
putDDBItem -tableName 'myExample' -key 'Name' -val 'Conrad' -key1 'Age' -val1 '53'

function getDDBItem{
    param (
            [string]$tableName,
            [string]$key,
            [string]$keyAttrStr
            )

$req = New-Object Amazon.DynamoDBv2.Model.GetItemRequest
$req.TableName = $tableName

$req.Key = New-Object 'system.collections.generic.dictionary[string,Amazon.DynamoDBv2.Model.AttributeValue]'
$keyAttrObj = New-Object Amazon.DynamoDBv2.Model.AttributeValue
$keyAttrObj.S = $keyAttrStr
$req.Key.Add($key, $keyAttrObj.S)
$script:resp = $dbClient.GetItemAsync($req)
}

getDDBItem -tableName 'myExample' -key 'Name' -keyAttrStr 'Sid'

Write-Host "$($script:resp.Result.Item.'Name'.S) is $($script:resp.Result.Item.'Age'.S)"
$script:resp = $null
