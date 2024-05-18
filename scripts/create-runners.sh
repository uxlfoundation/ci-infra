#! /bin/bash -x

num_runners=2
project=onemkl


org=${project}-project
acct=${project}-project-github
runner_label=uxl-${project}-ubuntu-x86
root=$(eval echo ~${acct})/runners

runner_version=2.316.1
installer=actions-runner-linux-x64-${runner_version}.tar.gz
sudo -u ${acct} sh -c "rm -rf ${root} && mkdir -p ${root} && wget -P ${root} https://github.com/actions/runner/releases/download/v${runner_version}/${installer}"

for ((i=0; i<${num_runners}; i++)); do
  runner_name=${runner_label}-$i
  runner_path=${root}/${runner_name}
  token=$(gh api -X POST /orgs/${org}/actions/runners/registration-token | jq -r '.token')
  sudo -u ${acct} mkdir -p ${runner_path}
  sudo -u ${acct} tar zxf ${root}/${installer} -C ${runner_path}
  sudo -u ${acct} sh -c "cd ${runner_path} && ./config.sh --url https://github.com/${org} --token ${token} --name ${runner_name} --labels ${runner_label} --unattended --replace"
  sudo  sh -c "cd ${runner_path} && ./svc.sh install ${acct} && ./svc.sh start"
done
