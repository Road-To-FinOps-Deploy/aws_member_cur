variable "bucket_name" {
  default = "costbucketmcur"
}

variable "region" {
  default = "eu-west-1"
}

variable "timeunit" {
  type = string
  description = "granularity of cur"
  default = "HOURLY"
}

variable "athena_table_name" {
  default = "MemberCUR"
}

variable "env" {
  default = ""
}

# cloudwatch metric alarm 
variable "cloudwatch_metric_alarm_statistic" {
  default = "Minimum"
}

variable "cloudwatch_metric_alarm_threshold" {
  default = "1" //1 error
}

variable "cloudwatch_metric_alarm_period" {
  default = "10800" //3 hours in secs
}

variable "cloudwatch_metric_alarm_comparison_operator" {
  default = "GreaterThanOrEqualToThreshold"
}

variable "cloudwatch_metric_alarm_metric_name" {
  default = "Errors"
}

variable "cloudwatch_metric_alarm_evaulation_periods" {
  default = "1"
}