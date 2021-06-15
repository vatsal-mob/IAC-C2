# covenant-c2

## Pre-req

* Digital Ocean token (get it from settings-> API)
* terraform installed in your local machine
* SSH key pair 
* cloudflare token, zone id
* basic mind-set

Create a variable.tf file with the following variables:
variable "cloudflare_zone" {}  - refers to the domain zone_id in cloudflare
variable "cloudflare_token" {} - cloudflare global api token
variable "cloudflare_email" {} - your cloudflare email id
variable "do_token" {} - DO token
