#!/bin/bash

mkdir ~/bin
mkdir ~/tmp

### INSTALL AWS CLI
wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ~/tmp/awscliv2.zip
unzip -q ~/tmp/awscliv2.zip
sudo ~/aws/install -i ~/aws-cli -b ~/bin
sudo rm -rf ~/tmp/awscliv2.zip
sudo rm -rf ~/aws



### INSTALL AWS-IAM-AUTHENTICATOR
wget -O ~/bin/aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.3/aws-iam-authenticator_0.5.3_linux_amd64
chmod +x ~/bin/aws-iam-authenticator



### INSTALL KUBECTL
wget https://dl.k8s.io/release/v1.18.19/bin/linux/amd64/kubectl -O ~/bin/kubectl
chmod +x ~/bin/kubectl
kubectl version --short
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo "alias kg='kubectl get'" >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc


### INSTALL KUBECTX
mkdir -p ~/tmp/kubectx
wget https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubectx_v0.9.3_linux_x86_64.tar.gz -O ~/tmp/kubectx/kubectx.tar.gz
tar -xvzf ~/tmp/kubectx/kubectx.tar.gz -C ~/tmp/kubectx
chmod +x ~/tmp/kubectx
sudo mv ~/tmp/kubectx/kubectx ~/bin/kubectx
sudo rm -rf ~/tmp/kubectx

cat <<'EOF' >>~/.bashrc

alias kctx=kubectx
_kube_contexts()
{
  local curr_arg;
  curr_arg=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "- $(kubectl config get-contexts --output='name')" -- $curr_arg ) );
}
complete -F _kube_contexts kubectx kctx

EOF


### INSTALL KUBENS
mkdir -p ~/tmp/kubens
wget https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubens_v0.9.3_linux_x86_64.tar.gz -O ~/tmp/kubens/kubens.tar.gz
tar -xvzf ~/tmp/kubens/kubens.tar.gz -C ~/tmp/kubens
sudo mv ~/tmp/kubens/kubens ~/bin/kubens
sudo rm -rf ~/tmp/kubens

cat <<'EOF' >>~/.bashrc

alias kns=kubens
_kube_namespaces()
{
  local curr_arg;
  curr_arg=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "- $(kubectl get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')" -- $curr_arg ) );
}
complete -F _kube_namespaces kubens kns

EOF



### INSTALL FZF
mkdir -p ~/tmp/fzf
wget https://github.com/junegunn/fzf/releases/download/0.27.2/fzf-0.27.2-linux_amd64.tar.gz -O ~/tmp/fzf/fzf.tar.gz
tar -xvzf ~/tmp/fzf/fzf.tar.gz -C ~/tmp/fzf
chmod +x ~/tmp/fzf/fzf
sudo mv ~/tmp/fzf/fzf ~/bin/fzf
sudo rm -rf ~/tmp/fzf



### INSTALL KUBE_PS1
wget https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -O ~/bin/kube-ps1.sh

cat <<'EOF' >>~/.bashrc

KUBE_PS1_SYMBOL_ENABLE=true
KUBE_PS1_SYMBOL_USE_IMG=true
KUBE_PS1_SEPARATOR='' 
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_DIVIDER=' '
source ~/bin/kube-ps1.sh
PS1='\[\033[01;32m\]\u@\h \[\033[00m\]$(kube_ps1) \[\033[01;34m\]\w \[\e[0m\]$ '

EOF
