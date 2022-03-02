/* Copyright (C) DevPanel Inc. - All Rights Reserved 
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Salim Lakhani <SL@DevPanel.com>, 2018 - 2021
 */

variable "infras_name" {
}

variable "database_password" {
  description = "password of root user of database"
}

variable "availability_zone" {
  description = "The Availability Zone in which to create your instance"
}

variable "blueprint_id" {
  description = "The ID for a virtual private server image"
}

variable "bundle_id" {
  type = string
  description = "(optional) describe your variable"
}

variable "region" {
}