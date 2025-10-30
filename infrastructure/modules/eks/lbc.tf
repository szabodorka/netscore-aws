data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lbc_pod_identity_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "lb_controller" {
  name               = "${var.project_name}-lb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.lbc_pod_identity_trust.json
}

resource "aws_iam_policy" "lb_controller" {
  name   = "AWSLoadBalancerControllerIAMPolicy-v2_13_4"
  policy = file("${path.module}/lbc_policy.json")
}

resource "aws_iam_role_policy_attachment" "lb_controller_policy" {
  role       = aws_iam_role.lb_controller.name
  policy_arn = aws_iam_policy.lb_controller.arn
}

resource "aws_eks_pod_identity_association" "lb_controller" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.lb_controller.arn
}

resource "helm_release" "lb_controller" {
  name            = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-load-balancer-controller"
  namespace       = "kube-system"
  timeout         = 900
  wait            = true
  wait_for_jobs   = true
  atomic          = true # in case of failure, auto-uninstall will apply
  cleanup_on_fail = true

  set {
      name  = "clusterName"
      value = var.cluster_name
  }
  set {
      name  = "serviceAccount.create"
      value = "true"    
  }
  set {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"    
  }
  set {
      name = "vpcId"
      value = var.vpc_id    
  }
  set {
      name = "region"
      value = var.region    
  }

  depends_on = [
    aws_iam_role_policy_attachment.lb_controller_policy,
    aws_eks_pod_identity_association.lb_controller,
    aws_eks_addon.pod_identity_agent,
    aws_eks_node_group.netscore_nodes
  ]
}