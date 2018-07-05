#### fancy S3 bucket policy allowing access in a variety of circumstances

```
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Users-allow",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::somenumber:user/myusername1",
                    "arn:aws:iam::somenumber:user/myusername2"
                ]
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::somebucketname468372648325",
                "arn:aws:s3:::somebucketname468372648325/*"
            ]
        },
        {
            "Sid": "IPAllow",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::somebucketname468372648325",
                "arn:aws:s3:::somebucketname468372648325/*"
            ],
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "1.2.3.4/32",
                        "5.6.7.8/32"
                    ]
                }
            }
        },
        {
            "Sid": "Access-for-specific-VPCE-only",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::somebucketname468372648325",
                "arn:aws:s3:::somebucketname468372648325/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpce": "vpce-someVPCendpointid468372648325"
                }
            }
        },
        {
            "Sid": "Access-for-specific-VPC-only",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::somebucketname468372648325",
                "arn:aws:s3:::somebucketname468372648325/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:sourceVpce": "vpc-someVPCid"
                }
            }
        }
    ]
}
```
