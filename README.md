# Jenkins-EKS-Python

Part 1: Home Assignment - Project Scoping and Planning
Infrastructure Design and Requirements

I began the project by scoping out the requirements to understand the infrastructure needed to accomplish the goals. Based on the project needs, I concluded that the infrastructure should be split into two VPCs to ensure network isolation:

    VPC 1: Dedicated for the Supply Chain components.
    VPC 2: Dedicated for the Kubernetes (EKS) Cluster where the Python application will be deployed.

Key Components for the Infrastructure:

Based on this structure, I listed out the Terraform modules required to build and manage the infrastructure:

    VPC:
        One VPC will be for the Supply Chain (for non-cluster resources).
        One VPC will be for the Kubernetes cluster to ensure logical separation.

    Instances (EC2):
        A Jenkins Master instance will orchestrate the CI/CD pipelines.
        A Jenkins Agent instance will execute the build jobs.

    Security Groups:
        Separate security groups will be created for each instance (Jenkins master, agent) and the Kubernetes nodes to handle different ingress/egress rules.

    EKS Cluster:
        A fully managed Kubernetes cluster is required to host and scale the Python application. This includes defining the control plane and the worker nodes.

    Addons for EKS:
        To enhance the EKS cluster functionality, several addons such as CoreDNS, kube-proxy, and vpc-cni will be needed.

    IAM Roles:
        Multiple IAM roles will be created to support different services:
            Cluster IAM Role for the control plane.
            Node IAM Role for the worker nodes.
            Additional Roles for services like the Jenkins agent and cluster components.

Next Steps:

With this initial scoping, I can now proceed with creating the Terraform modules to automate the deployment of these components. I plan to modularize the infrastructure, ensuring reusability and scalability for future needs.