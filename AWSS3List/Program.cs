using System;
using System.Threading.Tasks;

using Amazon.S3;
using Amazon.S3.Model;

var s3Client = new AmazonS3Client("", "");

Console.WriteLine("AWS S3 Bucket Lister" + Environment.NewLine);

var listResponse = await MyListBucketAsync(s3Client);
Console.WriteLine($"Number of buckets: {listResponse.Buckets.Count}");

foreach (S3Bucket b in listResponse.Buckets)
{
    Console.WriteLine($"BucketName: {b.BucketName}");
    
}

static async Task<ListBucketsResponse> MyListBucketAsync(IAmazonS3 s3Client)
{
    return await s3Client.ListBucketsAsync();
}
Console.ReadLine();
