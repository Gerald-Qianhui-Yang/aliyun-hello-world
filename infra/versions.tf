terraform {
  required_version = ">= 1.5.0"

  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.212.0"
    }
  }

  backend "oss" {
    bucket   = "tf-state-aliyun-hello-world"
    prefix   = "terraform/state"
    region   = "cn-shanghai"
    encrypt  = true
  }
}
