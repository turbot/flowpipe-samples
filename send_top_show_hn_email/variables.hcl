# TODO: Remove all defaults once variables can be passed to mod dependencies properly
variable "sendgrid_api_key" {
  type        = string
  description = "The SendGrid access api_key to authenticate to the OpenAI APIs, e.g., `SG.ABCDEFGHIJ-a1b2c3d4e5f6g7h8i9j10k11l12m13n14o15p16q17r18s19t20u21v`."
  // TODO: Add once supported
  // sensitive  = true
}
