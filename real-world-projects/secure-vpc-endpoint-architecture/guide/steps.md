#  Step-by-Step Deployment Guide  
**Project:** Secure Cross-VPC Service Architecture using AWS VPC Endpoints & NLB

This guide provides clear steps to replicate the architecture in this repo. It walks you through building a secure, private connection between a **Service VPC** and a **Customer VPC** using AWS services like EC2, NLB, and Interface VPC Endpoints.

> Prereqs: It'll be nice for you to have basic familiarity with the AWS Console, IAM, VPCs, and EC2 setup.

---

##  Table of Contents
- [Step-by-Step Deployment Guide](#step-by-step-deployment-guide)
  - [Table of Contents](#table-of-contents)
  - [Phase 1: Service VPC Setup](#phase-1-service-vpc-setup)
  - [Phase 2: Network Load Balancer \& Endpoint Service](#phase-2-network-load-balancer--endpoint-service)
  - [Phase 3: Customer VPC Setup](#phase-3-customer-vpc-setup)
  - [Phase 4: VPC Endpoint in the Customer VPC \& Test for Connectivity](#phase-4-vpc-endpoint-in-the-customer-vpc--test-for-connectivity)


## Phase 1: Service VPC Setup

  1. **Create a Service Provider VPC**
   - CIDR block: `20.0.0.0/16`
   - Name: `Service_Network`
       - In the AWS Console, ensure your region is set to US East (N. Virginia) (us-east-1).
       - From the top navigation bar, go to Services → under Networking & Content Delivery, click VPC.
       - In the left-hand menu, click Your VPCs, then select Create VPC.
       - Configure the VPC:
       - Name tag: Service_Network
       - IPv4 CIDR block: 20.0.0.0/16
       - Leave all other settings as default.
       - Click on create VPC.

Result: You have created a VPC named Service_Network with CIDR block 20.0.0.0/16.



2. **Create a public subnet in the Service Provider VPC**
   - CIDR: `20.0.1.0/24`
   - AZ: `us-east-1a`
        - In the VPC Dashboard, select Subnets from the left-hand menu.
        - Click Create Subnet.
        - Configure the subnet:
            - VPC ID: Select Service_Network
            - Subnet name: Service_Public_subnet
            - Availability Zone: us-east-1a
            - IPv4 CIDR block: 20.0.1.0/24
       - Click Create Subnet.

Result: You have created a public subnet named Service_Public_subnet in the us-east-1a Availability Zone within the Service_Network VPC.



3. **Create and attach an Internet Gateway**
   - In the VPC Dashboard, select Internet Gateways from the menu on the left.
   - Click Create Internet Gateway
   - Configure the gateway:
        - Name tag: Service_IGW
   - Click Create Internet Gateway
   - After it is created, select the newly created Service_IGW.
   - Click Actions → Attach to VPC.
   - Under Available VPCs, select Service_Network.
   - Click Attach Internet Gateway.

Result: You have created an internet gateway Service_IGW  and attached it to your Service_Network VPC.



4. **Create a route table and associate it with the subnet**
   - Add route: `0.0.0.0/0` → Internet Gateway
        -  From the VPC Dashboard, select Route Tables from the menu on the left.
        -  Click Create route table.
        -  Configure the route table:
                - Name tag: Service_PublicRT
                - VPC: Select Service_Network
        - Click Create route table.
        - After its created, select the route table named Service_PublicRT.
        - Scroll down to the Subnet associations tab and click Edit subnet associations.
        - Select the checkbox for Service_Public_subnet.
        - Click Save associations.

Result: You have created a route table named Service_PublicRT and associated it with the Service_Public_subnet public subnet.



5. **Add a Public Route to the Route Table**
    - In the VPC Dashboard, go to Route Tables and select Service_PublicRT.
    - Scroll down to the Routes tab and click Edit routes.
    - Click Add route and configure the following:
        - Destination: 0.0.0.0/0
        - Target: Select Internet Gateway, then choose Service_IGW from the dropdown
    - Click Save changes.

Result: The route table Service_PublicRT now allows public internet access via the Service_IGW.




6. **Launch EC2 instance (Amazon Linux 2) in the Service VPC (Web Server)**
   - Subnet: `Service_Public_subnet`
   - Public IP: Enabled
   - User-data: [See `scripts/user_data_webserver.sh`](../scripts/user_data_webserver.sh)
        - Navigate to EC2 → EC2 under the Compute section.
        - From them menu on the left, click Instances, then click Launch Instances.
        - Under Name and tags:
                - Name: Webserver1
                - Under Application and OS Images (Amazon Machine Image):
                - Quick Start tab → Select Amazon Linux
                - Choose Amazon Linux 2 AMI
        - Under Instance Type:
                - Select t2.micro (eligible for free tier)
        - Under Key pair (login): 
               - Click Create new key pair
               - Key pair name: public-key
               - Key pair type: RSA
               - Private key file format: .pem or .ppk
               - Click Create key pair
        - Under Network settings, click Edit and configure:
                - VPC: Select Service_Network
                - Subnet: Select Service_Public_subnet
                - Auto-assign public IP: Enable
        - Firewall (security group): Select Create a new security group
                - Security group name: Webserver_sg
                - Description: Security group for Webserver
                - Add inbound rules:
                    - Type: SSH — Source: Anywhere (0.0.0.0/0)
                    - Type: HTTP — Source: Anywhere (0.0.0.0/0)
                    - Type: HTTPS — Source: Anywhere (0.0.0.0/0)
                - 
        - Under Advanced details → User data, paste the script to install and configure Apache:
                - User-data: [See `scripts/user_data_webserver.sh`](../scripts/user_data_webserver.sh)
        - Leave the remaining settings as default and click Launch instance.

        - Go to the Instances page and wait for Webserver1 to enter the running state.

Result: A web server EC2 instance named Webserver1 is launched and publicly accessible over HTTP.

[ Back to Top](#-step-by-step-deployment-guide)


---

## Phase 2: Network Load Balancer & Endpoint Service

7. **Create a Network Load Balancer**
   - Type: Internet-facing
   - Listener: TCP port 80
   - Target group: Register Service EC2 instance
       -  In the AWS Console, navigate to EC2 → Load Balancing → Load Balancers from the left-hand menu.
       -  Click Create Load Balancer.
       -  Under Load Balancer Type, choose Network Load Balancer and click Create.
       -  Configure the load balancer:
             -  Name: MyNetwork-LB
             -  Scheme: Internet-facing
             -  VPC: Select Service_Network
             -  Security groups: Select Webserver_sg
             -  Availability Zones: Check us-east-1a
             -  Listeners:
                -  Protocol: TCP
                -  Port: 80
            -  Under Tags, add:
               -  Key: Name
               -  Value: MyNetwork-LB
-  

7b. **Create Target Group**
   - In the next step, click Create Target Group (opens in a new tab).
   - Configure the target group:
       - Target type: Instance
       - Name: MyNetwork-TG
       - Port: 80
       - Protocol: TCP
       - Health check interval: 10 seconds
       - Click Next and select the instance:

    - Choose Webserver1
    - Click Include as pending below
    - Click Create target group

7c. **Finalize Creation of Network Load Balancer**
   - Go back to the Load Balancer tab.
   - Under the default listener settings, select MyNetwork-TG as the target group.
   - Click Create Load Balancer.
   - Navigate to Target Groups in the EC2 Console.
   - Select the Targets tab and wait for the registered target (Webserver1) to become healthy.
   - Go back to Load Balancers, select MyNetwork-LB, and copy the DNS name from the Description tab.
   - Open the DNS name in your browser — you should see the welcome page:
  
 Result: You have now created a Network Load Balancer named MyNetwork-LB that is deployed and serving traffic to your EC2 instance.


8. **Create VPC Endpoint Service**
   - Attach NLB
   - Enable “Acceptance required”
   - Navigate to Services → VPC → from the menu on the left, click Endpoint Services under Virtual Private Cloud.
   - Click Create Endpoint Service.
   - Configure the endpoint service:
       - Associate Load Balancers: Check the box for MyNetwork-LB
       - Acceptance required: Please make sure this option is enabled
         (This means the service provider (you) must approve any endpoint connection requests from consumers (customers))
       - Click Create Endpoint Service.
       - After creation, under the Details section:
            - Copy the Service name (e.g., com.amazonaws.vpce.service-xxxxxxxx)
            - Please save this — you'll need it when creating the VPC Endpoint in the customer account.

Result: You’ve published an Endpoint Service backed by MyNetwork-LB, requiring acceptance for each connecting VPC Endpoint.

[ Back to Top](#-Step-by-Step-deployment-guide)


---

##  Phase 3: Customer VPC Setup

9. **Create a second VPC**
   - CIDR: `10.0.0.0/16`
   - Name: `Customer_VPC`
     - In the AWS Console, make sure your region is still set to US East (N. Virginia).
     - Navigate to VPC.
     - In the menu on the left , select Your VPCs, then  select Create VPC.
     - Configure the VPC:
        -   Name tag: Customer_Network
        -   IPv4 CIDR block: 10.0.0.0/16
        - Leave all other settings as default.
    - Click Create VPC.

Result: You have created a new VPC named Customer_Network  with CIDR block 10.0.0.0/16.



10. **Create a public subnet to the Customer VPC**
   - CIDR: `10.0.1.0/24`
   - AZ: `us-east-1a`
        - In the VPC Dashboard, click on Subnets from the left-hand menu.
        - Click Create Subnet.
        - Configure the subnet:
            - VPC ID: Select Customer_Network
            - Subnet name: Customer_Public_subnet
            - Availability Zone: us-east-1a
            - IPv4 CIDR block: 10.0.1.0/24
            - Click Create Subnet.

Result: You have created a public subnet named Customer_Public_subnet in us-east-1a within the Customer_Network VPC.



11.   **Create and attach an Internet Gateway to the Customer VPC**
    - In the VPC Dashboard, select Internet Gateways from the left-hand menu.
    - Click Create Internet Gateway.
    - Configure the gateway:
        - Name tag: Customer_IGW
        - Click Create Internet Gateway.
    - After creation, select the newly created Customer_IGW.
    - Click Actions → Attach to VPC.
    - From the dropdown, select Customer_Network.
    - Click Attach Internet Gateway.

Result: The internet gateway Customer_IGW is now attached to your Customer_Network VPC.



12.  **Create a Public Route Table and Associate It with the Customer Subnet**
   - Add route: `0.0.0.0/0` → Internet Gateway
       - From the VPC Dashboard, click on Route Tables from the left-hand menu.
       - Click Create route table.
       - Configure the route table:
            - Name tag: Customer_PublicRT
            - VPC: Select Customer_Network
      - Click Create route table.
      - After creation, select the route table named Customer_PublicRT.
      - Scroll down to the Subnet associations tab and click Edit subnet associations.
      - Select the checkbox for Customer_Public_subnet.
      - Select Save associations.

Result: You have created the route table Customer_PublicRT and associated it with the Customer_Public_subnet.


12.  **Add a Public Route to the Customer Route Table**
    - In the VPC Dashboard, select Route Tables from the left-hand menu.
    - Locate and select the route table named Customer_PublicRT.
    - Scroll down to the Routes tab and click Edit routes.
    - Click Add route and configure:
        - Destination: 0.0.0.0/0
        - Target: Choose Internet Gateway, then select Customer_IGW
    - Click Save changes.

Result: You have configured the route table Customer_PublicRT to allow outbound internet traffic via Customer_IGW.

  

13.  **Launch an EC2 instance in the Customer VPC**
   - Subnet: `Customer_Public_subnet`
   - Public IP: Enabled
   - Allow SSH access
        - In the AWS Console, navigate to Services → EC2 under the Compute section.
        - From the left-hand menu, click Instances, then click Launch Instances.
        - Under Name and tags:
            - Name: Customer_EC2
        - Under Application and OS Images (Amazon Machine Image):
            - Select the Quick Start tab
            - Choose Amazon Linux 2 AMI
            - Under Instance Type:
            - Select t2.micro
        - Under Key pair (login):
            - Choose the previously created key pair: public-key
        - Under Network Settings, click Edit and configure:
            - VPC: Select Customer_Network
            - Subnet: Select Customer_Public_subnet
            - Auto-assign public IP: Enable
        - Firewall (security groups):
            - Select Create a new security group
            - Security group name: Customer_EC2_SG
            - Description: Security group for Customer EC2
            - Add the following inbound rules:
                - Type: SSH — Source: Anywhere (0.0.0.0/0)
                - Type: HTTP — Source: Anywhere (0.0.0.0/0)
                - Type: HTTPS — Source: Anywhere (0.0.0.0/0)
            - Leave all other settings as default and click Launch Instance.
            - Go to the Instances page and wait for Customer_EC2 to reach the running state.
            - Note the public IPv4 address — you’ll use it to connect via SSH later.

Result: You have created a test EC2 instance named Customer_EC2 which is now running in the Customer_Network VPC with public access enabled.

[ Back to Top](#-Step-by-Step-deployment-guide)

---



##  Phase 4: VPC Endpoint in the Customer VPC & Test for Connectivity

14. **Create Interface Endpoint in Customer VPC**
   - Use the Endpoint Service name copied from Phase 2
   - Associate with Customer subnet  (Customer_Public_subnet)
   - Attach Customer EC2’s Security Group (Customer_EC2_SG)
       - Navigate to Services → VPC.
       - From the menu on the left, select Endpoints under Virtual Private Cloud.
       - Click Create Endpoint.
       - Configure the endpoint:
           - Service category: Select Endpoint services that use NLBs and GWLBs
           - Service name: Paste the Service name you copied from the endpoint service created in Task 9
           - Click Verify service
           - You should see the message:  "Service name verified"
       - Under VPC: Select Customer_Network
           - Subnets: Choose us-east-1a (same AZ as your EC2 and NLB)
           - IP address type: IPv4
           - Security group: Select Customer_EC2_SG
       - Click Create Endpoint
       - After creation, the endpoint status will show as Pending acceptance.
    
15. **Go to Service VPC → Endpoint Service → Accept Connection**
    - Navigate back to Endpoint Services in the Service VPC,
       - Select your endpoint service
       - Click the Endpoint Connections tab
       - Select the pending request and click Actions → Accept Endpoint Connection Request
       - Type accept and confirm
       - Wait 3–4 minutes and return to Endpoints under VPC.
       - The endpoint status will change from Pending to Available

Result: The customer EC2 can now privately access the web server in the service VPC through the VPC Endpoint.


16. **Test the Connectivity from Customer EC2 to the Service via VPC Endpoint**
    - Navigate to EC2 → Instances.
    - Locate Customer_EC2 and copy its public IPv4 address.

17. **SSH into Customer EC2**
    - Open your terminal and SSH into the Customer EC2 instance:
        ```bash
        ssh -i /path/to/public-key.pem ec2-user@<Customer_EC2_Public_IP>
    - Once you are connected, switch to the root user:
        sudo -s
    - Locate the IPv4 address of the VPC Endpoint:
        - In the AWS Console, go to VPC → Endpoints
        - Select your VPC Endpoint
        - Go to the Subnets tab and copy the IPv4 address
        - Run the following curl command to test the connection:
             ```bash
             curl <VPC_Endpoint_IP>
        - You should see the response: "Welcome, You are now accessing my Server!"
  Result: The Customer EC2 successfully accesses the web server in the Service VPC through the VPC Endpoint — without using the public internet.

[ Back to Top](#-Step-by-Step-deployment-guide)

---

  **FINALLY**
  Clean Up AWS Resources
To avoid incurring charges, delete all AWS resources created.
-  Terminate EC2 Instances
    - Navigate to EC2 → Instances.
    - Select all three EC2 instances (Webserver1, Customer_EC2, and any additional test instances).
    - Click Instance state → Terminate → Confirm.

- Delete VPC Endpoint
    - Navigate to VPC → Endpoints.
    - Select the Interface Endpoint you created.
    - Click Actions → Delete endpoint → Confirm.

- Delete Endpoint Service
    - Navigate to VPC → Endpoint Services.
    - Select your custom endpoint service.
    - Click Actions → Delete service endpoint.
    - Type delete when prompted and confirm.

- Delete Load Balancer and Target Group
    - Navigate to EC2 → Load Balancers.
    - Select MyNetwork-LB → Actions → Delete → Confirm.
    - Then go to EC2 → Target Groups.
    - Select MyNetwork-TG → Actions → Delete → Confirm.

- Delete VPCs and Attached Resources
    - Navigate to VPC → Your VPCs.
    - Select both Service_Network and Customer_Network.
    - Delete any attached subnets, route tables, internet gateways, and the VPCs themselves.

Result: All infrastructure has been safely removed from your AWS account.


**CONGRATULATIONS! You made it to the end!**

[ Back to Top](#-Step-by-Step-deployment-guide)
