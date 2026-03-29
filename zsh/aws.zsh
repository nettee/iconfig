export K8S_CTX_REFLY_PROD='arn:aws:eks:us-east-1:186593931982:cluster/refly-prod-eks'
export K8S_CTX_REFLY_TEST='arn:aws:eks:us-east-1:186593931982:cluster/refly-test-eks'
export K8S_CTX_NEXU_PROD='arn:aws:eks:us-east-1:186593931982:cluster/nexu-prod-eks'
export K8S_CTX_NEXU_TEST='arn:aws:eks:us-east-1:186593931982:cluster/nexu-test-eks'

alias r-kprod='kubectl --context "$K8S_CTX_REFLY_PROD"'
alias r-ktest='kubectl --context "$K8S_CTX_REFLY_TEST"'
alias n-kprod='kubectl --context "$K8S_CTX_NEXU_PROD"'
alias n-ktest='kubectl --context "$K8S_CTX_NEXU_TEST"'

alias n-kinit-prod='aws eks update-kubeconfig --region us-east-1 --name nexu-prod-eks'
alias n-kinit-test='aws eks update-kubeconfig --region us-east-1 --name nexu-test-eks'
