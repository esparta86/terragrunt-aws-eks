resource "null_resource" "call-aws-roles" {
  provisioner "local-exec" {
    # interpreter = [ "/bin/bash","-c" ]
    working_dir = "${path.module}"

    command = <<EOF

    cat ${path.module}/labels-patch.yaml && ls -l
    EOF
    quiet = false


  }
}

# output "null" {
#   value = null_resource.call-aws-roles
# }

data "template_file" "patch_labels" {
  template = "${file("${path.module}/patch-datadog.tpl")}"
  # vars = {
  #   consul_address = "${aws_instance.consul.private_ip}"
  # }
}

resource "local_file" "patch_labels_dd" {
  filename = "${path.module}/labels-patch.yaml"
  content = "${data.template_file.patch_labels.rendered}"
}
