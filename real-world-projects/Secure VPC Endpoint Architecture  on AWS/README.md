#  Secure Cross-VPC Service Architecture on AWS using AWS VPC Endpoints & NLB

This repo demonstrates a simple architecture pattern to securely expose services across VPCs without using the public internet. It simulates a B2B use case where a service provider hosts an internal web application that must be accessed privately by a customer — using an **Interface VPC Endpoint** backed by a **Network Load Balancer (NLB)**.

# 🔐 Secure Cross-VPC Service Architecture using AWS VPC Endpoints & NLB

This project demonstrates how to architect a secure, private connection between a service provider and a customer VPC using **Interface VPC Endpoints**, **Network Load Balancer (NLB)**, and **EC2 instances** in isolated public subnets. Designed to simulate a real-world B2B SaaS scenario, this pattern allows the service provider to expose internal applications securely without internet-facing APIs.

> 🧠 Built to demonstrate secure connectivity and service exposure across VPCs — ideal for regulated or zero-trust environments.

>  Designed and deployed as part of my AWS Solutions Architect portfolio to highlight private networking, VPC endpoint services, and secure architecture design.

---

##  Use Case

A **Service VPC** hosts an internal web application served by an EC2 instance. A **Customer VPC** accesses this service privately over an **Interface VPC Endpoint**, which forwards traffic to an **NLB** listening on TCP port 80.

This architecture reflects what you'd deploy in regulated industries or zero-trust environments where private connectivity is critical (e.g., fintech, healthcare, internal APIs for partners).

---

##  Architecture Diagram

![AWS VPC Endpoint Architecture - Dark Mode](architecture/network-architecture-diagram.png)

---

##  Key AWS Services Used

| Service               | Role                                                                |
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

##  Server Bootstrapping

The EC2 instance in the **Service VPC** is auto-configured to:
- Install and start Apache (`httpd`)
- Serve a basic HTML page confirming deployment

This is done using a lightweight user-data script at instance launch.  
You can find the script here: [`scripts/user_data_webserver.sh`](scripts/user_data_webserver.sh)

---

## Security Highlights

This architecture emphasizes secure connectivity through:

-  **VPC Isolation**: Service and customer workloads are deployed in fully isolated VPCs
-  **No Public Exposure**: Application traffic never leaves the AWS private backbone
-  **Controlled Access**: Service provider must **explicitly accept** endpoint requests
-  **Minimal Attack Surface**: Only TCP port 80 is exposed via NLB — no direct EC2 access
-  **Secure by Design**: Follows AWS best practices for private service exposure

---

##  Like to try your hands at this ...
You can find the steps here: [`guide/steps`](guide/steps)

---

##  Skills You'll be Demonstrating...

- VPC design and public/private subnetting
- Internet Gateway and route table configuration
- EC2 bootstrapping with user-data scripts
- Load balancing with NLB for high throughput
- Interface VPC Endpoints and Endpoint Service management
- Private DNS resolution testing with curl from customer EC2
- Manual validation and teardown for clean environments

---

##  Setup Summary

1. Create **Service VPC** + public subnet + EC2 instance
2. Attach Internet Gateway, route table, and bootstrap Apache
3. Create **Network Load Balancer** and register EC2 as target
4. Publish **Endpoint Service** with acceptance required
5. Create **Customer VPC** + subnet + EC2 + Internet Gateway
6. Create **Interface Endpoint** to connect to NLB
7. SSH into customer EC2 and verify via `curl <VPC Endpoint IP>`
8. Cleanup all AWS resources

---

## Cleanup Checklist

To avoid incurring charges, be sure to:

- Terminate all EC2 instances
- Delete the VPC Endpoint
- Delete the Endpoint Service
- Delete the NLB and target group
- Delete both VPCs and Internet Gateways

---

## Lessons Learned
- VPC Endpoints using NLBs enable scalable, private service sharing
- IAM and SGs must be tightly controlled to avoid exposing internal services
- Availability Zones must match across Endpoint + NLB + EC2 for health checks

---

## Author & Intent

This project was built by **Uzo Bolarinwa** as part of a portfolio to demonstrate secure networking patterns using AWS services. It’s intended to highlight deep understanding of multi-VPC connectivity, private service exposure, and architecture best practices.

Interested in working together? Let’s connect at [LinkedIn](#).

---
