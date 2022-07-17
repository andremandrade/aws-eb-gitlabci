# CI/CD for Elastic Beanstalk app using Gitlab CI

## Setup your Git Lab Runner

```
# docker volume create virtushub-runner-config
# docker run --rm -it -v virtushub-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register
# docker run -d --name virtushub-runner --restart always -v /var/run/docker.sock:/var/run/docker.sock -v virtushub-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest
```
In your Gitlab project, go to **Settings >> CI/CD >> Runners**, and verify if your runner is listed as **Available specific runners**
## Setup Elasctic Beanstalk for your project

#### Pre-requirements
- You need Linux environment (theses steps were tested only in Linux Debian-based)
- Install AWS CLI and setup your credentials (run ```cat ~/.aws/credentials``` to verify if your credentials are setup)
- Copy ```eb``` folder and ```.gitlab-ci.yml``` from this project to your project

### Install EB CLI
Run:
```
# sh eb/install-eb.sh
```
Pay attention in the instructions in the end of the installation and execute them.

Verify the EB CLI installation running:
```
# eb --version
EB CLI 3.20.0 (Python 3.7.2)
```
### Setup EB in the project and create the EB application

Go to the branch of development environment (e.g. dev).
Run the first command (following are some suggested answers, adapt them to your project):
```
# eb init

Select a default region: 3) us-west-2 : US West (Oregon)

Select an application to use: [ Create new Application ]

Enter Application Name
(default is "[folder name]"): sample-eb

Select a platform branch: 1) Docker running on 64bit Amazon Linux 2

Do you wish to continue with CodeCommit? (Y/n): n

Select a keypair: [ Create new KeyPair ]
```

Using the AWS Console Elasctic Beanstalk interface you can verify if your application was created (pay attention in the selected region) 

### Create the development environment related to the development branch

#### Pre-requirements
- You need to have your project ready to run with ```docker-compose up``` (with docker-compose file in the root directory), if needed you can custom this scheme using [eb config](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-config.html)

Run the following command to verify that you don´t have an environment to your branch yet:
```
# eb status
ERROR: This branch does not have a default environment. You must either specify an environment by typing "eb status my-env-name" or set a default environment by typing "eb use my-env-name".
```
To an easier reuse of this project CI configuration, set your environment name as ```[application_name]-[brach_name]```.
```
eb create sample-eb-dev -i t2.medium -c sample-eb-dev
. 
. [AWS components configuration log]
.
INFO    Application available at sample-eb-dev.us-west-2.elasticbeanstalk.com
```
It can take some minutes because it automatically configure Security Groups, EC2 instance, Load Balancer and S3 (to store application versions) in order to provide your application ready to be accessed by the provided URL (e.g. sample-eb-dev.us-west-2.elasticbeanstalk.com as presented in the log)

Open the AWS EB Console and verify if your environment is ready. Access the provided URL (e.g sample-eb-dev.us-west-2.elasticbeanstalk.com) to access your application.

### Setup and test CI/CD configuration

#### Create CI/CD variables (AWS credentials)

In your Gitlab project, got to ```Settings >> CI/CD >> Variables``` and add the following variable with your AWS credentials as values:
- aws_access_key_id
- aws_secret_access_key

For the first tests, you can create as NOT PROTECTED.
When it´s working, it´s recommended you invadate the your test credentials, create new ones and update the variables setting as PROTECTED (in this case, they only work for protected branches)

#### Setup CI/CD in the project files

Add ```.elasticbeanstalk``` to git tracking (there is no sensible information in this folder)
```
git add .elasticbeanstalk/
```

Edit the line 62 of ```.gitlab-ci.yml``` file using your application name instead of ```sample-eb```

```
 line 62|   - eb use sample-eb-$CI_COMMIT_REF_NAME

# Change to - eb use myappname-$CI_COMMIT_REF_NAME
```

Add ```.gitlab-ci.yml``` to git tracking 
```
git add .gitlab-ci.yml
```
Apply any change in your code that allow you verify if a new version was deployed

Commit and push to the ```dev``` remote branch.

Verify the CI/CD jobs execution in your Gitlab project.
It the job had succeed, access the application using the same previous URL and verify your new version is deployed.

### Create the test environment related to the test branch

From the dev branch, checkout the test branch
```
git checkout -b test
```
Create the test EB environment
```
eb create sample-eb-test -i t2.medium -c sample-eb-test
```
Add, commit and push the ```.elasticbeanstalk``` changes.
Verify the CI/CD jobs execution in your Gitlab project.
It the job had succeed, access the application using the same previous URL and verify your new version is deployed.
