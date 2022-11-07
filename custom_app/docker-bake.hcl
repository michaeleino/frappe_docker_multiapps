APP_NAME="custom_app"

variable "FRAPPE_VERSION" {default = "version-13"}
variable "ERPNEXT_VERSION" {default = "version-13"}

group "default" {
    targets = ["backend", "frontend"]
}

target "backend" {
    dockerfile = "backend.Dockerfile"
    tags = ["custom_app/worker:latest"]
    args = {
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "APP_NAME" = APP_NAME
      "MULTIAPPS" = "https://github.com/michaeleino/erpnext-customstyle.git https://github.com/michaeleino/erpnext-persistent_defaults.git"
      "APPS" = "erpnext-customstyle erpnext-persistent_defaults"
    }
}

target "frontend" {
    dockerfile = "frontend.Dockerfile"
    tags = ["custom_app/nginx:latest"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "APP_NAME" = APP_NAME
    }
}
