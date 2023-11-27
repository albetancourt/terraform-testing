#!/bin/bash

GH_DIFF_OUTPUT=$(cat << 'EOF'
infra/modules/security/main.tf
infra/dev/main.tf
services/payment/modules/notification/variables.tf
infra/modules/security/variables.tf
services/payment/payment.go
infra/modules/module-01/main.tf
EOF
)

MODULE_FOLDERS=$(echo "$GH_DIFF_OUTPUT" | grep -oP '^((infra/modules/.*)(?=/))|((services/.*/modules/.*)(?=/))' | sort | uniq)

echo "$MODULE_FOLDERS"
