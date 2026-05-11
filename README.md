# aliyun-hello-world

A simple Flask "Hello World" web application deployed to Alibaba Cloud SAE (Serverless App Engine) with RDS PostgreSQL, provisioned via Terraform and automated with GitHub Actions.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  Alibaba Cloud (cn-shanghai)                        │
│                                                     │
│  ┌───────────────┐         ┌──────────────────┐    │
│  │   ACR         │         │  VPC             │    │
│  │  (Container   │         │  172.16.0.0/16   │    │
│  │   Registry)   │         │                  │    │
│  └───────┬───────┘         │  ┌────────────┐  │    │
│          │                 │  │    SAE      │  │    │
│          └─────────────────┼─▶│  Flask App  │  │    │
│                            │  │  (port 8080)│  │    │
│                            │  └──────┬─────┘  │    │
│                            │         │        │    │
│                            │  ┌──────▼─────┐  │    │
│                            │  │    RDS      │  │    │
│                            │  │ PostgreSQL  │  │    │
│                            │  └────────────┘  │    │
│                            └──────────────────┘    │
└─────────────────────────────────────────────────────┘
```

## Project Structure

```
├── app/
│   ├── main.py              # Flask application
│   └── requirements.txt     # Python dependencies
├── infra/
│   ├── versions.tf          # Terraform + provider versions
│   ├── providers.tf         # Alicloud provider config
│   ├── variables.tf         # Input variables
│   ├── main.tf              # SAE + RDS resources
│   ├── outputs.tf           # Output values
│   └── terraform.tfvars.example
├── .github/workflows/
│   └── deploy.yml           # CI/CD pipeline
├── Dockerfile
└── README.md
```

## Local Development

```bash
cd app
pip install -r requirements.txt
python main.py
# Visit http://localhost:8080
```

## Deployment

### Prerequisites

1. An Alibaba Cloud account with:
   - A VPC and VSwitch in `cn-shanghai`
   - A Container Registry (ACR) namespace
   - An OSS bucket for Terraform state (`tf-state-aliyun-hello-world`)

2. GitHub repository secrets:

| Secret | Description |
|--------|-------------|
| `ALICLOUD_ACCESS_KEY` | Alibaba Cloud AccessKey ID |
| `ALICLOUD_SECRET_KEY` | Alibaba Cloud AccessKey Secret |
| `ALICLOUD_SECURITY_TOKEN` | STS token (optional, for temporary credentials) |
| `ACR_NAMESPACE` | ACR namespace name |
| `ACR_USERNAME` | ACR login username |
| `ACR_PASSWORD` | ACR login password |
| `DB_PASSWORD` | RDS master account password |

3. GitHub repository variables:

| Variable | Description |
|----------|-------------|
| `VPC_ID` | VPC ID (e.g., `vpc-uf6vg5xyemn2f6x2kyk5y`) |
| `VSWITCH_ID` | VSwitch ID (e.g., `vsw-uf6hand57whbdgg2berq7`) |

### Trigger Deployment

- **Automatic**: Push to `main` branch deploys to `dev`
- **Manual**: Use "Run workflow" in GitHub Actions, select target environment

### Manual Terraform

```bash
cd infra
export ALICLOUD_ACCESS_KEY="..."
export ALICLOUD_SECRET_KEY="..."

terraform init
terraform plan -var="image_url=registry.cn-shanghai.aliyuncs.com/ns/hello-world:v1" \
               -var="db_password=YourPassword123" \
               -var="vpc_id=vpc-xxx" \
               -var="vswitch_id=vsw-xxx"
terraform apply
```

## Endpoints

| Path | Description |
|------|-------------|
| `GET /` | Returns "Hello World!" |
| `GET /health` | Health check endpoint |
| `GET /db` | Tests database connectivity |
