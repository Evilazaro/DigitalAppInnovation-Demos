Azure Technical Demos for Digital App and Innovation
====================================================

This repository contains a collection of Azure technical demos specifically designed for digital app and innovation scenarios. Each demo provides a hands-on experience with Azure services and showcases how they can be utilized to build innovative and scalable applications.

Table of Contents
-----------------

-   [Introduction](#introduction)
-   [Prerequisites](#prerequisites)
-   [Getting Started](#getting-started)
-   [Content](#content)
-   [Contributing](#contributing)
-   [License](#license)

Introduction
------------

In the world of digital app and innovation, Azure provides a wide range of services and capabilities that enable developers to create cutting-edge applications. This repository aims to demonstrate the power of Azure services through hands-on demos, allowing you to explore and understand their potential in real-world scenarios.

Prerequisites
-------------

Before running the demos, ensure that you have the following prerequisites:

**Windows**

1.  VS Code: [Install VS Code]((https://code.visualstudio.com/))
2.  VS Code Extensions for Azure: [Install VS Code Extensions for Azure](https://marketplace.visualstudio.com/search?term=Azure&target=VSCode&category=All%20categories&sortBy=Relevance)
3.  VS Code Extensions for GitHub: [Install VS Code Extensions for GitHub](https://marketplace.visualstudio.com/search?term=GitHub&target=VSCode&category=All%20categories&sortBy=Relevance)
4.  Azure subscription: You will need an active Azure subscription to deploy and test the demos.
5.  Azure CLI: [Install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) tool to manage Azure resources and interact with Azure services via the command line.
6.  **Other specific prerequisites for each demo can be found in their respective folders.**

**MAC OS**

Comming soon

Getting Started
---------------

To get started with a demo, follow these steps:

1.  Clone this repository to your local machine:
``````bash
    git clone https://github.com/Evilazaro/DigitalAppInnovation-Demos.git
``````
2.  There are three folders you can navigate to check all the demos available. The folders are Cloud-Native, DevOps, and Integration. 

    Navigate to the demo folder you are interested in:
``````bash
    cd Cloud-Native 
    or
    cd DevOps
    or
    cd Integration
``````
3. Open VS Code on the respective folder
``````bash
    code .
``````
![image](/imgs/Screenshot%202023-07-11%20160525.png)

4.  Follow the instructions provided in the demo's README.md file to set up and run the demo.

Content
-----

The following demos are currently available in this repository:

**Cloud-Native Applications**: Cloud native applications are built from the ground up---optimized for cloud scale and performance. They're based on microservices architectures, use managed services, and take advantage of continuous delivery to achieve reliability and faster time to market.

- [Cloud-Native Apps Content](/Cloud-Native/)
    - [Containers](/Cloud-Native/Containers/)
    - [AKS](/Cloud-Native/Containers/AKS/)
    - [Docker](/Cloud-Native/Containers/Docker/)


**DevOps**: DevOps combines development (Dev) and operations (Ops) to unite people, process, and technology in application planning, development, delivery, and operations. DevOps enables coordination and collaboration between formerly siloed roles like development, IT operations, quality engineering, and security. Teams adopt DevOps culture, practices, and tools to increase confidence in the applications they build, respond better to customer needs, and achieve business goals faster. DevOps helps teams continually provide value to customers by producing better, more reliable products.

- [DevOps Content][devops]
    - [Continuous-Collaboration][CC]
    - [Continuous-Delivery][CD]
    - [Continuous-Improvement][CIMP]
    - [Continuous-Integration][CI]
    - [Continuous-Operations][CO]
    - [Continuous-Planning](/DevOps/Continuous-Planning/)
    - [Continuous-Quality][CQ]
    - [Continuous-Security][CS]

**Integration**: Build new, integrated solutions that connect applications and services on-premises and in the cloud. Bring your business workflows together so they're consistent and scalable. Expose your APIs for developers and create opportunities for new business models.

- [Integration Content][int]
    - [API-Management][apim]
    - [Event-Grid][egrid]
    - [Logic-Apps][LA]
    - [Service-Bus][SBUS]

Each demo folder contains detailed instructions and resources to help you set up and run the demo on Azure.

Contributing
------------

Contributions to this repository are welcome! If you would like to contribute, please follow these guidelines:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Commit your changes and push the branch to your fork.
4.  Submit a pull request with a clear description of your changes.

Please ensure that your contributions align with the purpose and scope of this repository.

License
-------

This repository is licensed under the [MIT License](https://chat.openai.com/LICENSE). Feel free to use and modify the demos according to the terms of this license.

[CS]: /DevOps/Continuous-Security/
[CQ]: /DevOps/Continuous-Quality/
[CO]: /DevOps/Continuous-Operations/
[CI]: /DevOps/Continuous-Integration/
[CIMP]: /DevOps/Continuous-Improvement/
[CD]: /DevOps/Continuous-Delivery/
[CC]: /DevOps/Continuous-Collaboration/
[devops]: /DevOps/
[SBUS]: /Integration/Service-Bus/
[LA]: /Integration/Logic-Apps/
[egrid]: /Integration/Event-Grid/
[apim]: /Integration/API-Management/
[int]: /Integration/