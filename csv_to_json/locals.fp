locals {
  csv_data = <<-CSV
    local_id,instance_type,ami
    foo1,t2.micro,ami-54d2a63b
    foo2,t2.micro,ami-54d2a63b
    foo3,t2.micro,ami-54d2a63b
    bar1,m3.large,ami-54d2a63b
  CSV
}
