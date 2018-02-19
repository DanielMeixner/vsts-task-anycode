## AnyCode ##

This extension allows you to run any code in a docker container in Azure Container Instances

### Why is this awsome? ###
Using ACI (Azure Container Instances) form VSTS allows you to trigger any task that can be wrapped in a container from VSTS or TFS. This means you're no longer limited to what a specific agent provides - instead you fire up a container in ACI to do what you want it to do and run a given task. The logs of the container will be displayed in your VSTS logs.

### Quick steps to get started ###

Provide the following info: 
 - Service Prinicpal: Your ID for your service principal on Azure
 - Password: Password of your service prinicpal
 - Tenant: Azure tenant to be used

 - Resource Group: Resource Group on Azure (will be created if it doesn't exist)
 - Container Name: Name of your container instance.

 - image: Name of container image. Currently no login credentials for a custom registry can be used.
 - environment variables: If you want to pass environment variables put them in this field. Do not comma-separate them.


### Known issue(s) - READ THIS

Currently this is a very early version which serves rather as a proof of concept than a product. Here a some issues:

- Supports Linux Containers only
- Make sure you use self-terminating containers (task containers) - otherwise they will run forever and cost you money!
- Errors within the task are not captured (at all!)
- Configuration of ACI instance is limited 
- No support for custom container registry yet
- No support to pass & share files from and to the container in place (Workaround could be an additional environment variable you introduce)
- Service Prinicpal access required
- SP has to have permission to create resource groups
-

### Where's the source ###
Here: https://github.com/DanielMeixner/vsts-task-anycode 

### Minimum supported environments ###

- Visual Studio Team Services, didn't try it on TFS.



### Feedback ###
- Add a review below. I'm mostly interested if this seems valuable to you at all. Thanks a lot.
