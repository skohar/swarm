provider "aws" {
    region = "${var.region}"
}

resource "aws_launch_configuration" "whale" {
    name = "${var.launch_configuration_name}"
    instance_type = "${var.instance_type}"
    image_id = "${var.image_id}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_groups}"]
    associate_public_ip_address = "true"
    enable_monitoring = "true"
    root_block_device = {
        volume_type = "${var.volume_type}"
        volume_size = "${var.volume_size}"
        delete_on_termination = "true"
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "whale" {
    name = "${var.auto_scaling_group_name}"
    launch_configuration = "${aws_launch_configuration.whale.name}"
    availability_zones = ["${var.availability_zones}"]
    vpc_zone_identifier = ["${var.subnet_id}"]
    load_balancers = ["${var.load_balancers}"]
    health_check_grace_period = 300
    health_check_type = "ELB"
    min_size = "${var.min_size}"
    desired_capacity = "${var.desired_capacity}"
    max_size = "${var.max_size}"
    lifecycle {
        create_before_destroy = true
    }
}
