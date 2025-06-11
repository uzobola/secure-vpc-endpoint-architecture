<p align="center">
  <img src="logo-transparent.png" alt="Project Logo" width="200"/>
</p>

# 🛰️ Secure Cross-VPC Service Architecture on AWS  
**Exposing Services Privately using Interface VPC Endpoints + NLB**

[![Deployment Status](https://img.shields.io/badge/deployment-secure-brightgreen)](#)
[![Networking Model](https://img.shields.io/badge/networking-private-orange)](#)
[![Platform](https://img.shields.io/badge/built_on-AWS-232F3E?logo=amazon-aws&logoColor=white)](#)
[![Architecture Type](https://img.shields.io/badge/type-B2B--SaaS-blueviolet)](#)
[![Privacy](https://img.shields.io/badge/privacy-zero--trust-critical)](#)

This portfolio project demonstrates a **secure and private architecture** for exposing services across VPCs — without relying on the public internet. It simulates a real-world B2B use case using:

- **Interface VPC Endpoints**
- **Network Load Balancers**
- **EC2 Instances**

> Built by [Uzo Bolarinwa](https://www.linkedin.com/in/uzobolarinwa) as part of my AWS Solutions Architect portfolio.  
> Designed to meet enterprise-grade security needs in fintech, healthcare, and SaaS environments.

---

## 🔍 Use Case

A **Service VPC** hosts an internal web application served by an EC2 instance. A **Customer VPC** accesses this service privately over an **Interface VPC Endpoint**, which forwards traffic to an NLB listening on port `80`.

This simulates what you'd deploy in **zero-trust** environments where **private connectivity** is mandatory.

---

## 🧠 Architecture Diagram

![AWS VPC Endpoint Architecture - Dark Mode](architecture/network-architecture-diagram.png)

---

## 🛠️ Key AWS Services

| Service                | Purpose                                                                 |
|------------------------|--------------------------------------------------------------------------|
| Amazon VPC             | Network isolation for Service and Customer VPCs                         |
| EC2                    | Hosts web application and test clients                                  |
| Internet Gateway       | For initial EC2 bootstrapping                                           |
| Network Load Balancer  | Traffic forwarding layer for endpoint service                           |
| Interface VPC Endpoint | Customer's private entry point to the service                           |
| Endpoint Service       | Allows Service VPC to control & approve endpoint connections            |
| Route Tables/Subnets   | Handles routing & subnet segmentation                                   |
| Security Groups        | Restricts traffic to HTTP & SSH only                                    |

---

## ⚙️ EC2 Bootstrapping

At launch, the EC2 instance uses a minimal `user-data` script to install Apache and serve a static HTML page.

📁 [`scripts/user_data_webserver.sh`](scripts/user_data_webserver.sh)

---

## 🛡️ Security Highlights

- **VPC Isolation** — Full separation between Service and Customer VPCs  
- **Zero Public Exposure** — Traffic stays within the AWS private network  
- **Explicit Access Control** — Endpoint requests must be approved by provider  
- **Minimal Attack Surface** — Only port `80` exposed via NLB  
- **Secure-by-Design** — No public IPs, NATs, or peering needed

---

## 🚀 Try It Yourself

📘 Follow the [Deployment Guide](deployment-guide.md) to replicate this architecture.  
You’ll set up:

- Service VPC (EC2, NLB, Endpoint Service)
- Customer VPC (EC2, Interface VPC Endpoint)
- Manual endpoint approval + test with `curl`

---

## 💡 Skills You’ll Practice

- Designing secure VPCs and subnets  
- EC2 provisioning with automation  
- NLB & Endpoint Service creation  
- Cross-VPC communication without internet  
- Working with Interface Endpoints & approval workflows  
- Zero-trust networking models  

---

## 🧹 Cleanup Checklist

To avoid unnecessary charges, please don’t forget to:

- Terminate EC2 Instances  
- Delete VPC Endpoints and Services  
- Remove NLB + target groups  
- Delete custom VPCs and subnets  

---

## 📘 Lessons Learned

- AZ alignment is essential for endpoint ↔ NLB routing  
- Endpoint Services offer tight control and visibility  
- Secure connectivity is not complex — just deliberate  

---
---

<br><br>

## License
### Author
**Uzo **
🛠️ [Other Projects](https://github.com/uzobola?tab=repositories)

## License
This project is licensed under the MIT License.

![Author](screenshots/logo-transparent.png)
---
