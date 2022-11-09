APP_NAME="stmaryztn/erp.stmaryztn"

variable "FRAPPE_VERSION" {default = "13"}
variable "ERPNEXT_VERSION" {default = "13"}
# frappe v13 only works with NODE_VERSION=14 & frappe v14 wants NODE_VERSION=16
variable "NODE_VERSION" {default = "14"}


group "default" {
    targets = ["assets","backend", "frontend"]
}

target "assets" {
    dockerfile = "assetshelper.Dockerfile"
    tags = ["frappe_assets:f.${FRAPPE_VERSION}_e.${ERPNEXT_VERSION}"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "NODE_VERSION" = NODE_VERSION
      "MULTI_APPS_REPOS" = "https://github.com/michaeleino/erpnext-customstyle.git https://github.com/michaeleino/erpnext-persistent_defaults.git"
    }
}

target "backend" {
    contexts = {
    base = "target:assets"
    }
    dockerfile = "backend.Dockerfile"
    tags = ["${APP_NAME}/worker:f.${FRAPPE_VERSION}_e.${ERPNEXT_VERSION}"]
    args = {
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "FRAPPE_VERSION" = FRAPPE_VERSION
    }
}

target "frontend" {
    contexts = {
    base = "target:assets"
    }
    dockerfile = "frontend.Dockerfile"
    tags = ["${APP_NAME}/nginx:f.${FRAPPE_VERSION}_e.${ERPNEXT_VERSION}"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "NODE_VERSION" = NODE_VERSION
    }
}
