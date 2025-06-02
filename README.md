#  Secure Cross-VPC Service Architecture on AWS  
**Powered by VPC Endpoints & Network Load Balancers**

![Status](https://img.shields.io/badge/deployment-secure-brightgreen)
![VPC](https://img.shields.io/badge/networking-private-orange)
![AWS](https://img.shields.io/badge/built_on-AWS-232F3E?logo=amazon-aws&logoColor=white)
![Architecture](https://img.shields.io/badge/type-B2B--SaaS-blueviolet)
![Security](https://img.shields.io/badge/privacy-zero--trust-critical)

This repo demonstrates a **secure and private architecture** for exposing services across VPCs — without relying on the public internet. Using **Interface VPC Endpoints**, **Network Load Balancers**, and **EC2**, it simulates a real-world B2B use case where a service provider exposes internal applications to a customer in a zero-trust, scalable way.

> Designed to meet enterprise-grade security requirements in regulated industries like fintech, healthcare, and B2B SaaS.

> Built by [Uzo Bolarinwa](#) as part of my AWS Solutions Architect portfolio.

---

##  Use Case

A **Service VPC** hosts an internal web application served by an EC2 instance. A **Customer VPC** accesses this service privately over an **Interface VPC Endpoint**, which forwards traffic to an **NLB** listening on TCP port 80.

This architecture reflects what you'd deploy in regulated industries or zero-trust environments where private connectivity is critical (e.g., fintech, healthcare, internal APIs for partners).

---

##  Architecture Overview

![AWS VPC Endpoint Architecture - Dark Mode](architecture/network-architecture-diagram.png)

---

##  Key AWS Services Used

| Service               | Purpose                                                                |
|-----------------------|---------------------------------------------------------------------|
| Amazon VPC            | Isolated networks for service provider and customer                 |
| EC2 Instances         | Hosts web application and curl-based testing                        |
| Internet Gateway      | Provides outbound access for EC2 bootstrapping                      |
| Network Load Balancer | Scalable, low-latency, high-throupghut traffic distribution point   |
| Interface VPC Endpoint| Private entry point from Customer VPC to NLB                        |
| Endpoint Service      | Enables service provider to control and approve customer access     |
| Route Tables / Subnets| Public subnet mapping for gateway and routing                       |
| Security Groups       | Access control (SSH, HTTP, HTTPS)                                   |

---

##  EC2 Bootstrapping
  The web server in the Service VPC is launched with a minimal `user-data` script to install Apache and serve a custom HTML welcome page.

This is done using a lightweight user-data script at instance launch.  
You can find the script here: [View user_data_webserver.sh](real-world-projects/secure-vpc-endpoint-architecture/scripts/user_data_webserver.sh)


---

## Security Highlights

This architecture emphasizes **secure-by-default** design through:

-  **VPC Isolation**: Service and customer workloads are deployed in fully isolated VPCs
-  **No Public Exposure**: Application traffic never leaves the AWS private space
-  **Controlled Access**: Service provider must **explicitly accept** endpoint requests
-  **Minimal Attack Surface**: Only TCP port 80 is exposed via NLB — no direct EC2 access
-  **Secure by Design**: Follows AWS best practices for private service exposure

---

##   Want to try this yourself? ...  
> Follow the [📂 Step-by-Step Deployment Guide](real-world-projects/secure-vpc-endpoint-architecture/guide/steps.md)


It includes:
- VPC + subnet creation
- EC2 setup with SSH & HTTP access
- NLB creation and registration
- Publishing an endpoint service
- Creating and connecting the customer interface endpoint
- Manual testing and cleanup steps

---

##  Skills You'll be Demonstrating...

- VPC design and subnet architecture  
- Internet gateway and route table setup  
- EC2 provisioning with user-data automation  
- Load balancing with NLB  
- Secure private access with Interface VPC Endpoints  
- Service-to-service architecture patterns  
- Zero-trust connectivity and resource teardown

---


## Cleanup Checklist

To avoid incurring charges, be sure to:

- Terminate all EC2 instances
- Delete the VPC Endpoint
- Delete the Endpoint Service
- Delete the NLB and target group
- Delete VPCs, Subnets, Routetables and Internet Gateways

---

## Lessons Learned
- Endpoint Services offer precise control over who connects
- Matching AZs is critical for health checks and traffic flow
- Private networking doesn’t mean limited flexibility — just better design

---

## Author & Intent

##  About Me

Built by **Uzo Bolarinwa** — AWS Solutions Architect focused on secure, scalable architecture patterns.
