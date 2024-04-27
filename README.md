# DirectoryStructure

```bash
├── README.md
├── enviroments
│   └── stg
│       ├── api
│       │   └── tfstate_backend.tf
│       ├── common
│       │   └── tfstate_backend.tf
│       └── web
│           ├── cloudfront.tf
│           ├── provider.tf -> ../../../shared/provider.tf
│           ├── s3.tf
│           ├── terraform.tfvars
│           ├── tfstate_backend.tf
│           ├── variable.tf -> ../../../shared/variable.tf
│           └── version.tf -> ../../../shared/version.tf
├── modules
│   ├── cloudfront
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── provider.tf
│   │   └── variable.tf
│   └── s3
│       ├── main.tf
│       ├── output.tf
│       ├── provider.tf
│       └── variable.tf
└── shared
    ├── provider.tf
    ├── variable.tf
    └── version.tf
```