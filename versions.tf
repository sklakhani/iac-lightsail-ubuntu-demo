/* Copyright (C) DevPanel Inc. - All Rights Reserved 
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Salim Lakhani <SL@DevPanel.com>, 2018 - 2021
 */
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.52.0"
    }
  }
  required_version = ">= 0.13"
}