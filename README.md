
I have been tasked by my organization to remediate vulnerabilities on all of our devices primarily through microsoft defender.  When a vulnerability can be remediate through a group policy,  the process is extremely satisfying.
Unfortunately my organization does not have a domain controller so my remediation/automation has to be done through microsoft intune.  
While this makes things slightly difficult as i am not as familiar with intune as i am with GPE most tasks can still be automated and completed, but not all...
one of the tasks that i could not figure out how to automate was "fixing unquoted pathways"

Any service on your device with an executable path should have " " surrouning its pathway or else it is considered an "unquoted Service Path"
As you can imagine,  this task has a simple fix:  if there are not quotations around the pathway,  add them.. 

The pathways can be found in the registry of your local machine (HKLM)
when editing the registry,  it is important to keep track of anything you change as it can cause serious damage to your device if done incorrectly. 
i reccomend taking screenshots of anything you edit so you can have a quick reference. 

the results of this script will vary based on the administrative permissions associated with the device running it.  

Make sure to run powershell as an administrator before running the script!

##############################
For proffessor McGeehan: 
I have provided screenshots of the resulting code when ran in powershell.   
unfortunately the code was configured specifically for my work computer so running the code on my personal device gives a slight error. 

i also provided screenshots instead of a recording because my screen recordings would not show the powershell script for some reason.
################################
