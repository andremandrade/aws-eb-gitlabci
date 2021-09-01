# Sample Elastic Beanstalk CI/CD

## Setup your Git Lab Runner

```
# docker volume create virtushub-runner-config
# docker run --rm -it -v virtushub-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register
# docker run -d --name virtushub-runner --restart always -v /var/run/docker.sock:/var/run/docker.sock -v virtushub-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest
```



