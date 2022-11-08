APP_NAME="custom_app"

variable "FRAPPE_VERSION" {default = "13"}
variable "ERPNEXT_VERSION" {default = "13"}
  # frappe v13 only works with NODE_VERSION=14
variable "NODE_VERSION" {default = "14"}


group "default" {
    targets = ["clonedapps","backend", "frontend"]
}

target "clonedapps" {
    dockerfile = "onlycloner.Dockerfile"
    tags = ["onlycloner:latest"]
    args = {
      "CLONED_APPS_REPOS" = "https://github.com/michaeleino/erpnext-customstyle.git https://github.com/michaeleino/erpnext-persistent_defaults.git"
    }
}

target "backend" {
    contexts = {
    base = "target:clonedapps"
    }
    dockerfile = "backend.Dockerfile"
    tags = ["custom_app/worker:latest"]
    args = {
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "APPS_NAME" = "erpnext-customstyle erpnext-persistent_defaults"
    }
}

target "frontend" {
    contexts = {
    base = "target:clonedapps"
    }
    dockerfile = "frontend.Dockerfile"
    tags = ["custom_app/nginx:latest"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "NODE_VERSION" = NODE_VERSION
    }
}
