# Google Cloud Cloud Run for CAS OCSP

```bash
export PROJECT_ID=$PROJECT_ID
export PROJECT_NUMBER=53532676736
```

CAS CA Poolが作成されているか確認

```bash
 gcloud privateca roots list --project=$PROJECT_ID
```

OCSP Responder Image Build

```bash
cd ./gcp-ca-service-ocsp
gcloud builds submit --project=$PROJECT_ID --tag asia-northeast1-docker.pkg.dev/$PROJECT_ID/ca-service-ocsp/ocsp-responder:1.0
```

OCSP Generator Image Build

```bash
cd ./gcp-ca-service-ocsp
gcloud builds submit --project=$PROJECT_ID --tag asia-northeast1-docker.pkg.dev/$PROJECT_ID/ca-service-ocsp/ocsp-generator:1.0
```

```bash
mv Dockerfile Dockerfile.svrocsp
mv Dockerfile.genocsp Dockerfile
```

```bash
mv Dockerfile Dockerfile.genocsp
mv Dockerfile.svrocsp Dockerfile
```
