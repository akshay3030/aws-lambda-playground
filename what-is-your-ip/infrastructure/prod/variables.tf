variable "name" {
  default = "what-is-your-ip"
}

variable "aws_region" {
  default = "us-west-2"
}

#variable "apex_function_what_is_your_ip" {}

variable "cf_config" {
  default = {
    price_class = "PriceClass_200"
  }
}
