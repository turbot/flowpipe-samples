mod "demo_inputs" {
  title = "Demo Flowpipe inputs"
  require {
    mod "github.com/turbot/flowpipe-mod-aws" {
      version = "*"
    }
    mod "github.com/turbot/flowpipe-mod-slack" {
      version = "*"
    }
  }
}