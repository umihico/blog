# blog

## How to start

1. Modify environment variables in `buildspec.yml`
1. Connect CodeBuild with Github (from blank project creation)
1. `terragrunt run-all apply`
1. Push development or main branch and things will be deployed.

## How to develop

### Use hot reload while coding or blogging

```bash
docker-compose up
```

### Export and browse files before uploading

```bash
docker-compose -f docker-compose.yml -f docker-compose.static.yml up
```
