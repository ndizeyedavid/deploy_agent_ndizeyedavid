# Automated Project Bootstrapping & Process Management

This project is an automated project setup agent that is designed to safely deploy and share the workspace for the Attendance Tracker application.

## How to run it

1. Clone the repository

```bash
git clone https://github.com/ndizeyedavid/deploy_agent_ndizeyedavid
cd deploy_agent_ndizeyedavid
```

2. Grant the execute permission

```bash
chmod +x setup_project.sh
```

3. Running the script

```bash
./setup_project.sh
```
4. Testing the Intrupt sequence

```bash
Ctrl + C
```
You can send the inturpt signal with this shorcut on any stage of the setup_script inference, and it will trigger the archive_workspace function

5. How to procced on the archived version

You may just run the script again(setup_script.sh) use the same variation name as the one that was archived. The script will automatically detect it and prompt you if you want to proceed with it, or generate a brand new workspace

