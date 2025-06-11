<p align="center">
  <img src="logo-transparent.png" alt="Project Logo" width="200"/>
</p>

# 🛰️ Secure Cross-VPC Service Architecture on AWS  
**Exposing Services Privately using Interface VPC Endpoints + NLB**


![Status](https://img.shields.io/badge/deployment-secure-brightgreen)
![VPC](https://img.shields.io/badge/networking-private-orange)
![AWS](https://img.shields.io/badge/built_on-AWS-232F3E?logo=amazon-aws&logoColor=white)
![Architecture](https://img.shields.io/badge/type-B2B--SaaS-blueviolet)
![Security](https://img.shields.io/badge/privacy-zero--trust-critical)


> A private service architecture that simulates secure B2B access across accounts — ideal for fintech, healthcare, or internal partner APIs.  
> ✅ Uses **VPC Endpoints**, **NLB**, and **EC2** with minimal public exposure.  
> ✅ Infrastructure created manually with AWS Console for demonstrative hands-on skills.

---

## 📌 What This Project Demonstrates
-  Zero-trust exposure of internal services
-  Interface VPC Endpoints backed by NLB
-  Endpoint Service and manual approval flow
-  EC2 provisioning with Apache + user-data
-  Fully private connectivity between VPCs — no public IP required

<br><br>

---


## 🧭 Architecture Overview

This architecture simulates a secure, zero-trust, cross-VPC connection where a **Customer VPC** connects privately to a **Service VPC** without touching the public internet.

<p align="center">
  <img src="architecture/network-architecture-diagram.png" alt="AWS VPC Architecture Diagram" width="700"/>
</p>


![AWS VPC Endpoint Architecture - Dark Mode](architecture/network-architecture-diagram.png)

<br><br>  

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

<br><br>

---

##  EC2 Bootstrapping
  The web server in the Service VPC is launched with a minimal `user-data` script to install Apache and serve a custom HTML welcome page.

This is done using a lightweight user-data script at instance launch.  
You can find the script here: [`Script`](scripts/user_data_webserver.sh)

---

## Security Highlights

This architecture emphasizes **secure-by-default** design through:

-  **VPC Isolation**: Service and customer workloads are deployed in fully isolated VPCs
-  **No Public Exposure**: Application traffic never leaves the AWS private space
-  **Controlled Access**: Service provider must **explicitly accept** endpoint requests
-  **Minimal Attack Surface**: Only TCP port 80 is exposed via NLB — no direct EC2 access
-  **Secure by Design**: Follows AWS best practices for private service exposure


<br><br>

---

## 🔧 Try It Yourself
## 📚 Deployment & Testing
Please see the [Deployment Guide](./deployment-guide.md) for instructions on:
It includes:
- Service VPC with EC2 and NLB
- Endpoint Service setup
- Customer VPC + Interface Endpoint
- Manual approval and validation via curl
  
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


<br><br>

## License
### Author
**Uzo **

## License
This project is licensed under the MIT License.

![Author](screenshots/logo-transparent.png)
---
