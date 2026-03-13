# Super Analyzer Helm Chart

Simple chart — API + Postgres only. LLM endpoints are external.

## Setup

### 1. Create secrets.yaml
```bash
cp secrets.yaml.example secrets.yaml
echo "secrets.yaml" >> .gitignore
```

Edit `secrets.yaml` and fill in:
- `dbPassword`
- `adminApiKey`
- `chatApiKey` (nvapi-...)
- `jwtPrivateKey` / `jwtPublicKey` (base64 encoded)

Generate JWT keys if needed:
```bash
openssl genpkey -algorithm RSA -out jwt_private.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -in jwt_private.pem -pubout -out jwt_public.pem
cat jwt_private.pem | base64 -w0 && echo
cat jwt_public.pem  | base64 -w0 && echo
```

### 2. Install
```bash
kubectl create namespace code-analyzer

helm install super-analyzer . \
  --namespace code-analyzer \
  -f values.yaml \
  -f secrets.yaml
```

### 3. Watch pods come up
```bash
kubectl get pods -n code-analyzer -w
```

### 4. Get the external IP
```bash
kubectl get svc -n code-analyzer
```

## Upgrade
```bash
helm upgrade super-analyzer . \
  --namespace code-analyzer \
  -f values.yaml \
  -f secrets.yaml
```

## Uninstall
```bash
helm uninstall super-analyzer -n code-analyzer
kubectl delete pvc -n code-analyzer --all
kubectl delete namespace code-analyzer
```
