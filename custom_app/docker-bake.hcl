APP_NAME="git.stmaryztn.net/stmaryztn/erp.stmaryztn"

variable "FRAPPE_VERSION" {default = "14.20.0"}
variable "ERPNEXT_VERSION" {default = "14.11.0"}
variable "MULTI_APPS_REPOS" {default = "https://github.com/michaeleino/erpnext-persistent_defaults.git"}
# frappe v13 only works with NODE_VERSION=14 & frappe v14 wants NODE_VERSION=16
variable "NODE_VERSION" {default = "16"}


group "default" {
    targets = ["assets","backend", "frontend"]
}

target "assets" {
    dockerfile = "assetshelper.Dockerfile"
    #tags = ["frappe_assets:f.v${FRAPPE_VERSION}_e.v${ERPNEXT_VERSION}"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "NODE_VERSION" = NODE_VERSION
      "MULTI_APPS_REPOS" = MULTI_APPS_REPOS
    }
}

target "backend" {
    contexts = {
    base = "target:assets"
    }
    dockerfile = "backend.Dockerfile"
    tags = ["${APP_NAME}/worker:f.v${FRAPPE_VERSION}_e.v${ERPNEXT_VERSION}"]
    output = ["type=registry"]
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
    tags = ["${APP_NAME}/nginx:f.v${FRAPPE_VERSION}_e.v${ERPNEXT_VERSION}"]
    output = ["type=registry"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "NODE_VERSION" = NODE_VERSION
    }
}
