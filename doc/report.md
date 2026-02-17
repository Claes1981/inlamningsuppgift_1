Tutorial
========================
## "Delmoment 1"

1. Create the web application locally by using the ASP.NET Core Web App .NET project template with `dotnet new mvc -n inlamningsuppgift_1`. It uses the Model-view-controller architectural pattern, which separation of concerns makes it easy to divide development of large complex applications between several developers[*](https://learn.microsoft.com/en-us/aspnet/mvc/overview/older-versions-1/overview/asp-net-mvc-overview#advantages-of-an-mvc-based-web-application). It also uses the client-server model where the ASP.NET Core application is the server, and the browser, which renders Razor views, act as client.
2. Create a "src" directory in the project directory, and move everything into it.
3. Edit the `src/Views/Home/Index.cshtml` file and add your name after "Welcome" in the heading tag.
4. Open the link provided in the output in step 1, in a browser and verify that your name is visible on the home page.

## "Delmoment 2"
1. Prepare the provision of a virtual machine in Azure by first copy the [provision_vm.sh](https://github.com/Claes1981/inlamningsuppgift_1/blob/main/src/scripts/provision_vm.sh) script to your local computer. This script uses Azure CLI for the provisioning. The *Standard_F1als_v7* in *northeurope*, zone *3* virtual machine size were the cheapest available last time I checked.  
With a script based provisioning method you apply Infrastructure as Code, which automatically gives you a documentation of exact (in principle) how the infrastucture is set up.
2. Run the script to execute the provisioning. 
3. Verify that the virtual machine is accessible by confirming that you can log in to the public ip address of the machine, provided by the script output, e g `ssh azureuser@ 52.155.250.77`.  
So far this solution only provide Infrastructure as a Service, since no application development tools are installed yet.





