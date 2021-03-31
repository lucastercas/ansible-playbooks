# resource "aws_elasticsearch_domain" "es" {
#   domain_name           = local.elk_domain
#   elasticsearch_version = "7.7"

#   cluster_config {
#     instance_count         = 3
#     instance_type          = "r5.large.elasticsearch"
#     zone_awareness_enabled = true

#     zone_awareness_config {
#       availability_zone_count = 3
#     }
#   }

#   vpc_options {
#     subnet_ids = [
#       aws_subnet.nated_01.id,
#       aws_subnet.nated_02.id,
#       aws_subnet.nated_03.id
#     ]

#     security_group_ids = [
#       aws_security_group.es.id
#     ]
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }

#   #   access_policies = <<CONFIG
#   # {
#   #   "Version": "2012-10-17",
#   #   "Statement": [
#   #       {
#   #           "Action": "es:*",
#   #           "Principal": "*",
#   #           "Effect": "Allow",
#   #           "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${local.elk_domain}/*"
#   #       }
#   #   ]
#   # }
#   #   CONFIG

#   snapshot_options {
#     automated_snapshot_start_hour = 23
#   }

#   tags = {
#     Domain = var.elk_domain
#   }
# }
resource "aws_elasticsearch_domain" "demo_es" {
  domain_name           = var.elk_domain
  elasticsearch_version = "7.9"

  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }

  vpc_options {
    subnet_ids = [
      aws_subnet.public_01.id
    ]
    security_group_ids = [
      aws_security_group.ssh_sg.id,
      aws_security_group.es_sg.id
    ]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags = {
    Domain = var.elk_domain
  }

  access_policies = <<CONFIG
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": {
              "AWS": "*"
            },
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.elk_domain}/*"
        }
    ]
  }
    CONFIG
}
